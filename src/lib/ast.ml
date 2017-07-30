type t =
  | StringT of string
  | NumberT of float
  | ObjectT of (string * t) list
  | ArrayT of t list
  | BoolT of bool
  | NullT

exception InvaidToken of Token.t option

let rec parse_inner s = 
  let (token, rest) = Token.token s in
  match token with
  (* | Some Token.LBrace -> parse_object rest
     | Some Token.LBracket -> parse_array rest *)
  | Some Token.EOF -> NullT
  | x -> raise @@ InvaidToken x
(* NullT *)

let rec parse_array s =
  NullT

let rec parse s =
  let (token, s1) = Token.token s in
  let root = match token with
    | Some Token.LBrace -> ObjectT []
    | Some Token.LBracket -> ArrayT []
    | Some Token.EOF -> NullT
    | x -> raise @@ InvaidToken x
  in

  match token with
  | Some Token.LBrace ->
    let (k, s2) = Token.token s1 in
    let (_, s3) = Token.token s2 in (* drop colon *)
    (match k with
     | Some (Token.StringT key) -> ObjectT [(key, parse s3)]
     | x -> raise @@ InvaidToken x)
  | Some Token.LBracket -> parse_array s1
  | Some Token.EOF -> NullT
  (* Token.StringT *)
  (* Token.NumberT *)
  (* Token.BoolT *)
  (* Token.Comma *)
  | x -> raise @@ InvaidToken x
