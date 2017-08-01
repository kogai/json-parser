open Token

let () =
  let json_str = "fixture.json" |> Ast.read_json in
  ExtLib.print (Ast.parse json_str)
(* Tag2 ([
  ("cities", Tag3 ([
    Tag2 ([("digit", Tag3 ([Tag1 (999.)])); ("name", ("NewYork"))])
  ]));
  ("title", ("Cities"))
]) *)
