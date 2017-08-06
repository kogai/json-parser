open Core

type t = [
  | `ObjectT of (string * t) list
  | `ArrayT of t list
  | `BoolT of bool
  | `StringT of string
  | `FloatT of float
  | `IntT of int
  | `NullT
]
[@@deriving show]

let rec output_value outc = function
  | `ObjectT obj  -> print_assoc outc obj
  | `ArrayT l     -> print_list outc l
  | `StringT s   -> printf "\"%s\"" s
  | `IntT i      -> printf "%d" i
  | `FloatT x    -> printf "%f" x
  | `BoolT true  -> Out_channel.output_string outc "true"
  | `BoolT false -> Out_channel.output_string outc "false"
  | `NullT       -> Out_channel.output_string outc "null"

and print_assoc outc obj =
  Out_channel.output_string outc "{ ";
  let sep = ref "" in
  List.iter ~f:(fun (key, value) ->
      printf "%s\"%s\": %a" !sep key output_value value;
      sep := ",\n  ") obj;
  Out_channel.output_string outc " }"

and print_list outc arr =
  Out_channel.output_string outc "[";
  List.iteri ~f:(fun i v ->
      if i > 0 then
        Out_channel.output_string outc ", ";
      output_value outc v) arr;
  Out_channel.output_string outc "]"
