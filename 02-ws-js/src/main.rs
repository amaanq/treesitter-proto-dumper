use std::collections::BTreeMap;
use std::fmt::Write;

use heck::{ToShoutySnakeCase, ToSnakeCase};
use tree_sitter::{Parser, Query, QueryCursor, Tree};

struct Message {
    name: String,
    id: Option<i32>,
    fields: Vec<Field>,
}

struct Field {
    id: i32,
    name: String,
    _type: FieldType,
}

#[derive(Clone, Debug)]
enum FieldType {
    Single(String),
    Repeated(String),
    Map(String, String),
}

struct Enum {
    name: String,
    fields: Vec<(String, i32)>,
}

type MessageDump = BTreeMap<String, Message>;
type EnumDump = BTreeMap<String, Enum>;

struct State {
    parser: Parser,

    cursor: QueryCursor,

    message_tree: Option<Tree>,

    code_bytes: Vec<u8>,

    messages: MessageDump,
    message_query: Query,

    enums: EnumDump,
    enum_query: Query,

    id_query: Query,

    protodump_str: String,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut state = State {
        parser: {
            let mut parser = Parser::new();
            parser.set_language(tree_sitter_javascript::language())?;
            parser
        },

        cursor: QueryCursor::new(),

        message_tree: None,

        code_bytes: std::fs::read("Net/Protocol.js")?,

        messages: MessageDump::new(),
        message_query: Query::new(
            tree_sitter_javascript::language(),
            &std::fs::read_to_string("queries/message.scm")?,
        )?,

        enums: EnumDump::new(),
        enum_query: Query::new(
            tree_sitter_javascript::language(),
            &std::fs::read_to_string("queries/enum.scm")?,
        )?,

        id_query: Query::new(
            tree_sitter_javascript::language(),
            &std::fs::read_to_string("queries/id.scm")?,
        )?,

        protodump_str: String::new(),
    };

    state.message_tree = Some(state.parser.parse(&state.code_bytes, None).unwrap());

    state.protodump_str.push_str("syntax = \"proto3\";\n\n");

    parse_messages(&mut state)?;

    parse_enums(&mut state)?;

    map_ids_to_messages(&mut state)?;

    for message in state.messages.values() {
        writeln!(
            state.protodump_str,
            "message {} {{{}",
            message.name,
            if let Some(id) = message.id {
                format!(" // MessageId: {id}")
            } else {
                String::new()
            }
        )?;

        write!(
            state.protodump_str,
            "{}",
            message
                .fields
                .iter()
                .fold(String::new(), |mut output, field| {
                    let _ = writeln!(
                        output,
                        "  {} {} = {};",
                        match &field._type {
                            FieldType::Single(t) => t.clone(),
                            FieldType::Repeated(t) => format!("repeated {t}"),
                            FieldType::Map(k, v) => format!("map<{k}, {v}>"),
                        },
                        field.name.to_snake_case(),
                        field.id
                    );
                    output
                })
        )?;

        writeln!(state.protodump_str, "}}\n")?;
    }

    for en in state.enums.values() {
        writeln!(state.protodump_str, "enum {} {{", en.name)?;

        write!(
            state.protodump_str,
            "{}",
            en.fields.iter().fold(String::new(), |mut output, field| {
                let _ = writeln!(
                    output,
                    "  {}_{} = {};",
                    en.name.to_shouty_snake_case(),
                    field.0.to_shouty_snake_case(),
                    field.1
                );
                output
            })
        )?;

        writeln!(state.protodump_str, "}}\n")?;
    }

    state.protodump_str = state.protodump_str.trim_end().to_string();

    std::fs::write("message.proto", state.protodump_str)?;

    Ok(())
}

/// Handle js's `1e5` case, sigh
fn replace_exp(exp: &mut String) {
    let idx_of_e = exp.find('e').unwrap();
    *exp = (exp[..idx_of_e].parse::<i32>().unwrap()
        * 10i32.pow(exp[idx_of_e + 1..].parse().unwrap()))
    .to_string();
}

