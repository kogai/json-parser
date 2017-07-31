type t =
  | StringT of string
  | NumberT of float
  | ObjectT of (string * t) list
  | ArrayT of t list
  | BoolT of bool
  | NullT

exception InvaidToken of Token.t option

let add k v = function
  | ObjectT xs -> ObjectT ((k, v)::xs)
  | ArrayT xs -> ArrayT (v::xs)
  | _ -> NullT

let rec parse_array s container =
  NullT

let rec parse_object s container = 
  let (k, s1) = Token.token s in

  match k with
  | Some Token.StringT key ->
    let (_, s2) = Token.token s1 in (* drop colon *)
    let (v, s3) = Token.token s2 in
    let value = match v with
      | Some Token.BoolT value -> BoolT value
      | Some Token.StringT value -> StringT value
      | Some Token.NumberT value -> NumberT value 
      | Some Token.NullT -> NullT
      | Some Token.LBrace -> parse_object s3 (ObjectT [])
      | Some Token.LBracket -> parse_array s3 (ArrayT [])
      | x -> raise @@ InvaidToken x in
    let key_value_pair = add key value container in
    (match Token.token s3 with
     | (Some Token.Comma, s4) -> parse_object s4 key_value_pair
     | x -> key_value_pair)
  | x -> raise @@ InvaidToken x 

let rec parse s =
  let (token, s1) = Token.token s in
  let root = match token with
    | Some Token.LBrace -> ObjectT []
    | Some Token.LBracket -> ArrayT []
    | Some Token.EOF -> NullT
    | x -> raise @@ InvaidToken x
  in

  match token with 
  | Some Token.LBrace -> parse_object s1 root
  | Some Token.LBracket -> parse_array s1 root
  | Some Token.EOF -> NullT 
  | x -> raise @@ InvaidToken x 
