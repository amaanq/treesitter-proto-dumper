from typing import Dict, List, Tuple
from tree_sitter import Language, Node, Parser
from dataclasses import dataclass

js = "./js.so"

JS = Language(js, "javascript")
parser = Parser()
parser.set_language(JS)

q = open("queries/message.scm").read()
query = JS.query(q)

tree = parser.parse(open("Net/Protocol.js", "rb").read())

matches = query.matches(tree.root_node)


@dataclass
class Proto:
    name: str
    fields: List[Tuple[int, str, str]]


protos: Dict[str, Proto] = {}

# [(<Node type=identifier, start_point=(54940, 13), end_point=(54940, 14)>, '_n'), (<Node type=property_identifier, start_point=(54940, 15), end_point=(54940, 40)>, 'message_name'), (<Node type=property_identifier, start_point=(54953, 20), end_point=(54953, 26)>, '_decode'), (<Node type=number, start_point=(54957, 38), end_point=
# (54957, 39)>, '_shift3'), (<Node type=number, start_point=(54961, 33), end_point=(54961, 34)>, 'field_id'), (<Node type=property_identifier, start_point=(54962, 34), end_point=(54962, 47)>, 'field_name'), (<Node type=property_identifier, start_point=(54962, 52), end_point=(54962, 57)>, 'field_type')]

match: List[Tuple[Node, str]]
for e, (_, match) in enumerate(matches):
    if len(match) == 0:
        continue

    m: Node
    message_name, field_id, field_name, field_type = "", "", "", ""
    for node, capture_name in match:
        # offsets for the items might vary from each one,
        match capture_name:
            case "message_name":
                message_name = node.text.decode("utf-8")
                break
            case "field_id":
                field_id = node.text.decode("utf-8")
                break
            case "field_name":
                field_name = node.text.decode("utf-8")
                break
            case "field_type":
                field_type = node.text.decode("utf-8")
                break
            case _:
                continue

    print(f"{message_name} {field_id} {field_name} {field_type}")

    if message_name not in protos:
        protos[message_name] = Proto(e, message_name, [(int(field_id), field_name, field_type)])
    else:
        protos[message_name].fields.append((int(field_id), field_name, field_type))

proto_dump = ""
for message in protos.values():
    proto_dump += f"message {message.name} {{\n"
    for field in message.fields:
        proto_dump += f"  {field[2]} {field[1]} = {field[0]};\n"
    proto_dump += "}\n\n"


with open("message.proto", "w") as f:
    f.write(proto_dump)
