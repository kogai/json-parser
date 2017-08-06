open Sedlexing
open Parser

exception SyntaxError of string
exception ParseError of string

let show_token = function
  | Parser.STRING x -> "STRING(" ^ x ^ ")"
  | Parser.INT x -> "INT(" ^ string_of_int x ^ ")"
  | Parser.FLOAT x -> "FLOAT(" ^ string_of_float x ^ ")"
  | Parser.TRUE -> "TRUE"
  | Parser.FALSE -> "FALSE"
  | Parser.LBRACE -> "{"
  | Parser.RBRACE -> "}"
  | Parser.LBRACKET -> "["
  | Parser.RBRACKET -> "]"
  | Parser.NULL -> "NULL"
  | Parser.COLON -> "COLON"
  | Parser.COMMA -> "COMMA"
  | Parser.EOF -> "EOF"

type synthetic_lexbuf = {
  lexbuf_inner: Sedlexing.lexbuf;
  mutable position: Lexing.position;
}

let next_line synthetic_lexbuf =
  let open Lexing in
  synthetic_lexbuf.position <- { synthetic_lexbuf.position with pos_lnum = synthetic_lexbuf.position.pos_lnum + 1 }

let update synthetic_lexbuf =
  let next = Sedlexing.lexeme_end synthetic_lexbuf.lexbuf_inner in
  let current = synthetic_lexbuf.position in
  synthetic_lexbuf.position <- { current with Lexing.pos_cnum = next } 

let letter = [%sedlex.regexp? 'a'..'z' | 'A'..'Z' | '_' | '$']
let quote = [%sedlex.regexp? '"' | "'"]
let digit = [%sedlex.regexp? '0'..'9']
let int_t = [%sedlex.regexp? digit, Star digit]
let alphanumeric = [%sedlex.regexp? digit | letter]
let word = [%sedlex.regexp? letter, Star alphanumeric]

let floatnumber = [%sedlex.regexp? Plus digit, '.', Plus digit]
let wholenumber = [%sedlex.regexp? Opt '-', digit | floatnumber]
let scientificnumber = [%sedlex.regexp? wholenumber,'e'|'E', Opt '-'|'+', Plus digit]

let white_space = [%sedlex.regexp? ' '|'\t']
let new_line = [%sedlex.regexp? '\r'|'\n'|"\r\n"]

let rec lex synthetic_lexbuf =
  let lexbuf = synthetic_lexbuf.lexbuf_inner in
  match%sedlex lexbuf with
  | white_space ->
    ignore @@ update synthetic_lexbuf; 
    lex synthetic_lexbuf
  | new_line ->
    ignore @@ next_line synthetic_lexbuf; 
    lex synthetic_lexbuf
  | int_t -> INT (lexbuf |> Utf8.lexeme |> int_of_string)
  | scientificnumber -> FLOAT (lexbuf |> Utf8.lexeme |> float_of_string)
  | "true" -> TRUE 
  | "false" -> FALSE 
  | "null" -> NULL 
  | "'" | '"' -> read_string (Buffer.create 127) synthetic_lexbuf
  | "{" -> LBRACE 
  | "}" -> RBRACE 
  | "[" -> LBRACKET 
  | "]" -> RBRACKET 
  | ":" -> COLON 
  | "," -> COMMA 
  | eof -> EOF
  | _ -> raise (SyntaxError ("Unexpected character: " ^ Utf8.lexeme lexbuf))
and read_string buf synthetic_lexbuf =
  let lexbuf = synthetic_lexbuf.lexbuf_inner in
  let quote = lexbuf |> Utf8.lexeme in
  let string_continue = [%sedlex.regexp? Compl quote] in
  match%sedlex lexbuf with
  | quote ->
    STRING (Buffer.contents buf)
  | string_continue ->
    Buffer.add_string buf (Utf8.lexeme lexbuf);
    read_string buf synthetic_lexbuf
  | eof -> raise (SyntaxError ("String is not terminated"))
  | _ -> raise (SyntaxError ("Illegal string charcter: [" ^ Utf8.lexeme lexbuf ^ "]"))

let init_synthetic_lexbuf ?(file = "") lexbuf_inner =
  let position = {Lexing.
                   pos_fname = file;
                   pos_lnum = 1;
                   pos_bol = 0;
                   pos_cnum = 0;
                 } in
  { position; lexbuf_inner }

let read synthetic_lexbuf = 
  let lex' () =
    let before = synthetic_lexbuf.position in
    let token = lex synthetic_lexbuf in
    let after = synthetic_lexbuf.position in

    (* print_endline @@ "In lex' " ^ show_token token;  *)
    (token, before, after) in

  let parser' = MenhirLib.Convert.Simplified.traditional2revised Parser.prog in 
  try
    parser' lex'
  with
  | Parser.Error
    -> raise @@ ParseError "Paser error"
  | Sedlexing.MalFormed
  | Sedlexing.InvalidCodepoint _
    -> raise @@ ParseError "Some reason"
