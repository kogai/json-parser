type t =
  | StringT of string
  | NumberT of float
  | ObjectT of (string * t) list
  | ArrayT of t list
  | BoolT of bool
  | NullT

let parse s = 
  s
