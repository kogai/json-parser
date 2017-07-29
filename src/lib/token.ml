type tt =
  | LBrace
  | RBrace
  | LBracket
  | RBracket
  | StringT of string
  | NumberT of float
  | BoolT of bool
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
  | "true" -> BoolT true
  | "false" -> BoolT false
  | s when is_digit s -> NumberT (float_of_string s)
  | s -> StringT s

type line = int
type column = int
type token = tt * line * column

let trim_head s =
  String.sub s 1 @@ (s |> String.length |> pred)

let rec tokenize = function
  (*skip_white_space  *)
    _ -> ((Some LBrace), "")
(* | " " -> (None, trim_head s) *)
(* | _ -> ((String "ok", 10, 14), "残りの文字列")    *)

let rec parse = function
  | _ -> true

type json =
  | String of string
  | Number of float
  | Object of (string * json) list
  | Array of json list
  | Bool of bool
  | Null
