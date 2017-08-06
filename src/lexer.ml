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

type synthetic_lexbuf = {
  stream: Sedlexing.lexbuf;
  mutable position: Lexing.position;
}

let create_lexbuf ?(file = "") stream =
  let position = {Lexing.
                   pos_fname = file;
                   pos_lnum = 1;
                   pos_bol = 0;
                   pos_cnum = 0;
                 } in
  { position; stream }

let read lexbuf = 
  (* let lexer () =
     let ante_position = lexbuf.position in
     let token = lexer' lexbuf in
     let post_position = lexbuf.position
     in (token, ante_position, post_position) in *)

  let tokenizer () =
    let dump = {Lexing.
                 pos_fname = "";
                 pos_lnum = 1;
                 pos_bol = 0;
                 pos_cnum = 0;
               } in 
    (EOF, dump, dump) in

  let parser' = MenhirLib.Convert.Simplified.traditional2revised Parser.prog in 
  (* raw_lexbuf *)
  let read' = parser' tokenizer in
  read'
