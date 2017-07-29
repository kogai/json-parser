open OUnit2

let test1 test_ctxt = assert_equal true true;;
let test2 test_ctxt = assert_equal 0 0;;
(* let test3 test_ctxt = assert_equal true (Token.is_digit "100");;  *)

(* Name the test cases and group them together *)
let suite =
  "suite">:::
  [
    "test1">:: test1;
    "test2">:: test2
    (* "test3">:: test3 *)
  ]
;;

let () =
  run_test_tt_main suite
;;
