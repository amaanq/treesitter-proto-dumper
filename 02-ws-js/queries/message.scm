(sequence_expression
  (parenthesized_expression
	(assignment_expression
    left: (member_expression
          (identifier) @_n
          (property_identifier) @message_name
          (#eq? @_n "n"))
    right: (parenthesized_expression (sequence_expression
      right: (sequence_expression
        right: (sequence_expression
          left: (parenthesized_expression (assignment_expression
            left: (member_expression (identifier) (property_identifier) @_decode (#eq? @_decode "decode"))
            right: (function
              body: (statement_block (for_statement
                body: (statement_block
                  [
                  (switch_statement
                     value: (parenthesized_expression
                          (binary_expression
                            left: (identifier)
                            ">>>"
                            right: (number) @_shift3
                            (#eq? @_shift3 "3")))
                     body:
                       (switch_body (switch_case
                         value: (number) @field_id
                         body: (expression_statement
                                (assignment_expression
                                left: (member_expression (identifier) (property_identifier) @field_name)
                                right: [
                                        (call_expression
                                          function: (member_expression
                                          object: (identifier)
                                          property: (property_identifier) @field_type))

                                        (call_expression
                                          function: (member_expression
                                            object: (member_expression
                                              object: (member_expression) @_rootakiprotocol
                                              property: (property_identifier) @field_type
                                              (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                            property: (property_identifier) @_decode_field
                                            (#eq? @_decode_field "decode")))
                                       ])))))

                  (expression_statement
                    (ternary_expression
                           condition: (binary_expression
                             left: (binary_expression
                               left: (identifier)
                               ">>>"
                               right: (number) @_shift3
                               (#eq? @_shift3 "3"))
                             "=="
                             right: (number) @field_id)

                           consequence: (parenthesized_expression
                            (assignment_expression
                              left: (member_expression (identifier) (property_identifier) @field_name)
                              right: [
                                      (call_expression
                                        function: (member_expression
                                        object: (identifier)
                                        property: (property_identifier) @field_type))

                                      (call_expression
                                          function: (member_expression
                                            object: (member_expression
                                              object: (member_expression) @_rootakiprotocol
                                              property: (property_identifier) @field_type
                                              (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                            property: (property_identifier) @_decode_field
                                            (#eq? @_decode_field "decode")))
                                     ]))))
                  ]
)))))))))))))
