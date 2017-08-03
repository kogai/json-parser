type value = [
  | `ObjectT of (string * value) list
  | `ArrayT of value list
  | `BoolT of bool
  | `StringT of string
  | `FloatT of float
  | `IntT of int
  | `Null
]