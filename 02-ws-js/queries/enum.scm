(sequence_expression
  (parenthesized_expression
	(assignment_expression
    left: (member_expression
          (identifier) @_n
          (property_identifier) @enum_name
          (#eq? @_n "n"))
    right: (parenthesized_expression (sequence_expression
      left: (parenthesized_expression
              (assignment_expression
                left: (identifier) @_var
                right: (object . "{" . "}" . )))
      right: (sequence_expression
               left: (parenthesized_expression
                       (assignment_expression
                         left: (subscript_expression
                           object: (parenthesized_expression
                             (assignment_expression
                                left: (identifier) @object
                                "="
                                right: (call_expression
                                         function: (member_expression
                                                     object: (identifier) @_object
                                                     "."
                                                     property: (property_identifier) @_create
                                                     (#eq? @_object "Object")
                                                     (#eq? @_create "create"))
                                         arguments: (arguments . "(" (identifier) @_var2 . ")" .
                                                     (#eq? @_var @_var2)))))
                           index: (parenthesized_expression
                                    (assignment_expression
                                      left: (subscript_expression)
                                      right: (string (string_fragment) @enum_field))))
                         right: (number) @enum_value)

))) @stage2
))))
