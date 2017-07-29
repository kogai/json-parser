module Token =
struct
  type token_type =
    | LBrace
    | RBrace
    | LBracket
    | RBracket
    | String
    | Number
    | Bool
    | Null
    | Colon
    | Comma
    | Illegal
    | EOF

  let is_digit s = true
  let is_string s = true

  let from_char = function
    | "{" -> LBrace
    | "}" -> RBrace
    | "[" -> LBracket
    | "]" -> RBracket
    | ":" -> Colon
    | "," -> Comma
    | "" -> EOF
    | "true" -> Bool
    | "false" -> Bool
    | s when is_digit s -> Number
    | s when is_string s -> String
    | _ -> Illegal

  type token = token_type * int * int

  type json =
    | String of string
    | Number of float
    | Object of (string * json) list
    | Array of json list
    | Bool of bool
    | Null
end;;
