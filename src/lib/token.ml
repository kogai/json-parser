open ExtLib.List

type t =
  | LBrace
  | RBrace
  | LBracket
  | RBracket
  | StringT of string
  | NumberT of float
  | BoolT of bool
  | NullT
  | Colon
  | Comma
  | Illegal
  | EOF

let is_digit s =
  try
    ignore @@ float_of_string s;
    true
  with Failure e ->
    false

let is_letter s =
  let rgx = Str.regexp "[A-Za-z]" in
  Str.string_match rgx s 0

let from_str = function
  | "{" -> LBrace
  | "}" -> RBrace
  | "[" -> LBracket
  | "]" -> RBracket
  | ":" -> Colon
  | "," -> Comma
  | "" -> EOF
  | "null" -> NullT
  | "true" -> BoolT true
  | "false" -> BoolT false
  | s when is_digit s -> NumberT (float_of_string s)
  | s -> StringT s

let head s =
  String.sub s 0 1 

let tail s =
  String.sub s 1 @@ (s |> String.length |> pred) 

let rec to_list = function
  | "" -> []
  | s -> (head s)::(to_list @@ tail s)

let read_identifier is_string predicate xs =
  let rec read = function
    | [] -> ""
    | x::xs when not @@ predicate x -> ""
    | x::xs -> x ^ read xs in
  let result = read xs in
  let length_of_identifier = (String.length result) + (if is_string then 1 else 0) in
  let rest = drop length_of_identifier xs in
  (Some (from_str result), rest)

let token s =
  let impl = function
    | [] -> (Some EOF, [])
    | " "::xs | "\n"::xs -> (None, xs)
    | x::xs when is_digit x || x = "-" -> read_identifier false is_digit (x::xs)
    | x::xs when is_letter x -> read_identifier false is_letter (x::xs)
    | x::xs when x = "\"" -> read_identifier true is_letter @@ xs
    | x::xs -> (Some (from_str x), xs) in
  let (tkn, rest) = impl @@ to_list s in
  (tkn, String.concat "" rest)
