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

let from_char s = function
  | "{" -> LBrace
  | "}" -> RBrace
  | "[" -> LBracket
  | "]" -> RBracket
  | ":" -> Colon
  | "," -> Comma
  | "" -> EOF
  | "true" -> Bool
  | "false" -> Bool
  | _ when is_digit s -> Number
  | _ when is_string s -> String
  | _ -> Illegal

type token = token_type * int * int

type json =
  | String of string
  | Number of float
  | Object of (string * json) list
  | Array of json list
  | Bool of bool
  | Null

let read_line_of_file ic = 
  try
    Some (input_line ic)
  with End_of_file ->
    close_in ic;
    None

let rec read_file ic =
  match (read_line_of_file ic) with
  | Some line -> line ^ "\n" ^  (read_file ic)
  | None -> ""

let read_json file_name =
  read_file (open_in file_name)

let () = print_endline (read_json "fixture.json")