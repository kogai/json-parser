open Token
open OUnit2

let specs = [
  "it should detect digit" >:: (fun ctx -> assert_equal true (is_digit "100"));
  "it should detect string" >:: (fun ctx -> assert_equal false (is_digit "string"));
  "it should trim head of string" >:: (fun ctx -> assert_equal "first" @@ tail " first");
  "it should tokenize" >:: (fun ctx -> assert_equal ((Some LBrace), "}") @@ token "{}"); 
  "it should tokenize string" >:: (fun ctx -> assert_equal ((Some (StringT "foo")), "") @@ token "\"foo\""); 
  "it should tokenize bool" >:: (fun ctx -> assert_equal ((Some (BoolT true)), "") @@ token "true"); 
  "it should tokenize number" >:: (fun ctx -> assert_equal ((Some (NumberT 100.0)), "") @@ token "100");
  "it should tokenize number" >:: (fun ctx -> assert_equal ((Some EOF), "") @@ token "");
  "it should parse object" >:: (fun ctx ->
      let expect = Ast.ObjectT [("foo", (Ast.StringT "bar"))] in
      let actual = Ast.parse "{\"foo\":\"bar\"}" in
      Printf.printf "\nACTUAL is -> %s\n" (ExtLib.dump expect);
      assert_equal expect actual
    ); 
  (* parse array *)
  (* parse nested object *)
]

(* Name the test cases and group them together *)
let suite =
  "suite" >::: specs

let () =
  run_test_tt_main suite
