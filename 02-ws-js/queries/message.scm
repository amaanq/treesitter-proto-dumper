(sequence_expression
  (parenthesized_expression
	(assignment_expression
    left: (member_expression
            object:
              [
                ; n.Message
                ((identifier) @_n
                  (#eq? @_n "n"))

                ; (n = {}).Message
                (parenthesized_expression
                  (assignment_expression
                    left: (identifier) @_n
                    "="
                    right: (object . "{" . "}"))
                  (#eq? @_n "n"))
              ]
            property: (property_identifier) @message_name)
    right: (parenthesized_expression
             (sequence_expression
               (parenthesized_expression
                 (assignment_expression
                   left: (member_expression
                          (identifier)
                          (property_identifier) @_decode
                          (#eq? @_decode "decode"))
                   right: (function_expression
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
                                  body: [
                                          (expression_statement
                                            [
                                              ; Single items
                                              (assignment_expression
                                              left: (member_expression (identifier) (property_identifier) @field_name)
                                              right: [
                                                      ; Single primitive
                                                      (call_expression
                                                        function: (member_expression
                                                        object: (identifier)
                                                        property: (property_identifier) @field_type))

                                                      ; Single non-primitive
                                                      (call_expression
                                                        function: (member_expression
                                                          object: (member_expression
                                                            object: (member_expression) @_rootakiprotocol
                                                            property: (property_identifier) @field_type
                                                            (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                          property: (property_identifier) @_decode_field
                                                          (#eq? @_decode_field "decode")))
                                                    ])

                                              ; Repeated items
                                              (sequence_expression
                                                (binary_expression)
                                                (call_expression
                                                  function: (member_expression
                                                    object: (member_expression
                                                            object: (identifier)
                                                            property: (property_identifier) @field_name)
                                                    property: ((property_identifier) @push
                                                              (#eq? @push "push")))

                                                  arguments: (arguments
                                                    [
                                                      ; Repeated primitive
                                                      (call_expression
                                                        function: (member_expression
                                                          object: (identifier)
                                                          property: (property_identifier) @field_type))

                                                      ; Repeated non-primitive
                                                      (call_expression
                                                        function: (member_expression
                                                          object: (member_expression
                                                            object: (member_expression) @_rootakiprotocol
                                                            property: (property_identifier) @field_type
                                                            (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                          property: (property_identifier) @_decode_field
                                                          (#eq? @_decode_field "decode")))
                                                    ])
                                              ))

                                              ; Map items
                                              (binary_expression
                                                left: (binary_expression
                                                  left: (member_expression
                                                          (identifier)
                                                          (property_identifier) @field_name)
                                                  operator: "==="
                                                  right: (member_expression) @_util_emptyobject
                                                  (#eq? @_util_emptyobject "$util.emptyObject")))
                                            ])

                                          (if_statement
                                            consequence: (for_statement
                                              body: (expression_statement
                                                    (call_expression
                                                      function: (member_expression
                                                        object: (member_expression
                                                                object: (identifier)
                                                                property: (property_identifier) @field_name)
                                                        property: ((property_identifier) @push
                                                                  (#eq? @push "push")))
                                                      arguments: (arguments
                                                        [
                                                          ; Repeated primitive
                                                          (call_expression
                                                            function: (member_expression
                                                              object: (identifier)
                                                              property: (property_identifier) @field_type))
                                                          ; Repeated non-primitive
                                                          (call_expression
                                                            function: (member_expression
                                                              object: (member_expression
                                                                object: (member_expression) @_rootakiprotocol
                                                                property: (property_identifier) @field_type
                                                                (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                              property: (property_identifier) @_decode_field
                                                              (#eq? @_decode_field "decode")))
                                                        ])
                                          ))))
                                        ]
                                  body: (variable_declaration)?
                                  ; Map body, if present, in some cases there's a statement block, in some it's a switch statement
                                  ; seems like some cases with inlined assigns omit the braces - for (s = "", c = null; t.pos < a;) switch ((u = t.uint32()) >>> 3) { ... }
                                  body: (for_statement
                                          body: [
                                                  (statement_block
                                                    (switch_statement
                                                      (switch_body
                                                        (switch_case
                                                          "case"
                                                          value: ((number) @kv_id (#any-of? @kv_id "1" "2"))
                                                          body: (expression_statement
                                                                  [
                                                                    ; Primitive map item
                                                                    (assignment_expression
                                                                      right: (call_expression
                                                                        function: (member_expression
                                                                          object: (identifier)
                                                                          property: (property_identifier) @kv_field_type))
                                                                    )

                                                                    ; Non-primitive map item
                                                                    (assignment_expression
                                                                      right: (call_expression
                                                                        function: (member_expression
                                                                          object: (member_expression
                                                                            object: (member_expression) @_rootakiprotocol
                                                                            property: (property_identifier) @kv_field_type
                                                                            (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                                          property: (property_identifier) @_decode_field
                                                                          (#eq? @_decode_field "decode")))
                                                                    )
                                                                  ]
                                                        ))
                                                  )))

                                                  ; Due to inlined assignment in the switch case, we need this duplication
                                                  ; e.g. switch ((u = t.uint32()) >>> 3) instead of var u = t.uint32(); switch (u >>> 3)
                                                  (switch_statement
                                                    (switch_body
                                                      (switch_case
                                                        "case"
                                                        value: ((number) @kv_id (#any-of? @kv_id "1" "2"))
                                                        body: (expression_statement
                                                                [
                                                                  ; Primitive map item
                                                                  (assignment_expression
                                                                    right: (call_expression
                                                                      function: (member_expression
                                                                        object: (identifier)
                                                                        property: (property_identifier) @kv_field_type))
                                                                  )

                                                                  ; Non-primitive map item
                                                                  (assignment_expression
                                                                    right: (call_expression
                                                                      function: (member_expression
                                                                        object: (member_expression
                                                                          object: (member_expression) @_rootakiprotocol
                                                                          property: (property_identifier) @kv_field_type
                                                                          (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                                        property: (property_identifier) @_decode_field
                                                                        (#eq? @_decode_field "decode")))
                                                                  )
                                                                ]
                                                      ))
                                                  ))
                                                ]
                                        )?
                           )))

                           ; Single field ternary
                           ; i >>> 3 == 1 ? (r.Field = t.decodeMethod()) : ...
                           (expression_statement
                             (ternary_expression
                                    condition: (binary_expression
                                      left: (binary_expression
                                        left: (identifier)
                                        operator: ">>>"
                                        right: (number) @_shift3
                                        (#eq? @_shift3 "3"))
                                      "=="
                                      right: (number) @field_id)

                                    consequence: (parenthesized_expression
                                      [
                                        ; Single items
                                        (assignment_expression
                                          left: (member_expression (identifier) (property_identifier) @field_name)
                                          right: [
                                                  ; Single primitive
                                                  (call_expression
                                                    function: (member_expression
                                                    object: (identifier)
                                                    property: (property_identifier) @field_type))

                                                  ; Single non-primitive
                                                  (call_expression
                                                    function: (member_expression
                                                      object: (member_expression
                                                        object: (member_expression) @_rootakiprotocol
                                                        property: (property_identifier) @field_type
                                                        (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                      property: (property_identifier) @_decode_field
                                                      (#eq? @_decode_field "decode")))
                                                ]
                                        )

                                        ; Repeated items
                                        (sequence_expression
                                          (binary_expression)
                                          (call_expression
                                            function: (member_expression
                                              object: (member_expression
                                                        object: (identifier)
                                                        property: (property_identifier) @field_name)
                                              property: ((property_identifier) @push
                                                          (#eq? @push "push")))

                                            arguments: (arguments
                                              [
                                                ; Repeated primitive
                                                (call_expression
                                                  function: (member_expression
                                                    object: (identifier)
                                                    property: (property_identifier) @field_type))

                                                ; Repeated non-primitive
                                                (call_expression
                                                  function: (member_expression
                                                    object: (member_expression
                                                      object: (member_expression) @_rootakiprotocol
                                                      property: (property_identifier) @field_type
                                                      (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                    property: (property_identifier) @_decode_field
                                                    (#eq? @_decode_field "decode")))
                                              ])
                                        ))
                                      ]
                           )))

                           ; Inlined ternary into if statement for repeated...
                           (if_statement
                             condition: (parenthesized_expression
                                (binary_expression
                                  left: (binary_expression
                                    left: (identifier)
                                    operator: ">>>"
                                    right: (number) @_shift3
                                    (#eq? @_shift3 "3"))
                                  "=="
                                  right: (number) @field_id))
                             consequence: (if_statement
                                consequence: (for_statement
                                  body: (expression_statement
                                         (call_expression
                                           function: (member_expression
                                             object: (member_expression
                                                     object: (identifier)
                                                     property: (property_identifier) @field_name)
                                             property: ((property_identifier) @push
                                                       (#eq? @push "push")))
                                           arguments: (arguments
                                             [
                                               ; Repeated primitive
                                               (call_expression
                                                 function: (member_expression
                                                   object: (identifier)
                                                   property: (property_identifier) @field_type))
                                               ; Repeated non-primitive
                                               (call_expression
                                                 function: (member_expression
                                                   object: (member_expression
                                                     object: (member_expression) @_rootakiprotocol
                                                     property: (property_identifier) @field_type
                                                     (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                   property: (property_identifier) @_decode_field
                                                   (#eq? @_decode_field "decode")))
                                             ])
                             )))))

                           ; Inlined ternary into if statement for maps...
                           (if_statement
                              condition: (parenthesized_expression
                                (binary_expression
                                  left: (binary_expression
                                    left: (identifier)
                                    operator: ">>>"
                                    right: (number) @_shift3
                                    (#eq? @_shift3 "3"))
                                  "=="
                                  right: (number) @field_id))
                              consequence: (statement_block
                                (expression_statement
                                  (binary_expression
                                    left: (binary_expression
                                      left: (member_expression
                                              (identifier)
                                              (property_identifier) @field_name)
                                      operator: "==="
                                      right: (member_expression) @_util_emptyobject
                                      (#eq? @_util_emptyobject "$util.emptyObject"))))
                                (for_statement
                                  body: [
                                          (statement_block
                                            (switch_statement
                                              (switch_body
                                                (switch_case
                                                  "case"
                                                  value: ((number) @kv_id (#any-of? @kv_id "1" "2"))
                                                  body: (expression_statement
                                                          [
                                                            ; Primitive map item
                                                            (assignment_expression
                                                              right: (call_expression
                                                                function: (member_expression
                                                                  object: (identifier)
                                                                  property: (property_identifier) @kv_field_type))
                                                            )

                                                            ; Non-primitive map item
                                                            (assignment_expression
                                                              right: (call_expression
                                                                function: (member_expression
                                                                  object: (member_expression
                                                                    object: (member_expression) @_rootakiprotocol
                                                                    property: (property_identifier) @kv_field_type
                                                                    (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                                  property: (property_identifier) @_decode_field
                                                                  (#eq? @_decode_field "decode")))
                                                            )
                                                          ]
                                                ))
                                          )))

                                          ; Due to inlined assignment in the switch case, we need this duplication
                                          ; e.g. switch ((u = t.uint32()) >>> 3) instead of var u = t.uint32(); switch (u >>> 3)
                                          (switch_statement
                                            (switch_body
                                              (switch_case
                                                "case"
                                                value: ((number) @kv_id (#any-of? @kv_id "1" "2"))
                                                body: (expression_statement
                                                        [
                                                          ; Primitive map item
                                                          (assignment_expression
                                                            right: (call_expression
                                                              function: (member_expression
                                                                object: (identifier)
                                                                property: (property_identifier) @kv_field_type))
                                                          )

                                                          ; Non-primitive map item
                                                          (assignment_expression
                                                            right: (call_expression
                                                              function: (member_expression
                                                                object: (member_expression
                                                                  object: (member_expression) @_rootakiprotocol
                                                                  property: (property_identifier) @kv_field_type
                                                                  (#eq? @_rootakiprotocol "$root.Aki.Protocol"))
                                                                property: (property_identifier) @_decode_field
                                                                (#eq? @_decode_field "decode")))
                                                          )
                                                        ]
                                              ))
                                          ))
                                        ]
                                )
                           ))
                         ]
                  ))))
)))))))
