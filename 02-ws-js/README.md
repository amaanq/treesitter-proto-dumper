# WW Proto Dumper (Tree-Sitter ❤️ Reverse Engineering)

This is a PoC and demo to show how one can use tree-sitter on dumped javascript
netcode files for a certain game to extract fully intact proto files. To see its
potential, you can run the following (replace `"REPLACEME"` in enum_2.scm with `"e"`):

The Python code was my initial attempt at this, but my partially-implemented
matches API had a bug, so I just opted to go with Rust.

```bash
tree-sitter query queries/message.scm example_protocol.js
```

```bash
tree-sitter query queries/enum.scm example_protocol.js
```

```bash
tree-sitter query queries/enum_2.scm example_protocol.js
```

```bash
tree-sitter query queries/id.scm example_define.js
```
