type t =
  | StringT of string
  | NumberT of float
  | ObjectT of (string * t) list
  | ArrayT of t list
  | BoolT of bool
  | NullT

exception InvaidToken of Token.t option

let add k v = function
  (* TODO: snoc関数で結合する or Stack構造を使う  *)
  | ObjectT xs -> ObjectT ((k, v)::xs)
  | ArrayT xs -> ArrayT (v::xs)
  | _ -> NullT

let rec parse_array source container =
  let (v, rest) = Token.token source in
  let value = parse_value rest v in
  let value_container = add "" value container in

  match Token.token rest with
  | (Some Token.Comma, s) -> parse_array s value_container
  | x -> value_container

and parse_object source container = 
  let (k, s1) = Token.token source in

  match k with
  | Some Token.StringT key ->
    let (_, s2) = Token.token s1 in (* drop colon *)
    let (v, s3) = Token.token s2 in
    let value = parse_value s3 v in
    let key_value_pair = add key value container in
    (match Token.token s3 with
     | (Some Token.Comma, s4) -> parse_object s4 key_value_pair
     | x -> key_value_pair)
  | x -> raise @@ InvaidToken x 

and parse_value source v = 
  match v with
  | Some Token.BoolT value -> BoolT value
  | Some Token.StringT value -> StringT value
  | Some Token.NumberT value -> NumberT value 
  | Some Token.NullT -> NullT
  | Some Token.LBrace -> parse_object source (ObjectT [])
  | Some Token.LBracket -> parse_array source (ArrayT [])
  | x -> raise @@ InvaidToken x

let rec parse source =
  let (token, rest) = Token.token source in
  let root = match token with
    | Some Token.LBrace -> ObjectT []
    | Some Token.LBracket -> ArrayT []
    | Some Token.EOF -> NullT
    | x -> raise @@ InvaidToken x
  in

  match token with 
  | Some Token.LBrace -> parse_object rest root
  | Some Token.LBracket -> parse_array rest root
  | Some Token.EOF -> NullT 
  | x -> raise @@ InvaidToken x 
