open Token

let () =
  let json = "fixture.json" |> Ast.read_json |> Ast.parse in
  ExtLib.print json
