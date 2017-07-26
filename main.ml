let rec range n =
  match n with
  | 0 -> []
  | _ -> n::(range (n -1))

let () =
  Printf.printf "Hello world\n";
  List.iter print_int (range 10)