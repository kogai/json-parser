open Sedlexing
open Parser

exception SyntaxError of string

(* FIXME: fix next_line fn for sedlex compatible
   refto: http://qiita.com/Tamamu/items/e647c18403681df15c42 *)
let next_line lexbuf = lexbuf

let letter = [%sedlex.regexp? 'a'..'z' | 'A'..'Z' | '_' | '$']
let string_t = [%sedlex.regexp? '"', Star any, '"']
let digit = [%sedlex.regexp? '0'..'9']
let alphanumeric = [%sedlex.regexp? digit | letter]
let word = [%sedlex.regexp? letter, Star alphanumeric]

let floatnumber = [%sedlex.regexp? Plus digit, '.', Plus digit]
let wholenumber = [%sedlex.regexp? Opt '-', digit | floatnumber]
let scientificnumber = [%sedlex.regexp? wholenumber,'e'|'E', Opt '-'|'+', Plus digit]

let white_space = [%sedlex.regexp? ' '|'\t']
let new_line = [%sedlex.regexp? '\r'|'\n'|"\r\n"]

let rec lex lexbuf =
  match%sedlex lexbuf with
  | white_space -> lex lexbuf
  | new_line ->
    ignore @@ next_line lexbuf; 
    lex lexbuf
  | digit -> INT (lexbuf |> Utf8.lexeme |> int_of_string)
  | scientificnumber -> FLOAT (lexbuf |> Utf8.lexeme |> float_of_string)
  | "true" -> TRUE 
  | "false" -> FALSE 
  | "null" -> NULL 
  | string_t -> STRING (lexbuf |> Utf8.lexeme)
  | "{" -> LBRACE 
  | "}" -> RBRACE 
  | "[" -> LBRACKET 
  | "]" -> RBRACKET 
  | ":" -> COLON 
  | "," -> COMMA 
  | eof -> EOF
  | _ -> raise (SyntaxError ("Unexpected character: " ^ Utf8.lexeme lexbuf))

let read raw_lexbuf = lex raw_lexbuf
