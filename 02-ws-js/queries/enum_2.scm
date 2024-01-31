(assignment_expression
  left: (subscript_expression
          object: ((identifier) @object_name (#eq? @object_name "REPLACEME"))
          index: (parenthesized_expression
                   (assignment_expression
                     left: (subscript_expression)
                     right: (string (string_fragment) @enum_field))))
  right: (number) @enum_value)
