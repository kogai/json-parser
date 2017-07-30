type tt =
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

type line = int
type column = int
type token = tt * line * column

let head s =
  String.sub s 0 1

let tail s =
  String.sub s 1 @@ (s |> String.length |> pred)

let rec to_list = function
  | "" -> []
  | s -> (head s)::(to_list @@ tail s)

let rec take xs = function
  | 0 -> []
  | n ->
    match xs with
    | [] -> []
    | y::ys -> y::take ys (n - 1)

let rec drop xs = function
  | 0 -> xs
  | n ->
    match xs with
    | [] -> []
    | y::ys -> drop ys (n - 1)

let read_identifier predicate xs =
  let rec read = function
    | [] -> ""
    | x::xs when not @@ predicate x -> ""
    | x::xs -> x ^ read xs in
  let result = read xs in
  let rest = drop xs @@ String.length result in
  (Some (from_str result), rest)

let tokenize s =
  let impl = function
    | [] -> (None, [])
    | " "::xs | "\n"::xs -> (None, xs)
    | x::xs when is_digit x || x = "-" -> read_identifier is_digit (x::xs)
    | x::xs when is_letter x -> read_identifier is_letter (x::xs)
    | x::xs when x = "\"" -> read_identifier is_letter @@ take xs ((List.length xs) -1)
    | x::xs -> (Some (from_str x), xs) in
  let (tkn, rest) = impl @@ to_list s in
  (tkn, String.concat "" rest)

let rec parse = function
  | _ -> true

type json =
  | String of string
  | Number of float
  | Object of (string * json) list
  | Array of json list
  | Bool of bool
  | Null
