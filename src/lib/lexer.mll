{
open Lexing
open Parser

exception SyntaxError of string

let next_line lexbuf =
  let pos = lexbuf.lex_curr_p in
  lexbuf.lex_curr_p <-
  {
    pos with pos_bol = lexbuf.lex_curr_pos;
    pos_lnum = pos.pos_lnum + 1
  }
}

let int = '-'? ['0'-'9'] ['0'-'9']*
let digit = ['0'-'9'] 
let flac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* flac? exp?

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let id = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule read = 
  parse
  | white { read lexbuf }
  | newline { next_line lexbuf; read lexbuf }
  | int { INT (int_of_string (Lexing.lexme lexbuf)) }
  | float { FLOAT (int_of_string (Lexing.lexme lexbuf)) }
  | "true" { TRUE }
  | "false" { FALSE }
  | "null" { NULL }
  | '"' { read_string (Buffer.create 17) lexbuf }
  | '{' { LBRACE }
  | '}' { RBRACE }
  | '[' { LBRACKET }
  | ']' { RBRACKET }
  | ':' { COLON }
  | ',' { COMMA }
  | _ { raise (SyntaxError ("Unexpected character: " ^ Lexing.lexme lexbuf)) }
  | eof { EOF }
and read_string buf =
  parse
  | '"' { STRING (Buffer.contents.buf) }
  | '\\' '/' { Buffer.add_char buf '/'; read_string buf lexbuf }
  | '\\' '\\' { Buffer.add_char buf '\\'; read_string buf lexbuf }
  | '\\' 'b' { Buffer.add_char buf '\b'; read_string buf lexbuf }
  | '\\' 'f' { Buffer.add_char buf '\012'; read_string buf lexbuf }
  | '\\' 'n' { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | '\\' 'r' { Buffer.add_char buf '\r'; read_string buf lexbuf }
  | '\\' 't' { Buffer.add_char buf '\t'; read_string buf lexbuf }
  | [^ '"' '\\']+ {
    Buffer.add_string buf (Lexing.lexme lexbuf);
    read_string buf lexbuf
  }
  | _ { raise (SyntaxError ("Illegal string charcter: " ^ Lexing.lexme lexbuf)) }
  | eof { raise (SyntaxError ("String is not terminated")) }
