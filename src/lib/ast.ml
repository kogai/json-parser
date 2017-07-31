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

    (match v with
     | Some Token.BoolT value ->
       (* let result = (key, BoolT x) in *)
       let result = add key (BoolT value) container in
       (* NullT *)
       result
     | Some Token.StringT x -> NullT
     | Some Token.NumberT x -> NullT
     | Some x -> NullT
     | None -> NullT)

  (* (key, v) *)
  (* (match k with
     | Some (Token.StringT key) -> ObjectT [(key, parse s3)]
     | x -> raise @@ InvaidToken x)  *)
  (* NullT *)
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
  (* Token.StringT *)
  (* Token.NumberT *)
  (* Token.BoolT *)
  (* Token.Comma *)
  | x -> raise @@ InvaidToken x 
