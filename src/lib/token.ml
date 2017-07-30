type tt =
  | LBrace
  | RBrace
  | LBracket
  | RBracket
  | StringT of string
  | NumberT of float
  | BoolT of bool
  | Null
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

let from_char = function
  | "{" -> LBrace
  | "}" -> RBrace
  | "[" -> LBracket
  | "]" -> RBracket
  | ":" -> Colon
  | "," -> Comma
  | "" -> EOF
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

(* let rec split_at = function *)

let rec drop xs = function
  | 0 -> xs
  | n ->
    match xs with
    | [] -> []
    | y::ys -> drop ys (n - 1)

let read_number xs = 
  let rec rn = function
    | [] -> []
    | x::xs when not @@ is_digit x -> []
    | x::xs -> x::rn xs in
  let result = rn xs |> String.concat "" in
  let rest = drop xs @@ String.length result in
  (Some (from_char result), rest)

let rec tokenize_impl = function
  (*read_string  *)
  | " "::xs | "\n"::xs -> (None, xs)
  | x::xs when is_digit x || x == "-" -> read_number (x::xs)
  | xs -> (None, xs) (* for avoiding warn *)

(* | " " -> (None, trim_head s) *)
(* | _ -> ((String "ok", 10, 14), "残りの文字列")    *)

let tokenize s =
  tokenize_impl @@ to_list s

let rec parse = function
  | _ -> true

type json =
  | String of string
  | Number of float
  | Object of (string * json) list
  | Array of json list
  | Bool of bool
  | Null
