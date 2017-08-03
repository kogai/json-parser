%token <int> INT
%token <float> FLOAT
%token <string> ID
%token <string> STRING
%token TRUE
%token FALSE
%token NULL
%token LBRACE
%token RBRACE
%token LBRACKET
%token RBRACKET
%token COLON
%token COMMA
%token EOF

%start <Json.value option> prog
%%

prog:
  | EOF { None }
  | v = value { Some v }
value:
  | LBRACE; v = object_fields; RBRACE { `ObjectT v }
  | LBRACKET; v = array_values; RBRACKET { `ArrayT v }
  | v = STRING { `StringT v }
  | v = INT { `IntT v }
  | v = FLOAT { `NumberT v }
  | TRUE { `BoolT true }
  | FALSE { `BoolT false }
  | NULL { `NullT }
object_fields:
  separated_list