fn parse_messages(state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    let mut qc = QueryCursor::new();

    let matches = qc.matches(
        &state.message_query,
        state.message_tree.as_ref().unwrap().root_node(),
        state.code_bytes.as_slice(),
    );

    let message_name_idx = state
        .message_query
        .capture_index_for_name("message_name")
        .unwrap();
    let field_id_idx = state
        .message_query
        .capture_index_for_name("field_id")
        .unwrap();
    let field_name_idx = state
        .message_query
        .capture_index_for_name("field_name")
        .unwrap();
    let field_type_idx = state
        .message_query
        .capture_index_for_name("field_type")
        .unwrap();

    // repeated fields
    let push_idx = state.message_query.capture_index_for_name("push").unwrap();

    // map fields
    let kv_id_idx = state.message_query.capture_index_for_name("kv_id").unwrap();
    let kv_field_type_idx = state
        .message_query
        .capture_index_for_name("kv_field_type")
        .unwrap();

    let mut field_type = None;
    let mut do_push = true;

    for m in matches {
        if m.captures.is_empty() {
            continue;
        }

        let mut message_name = String::new();
        let mut field_id = String::new();
        let mut field_name = String::new();
        let mut kv_field_id = 0;

        for capture in m.captures {
            let node_text = capture
                .node
                .utf8_text(state.code_bytes.as_slice())?
                .to_string();

            if capture.index == message_name_idx {
                message_name = node_text;
            } else if capture.index == field_id_idx {
                field_id = node_text;
            } else if capture.index == field_name_idx {
                field_name = node_text;
            } else if capture.index == field_type_idx {
                if let Some(FieldType::Repeated(ref mut t)) = field_type {
                    *t = node_text;
                } else {
                    field_type = Some(FieldType::Single(node_text));
                }
            } else if capture.index == push_idx {
                if let Some(FieldType::Single(text)) = field_type {
                    field_type = Some(FieldType::Repeated(text));
                } else {
                    field_type = Some(FieldType::Repeated(String::new()));
                }
            } else if capture.index == kv_id_idx {
                kv_field_id = node_text.parse()?;
            } else if capture.index == kv_field_type_idx {
                if let Some(FieldType::Map(ref mut key_type, ref mut value_type)) = field_type {
                    if kv_field_id == 1 {
                        *key_type = node_text;
                    } else if kv_field_id == 2 {
                        *value_type = node_text;
                    } else {
                        panic!("Unexpected kv_field_id: {kv_field_id}");
                    }
                    do_push = true;
                } else {
                    field_type = if kv_field_id == 1 {
                        Some(FieldType::Map(node_text, String::new()))
                    } else if kv_field_id == 2 {
                        Some(FieldType::Map(String::new(), node_text))
                    } else {
                        panic!("Unexpected kv_field_id: {kv_field_id}");
                    };
                    do_push = false;
                }
            }
        }

        if do_push {
            if state.messages.contains_key(&message_name) {
                state
                    .messages
                    .get_mut(&message_name)
                    .unwrap()
                    .fields
                    .push(Field {
                        id: field_id.parse()?,
                        name: field_name,
                        _type: field_type.unwrap(),
                    });
            } else {
                state.messages.insert(
                    message_name.clone(),
                    Message {
                        name: message_name,
                        id: None,
                        fields: vec![Field {
                            id: field_id.parse()?,
                            name: field_name,
                            _type: field_type.unwrap(),
                        }],
                    },
                );
            }

            field_type = None;
        }
    }

    Ok(())
}

fn parse_enums(state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    let enum_name_idx = state
        .enum_query
        .capture_index_for_name("enum_name")
        .unwrap();
    let enum_field_idx = state
        .enum_query
        .capture_index_for_name("enum_field")
        .unwrap();
    let enum_value_idx = state
        .enum_query
        .capture_index_for_name("enum_value")
        .unwrap();

    let matches = state.cursor.matches(
        &state.enum_query,
        state.message_tree.as_ref().unwrap().root_node(),
        state.code_bytes.as_slice(),
    );

    for m in matches {
        if m.captures.is_empty() {
            continue;
        }

        let mut enum_name = String::new();
        let mut enum_objects: Vec<(String, i32)> = Vec::new();
        let mut current_enum_field = String::new();
        let mut current_enum_value = String::new();

        for capture in m.captures {
            let node_text = capture
                .node
                .utf8_text(state.code_bytes.as_slice())?
                .to_string();

            if capture.index == enum_name_idx {
                enum_name = node_text;
            } else if capture.index == enum_field_idx {
                current_enum_field = node_text;
            } else if capture.index == enum_value_idx {
                current_enum_value = node_text;
                if current_enum_value.contains('e') {
                    replace_exp(&mut current_enum_value);
                }
            }
        }

        enum_objects.push((current_enum_field, current_enum_value.parse().unwrap()));

        if state.enums.contains_key(&enum_name) {
            state
                .enums
                .get_mut(&enum_name)
                .unwrap()
                .fields
                .extend(enum_objects);
        } else {
            state.enums.insert(
                enum_name.clone(),
                Enum {
                    name: enum_name,
                    fields: enum_objects,
                },
            );
        }
    }

    Ok(())
}

fn map_ids_to_messages(state: &mut State) -> Result<(), Box<dyn std::error::Error>> {
    let id_query = Query::new(
        tree_sitter_javascript::language(),
        &std::fs::read_to_string("queries/id.scm")?,
    )?;

    let message_name_idx = id_query.capture_index_for_name("message_name").unwrap();
    let message_id_idx = id_query.capture_index_for_name("message_id").unwrap();

    let code = std::fs::read_to_string("Net/NetDefine.js")?;

    let tree = state.parser.parse(&code, None).unwrap();

    let mut qc = QueryCursor::new();

    let matches = qc.matches(&state.id_query, tree.root_node(), code.as_bytes());

    for m in matches {
        if m.captures.is_empty() {
            continue;
        }

        let mut message_name = String::new();
        let mut message_id = String::new();

        for capture in m.captures {
            let node_text = capture.node.utf8_text(code.as_bytes())?.to_string();

            if capture.index == message_name_idx {
                message_name = node_text;
            } else if capture.index == message_id_idx {
                message_id = node_text;
            }
        }

        if state.messages.contains_key(&message_name) {
            if message_id.contains('e') {
                replace_exp(&mut message_id);
            }

            state.messages.get_mut(&message_name).unwrap().id = Some(message_id.parse().unwrap());
        }
    }

    Ok(())
}
