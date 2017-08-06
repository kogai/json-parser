open Core
open OUnit2

let specs = [
  "it should parse object" >:: (fun ctx ->
      let expect = Json.(`ObjectT [("foo", (Json.(`StringT "bar")))]) in 
      let actual = "{ \"foo\": \"bar\" }" 
                   |> Sedlexing.Utf8.from_string
                   |> Lexer.init_synthetic_lexbuf ~file:"from_string"
                   |> Lexer.read 
      in
      assert_equal (Some expect) actual 
    ); 
  "it should parse nested object" >:: (fun ctx ->
      let expect = Json.(`ObjectT [("foo", (Json.(`StringT "bar")));("bar", (Json.(`StringT "buzz")))]) in 
      let actual = "{ \"foo\": \"bar\",\"bar\": \"buzz\" }"
                   |> Sedlexing.Utf8.from_string
                   |> Lexer.init_synthetic_lexbuf ~file:"from_string"
                   |> Lexer.read 
      in
      assert_equal (Some expect) actual 
    );
  "it should parse array" >:: (fun ctx ->
      let expect = Json.(`ArrayT [Json.(`IntT 100); Json.(`IntT 200)]) in 
      let actual = "[100, 200]"
                   |> Sedlexing.Utf8.from_string
                   |> Lexer.init_synthetic_lexbuf ~file:"from_string"
                   |> Lexer.read 
      in
      assert_equal (Some expect) actual 
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
      let file_name = "fixture.json" in
      let actual = file_name
                   |> In_channel.create
                   |> Sedlexing.Utf8.from_channel
                   |> Lexer.init_synthetic_lexbuf ~file:file_name
                   |> Lexer.read 
      in
      assert_equal (Some expect) actual 
    );
]

(* Name the test cases and group them together *)
let suite =
  "suite" >::: specs

let () =
  run_test_tt_main suite
