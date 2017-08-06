open Core
open OUnit2

let specs = [
  "it should parse object" >:: (fun ctx ->
      let expect = Json.(`ObjectT [("foo", (Json.(`StringT "bar")))]) in 
      let actual = "{ \"foo\": \"bar\" }"
                   |> Lexing.from_string
                   |> Lexer.read in
      match actual with
      | Some v ->  assert_equal expect v
      | _ -> assert false
    ); 
  (* 
  "it should parse nested object" >:: (fun ctx ->
      let expect = Json.(`ObjectT [("foo", (Json.(`StringT "bar")));("bar", (Json.(`StringT "buzz")))]) in 
      let actual = "{ \"foo\": \"bar\",\"bar\": \"buzz\" }" |> Lexing.from_string |> Parser.prog Lexer.read in
      match actual with
      | Some v ->  assert_equal expect v
      | _ -> assert false
    );

  "it should parse array" >:: (fun ctx ->
      let expect = Json.(`ArrayT [Json.(`IntT 100); Json.(`IntT 200)]) in 
      let actual = "[100, 200]" |> Lexing.from_string |> Parser.prog Lexer.read in
      match actual with
      | Some v ->  assert_equal expect v
      | _ -> assert false
    );   
  "feature test" >:: (fun ctx ->
      let expect = Json.(`ObjectT [
          ("title", (Json.(`StringT "Cities")));
          ("cities", Json.(`ArrayT [
               Json.(`ObjectT [
                   ("name", (Json.(`StringT "NewYork")));
                   ("digit", (Json.(`ArrayT [Json.(`IntT 999)])))
                 ]);
               Json.(`ObjectT [
                   ("name", (Json.(`StringT "Washington")));
                   ("digit", (Json.(`ArrayT [Json.(`IntT 888)])))
                 ]) 
             ]));
          ("negative", (Json.(`IntT (~- 100))))
        ]) in
      let actual = "fixture.json" |> In_channel.create |> Lexing.from_channel |> Parser.prog Lexer.read in
      match actual with
      | Some v ->  assert_equal expect v
      | _ -> assert false
    );   *)
]

(* Name the test cases and group them together *)
let suite =
  "suite" >::: specs

let () =
  run_test_tt_main suite
