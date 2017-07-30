open Token
open OUnit2

let specs = [
  "it should detect digit" >:: (fun ctx -> assert_equal true (is_digit "100"));
  "it should detect string" >:: (fun ctox -> assert_equal false (is_digit "string"));
  "it should trim head of string" >:: (fun ctox -> assert_equal "first" @@ tail " first");
  "it should tokenize" >:: (fun ctox -> assert_equal ((Some LBrace), "}") @@ tokenize "{}");
  "it should tokenize" >:: (fun ctox -> assert_equal ((Some (StringT "foo")), "") @@ tokenize "\"foo\"");
  "it should tokenize" >:: (fun ctox -> assert_equal ((Some (NumberT 100.0)), "") @@ tokenize "100");
]

(* Name the test cases and group them together *)
let suite =
  "suite" >::: specs

let () =
  run_test_tt_main suite
