module Token = struct
  type token_type =
    | LBrace
    | RBrace
    | LBracket
    | RBracket
    | String of string
    | Number of float
    | Bool of bool
    | Null
    | Colon
    | Comma
    | Illegal
    | EOF

  let is_digit s =
    try
      ignore (float_of_string s);
      true
    with Failure e ->
      false

  let from_char = function
    | "{" -> LBrace
    | "}" -> RBrace
    | "[" -> LBracket
    | "]" -> RBracket
    | ":" -> Colon
    | "," -> Comma
    | "" -> EOF
    | "true" -> Bool true
    | "false" -> Bool false
    | s when is_digit s -> Number (float_of_string s)
    | s -> String s

  type line = int
  type column = int
  type token = token_type * line * column

  let trim_head s =
    String.sub s 1 ((String.length s) - 1)

  let rec tokenize = function
    (*skip_white_space  *)
    (* | " " -> tokenize  *)
    | _ -> ((String "ok", 10, 14), "残りの文字列") 

  let rec parse = function
    | _ -> true

  type json =
    | String of string
    | Number of float
    | Object of (string * json) list
    | Array of json list
    | Bool of bool
    | Null
end;;
