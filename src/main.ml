let rec range n =
  match n with
  | 0 -> []
  | _ -> n::(range (n -1))

let rec string_of_list = function
  | [] -> ""
  | x::xs -> string_of_int x ^ "," ^ string_of_list xs

let () =
  print_endline @@ "Hello, world! range is " ^ (5 |> range |> string_of_list) 
