open Token

let read_line_of_file ic = 
  try
    Some (input_line ic)
  with End_of_file ->
    close_in ic;
    None

let rec read_file ic =
  match (read_line_of_file ic) with
  | Some line -> line ^ "\n" ^  (read_file ic)
  | None -> ""

let read_json file_name =
  read_file (open_in file_name)

(* let () = print_endline @@ read_json "fixture.json" *)
(* let () = "fixture.json" |> read_json |> print_endline *)
