open Core
open Lexing

(* let print_position outx lexbuf =
   let pos = lexbuf.lex_curr_p in
   fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

   let parse_with_error lexbuf =
   try Parser.prog Lexer.read lexbuf with
   | SyntaxError msg ->
    fprintf stderr "%a: %s\n" print_position lexbuf msg;
    None
   | Parser.Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit (-1)

*)

(* let rec parse_and_print lexbuf =
   match parse_with_error lexbuf with
   | Some value ->
    printf "%a\n" Json.output_value value;
    (* parse_and_print lexbuf *)
   | None -> () *)

let loop file_name () =
  let incx = In_channel.create file_name in
  let result = incx
               |> Sedlexing.Utf8.from_channel
               |> Lexer.init_synthetic_lexbuf ~file:file_name
               |> Lexer.read
               |> (function
                   | Some v -> Json.show v
                   | None -> Json.show Json.(`NullT)
                 )
  in
  print_endline result;
  In_channel.close incx

let () =
  Command.basic ~summary:"Parse and display JSON"
    Command.Spec.(empty +> anon ("filename" %: file))
    loop 
  |> Command.run
