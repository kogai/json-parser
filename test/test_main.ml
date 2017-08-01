open Token
open OUnit2

let specs = [
   "it should detect digit" >:: (fun ctx -> assert_equal true (is_digit "100"));
     "it should detect string" >:: (fun ctx -> assert_equal false (is_digit "string"));
     "it should trim head of string" >:: (fun ctx -> assert_equal "first" @@ tail " first");
     "it should tokenize" >:: (fun ctx -> assert_equal ((Some LBrace), "}") @@ token "{}"); 
     "it should tokenize bool" >:: (fun ctx -> assert_equal ((Some (BoolT true)), "") @@ token "true"); 
     "it should tokenize number" >:: (fun ctx -> assert_equal ((Some (NumberT 100.0)), "") @@ token "100");
     "it should tokenize number" >:: (fun ctx -> assert_equal ((Some EOF), "") @@ token ""); 
     "it should tokenize string" >:: (fun ctx -> assert_equal ((Some (StringT "foo")), "") @@ token "\"foo\"");  
     "it should parse object" >:: (fun ctx ->
      let expect = Ast.ObjectT [("foo", (Ast.StringT "bar"))] in
      let actual = Ast.parse "{\"foo\":\"bar\"}" in
      assert_equal expect actual
     ); 
     "it should parse nested object" >:: (fun ctx ->
      let expect = Ast.ObjectT [("foo", (Ast.StringT "bar"));("bar", (Ast.StringT "buzz"))] in
      let actual = Ast.parse "{\"foo\":\"bar\",\"bar\":\"buzz\"}" in
      assert_equal expect actual
     );   
   "it should parse array" >:: (fun ctx ->
      let expect = Ast.ArrayT [Ast.NumberT 100.0; Ast.NumberT 200.0] in
      let actual = Ast.parse "[100,200]" in
      assert_equal expect actual
     );  
  (* "feature test" >:: (fun ctx ->
      let expect = Ast.ObjectT [
          ("title", Ast.StringT "Cities");
          ("cities",
           Ast.ArrayT [
             Ast.ObjectT [
               ("name", Ast.StringT "NewYork");
               ("digit", Ast.ArrayT [Ast.NumberT 999.0]);
             ];
             Ast.ObjectT [
               ("name", Ast.StringT "Washington");
               ("digit", Ast.ArrayT [Ast.NumberT 888.0]);
             ];
           ]);
          ("nagative", Ast.NumberT (float_of_int (~- 100)));
        ] in
      let actual = Ast.parse (Ast.read_json "fixture.json") in 
      (* ExtLib.print expect; *)
       (* ExtLib.print actual;   *)
      assert_equal expect actual 
    );  *)
]

(* Name the test cases and group them together *)
let suite =
  "suite" >::: specs

let () =
  run_test_tt_main suite
