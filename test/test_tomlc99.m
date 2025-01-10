%----------------------------------------------------------------------------%
% Tests tomlc99 bindings.
%----------------------------------------------------------------------------%

:- module test_tomlc99.
:- interface.

:- import_module io.

%----------------------------------------------------------------------------%

:- pred main(io::di, io::uo) is det.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:- import_module tomlc99.
:- import_module maybe.
:- import_module string.

%----------------------------------------------------------------------------%

:- pred test_toml_parse_file(string::in, io::di, io::uo) is det.
test_toml_parse_file(Path, !IO) :-
  toml_parse_file(Path, Res, !IO),
  (
    Res = ok(_), S = "parse successful";
    Res = error(S)
  ),
  io.write_string(S ++ "\n", !IO).

:- pred test_toml_table_in(string::in, string::in, io::di, io::uo) is det.
test_toml_table_in(Path, Key, !IO) :-
  toml_parse_file(Path, Res, !IO),
  (
    Res = error(Msg),
    io.write_string(Msg ++ "\n", !IO)
  ;
    Res = ok(Table),
    (if TableOut = toml_table_in(Table, Key) then
      io.write_string("Found table " ++ Key ++ " in " ++ Path ++ "\n", !IO)
    else
      io.write_string("No table " ++ Key ++ " in " ++ Path ++ "\n", !IO))
  ).

:- pred test_toml_string_in(string::in, string::in, string::in, io::di, io::uo)
  is det.
test_toml_string_in(Path, Tbl, Key, !IO) :-
  toml_parse_file(Path, Res, !IO),
  (
    Res = error(Msg),
    io.write_string(Msg ++ "\n", !IO)
  ;
    Res = ok(BigTable),
    (if Table = toml_table_in(BigTable, Tbl) then 
      (if Str = toml_string_in(Table, Key) then
        io.write_string("Found " ++ Str ++ " at " ++ Key ++ "\n", !IO)
      else
        io.write_string("No string at " ++ Key ++ " in " ++ Path ++ "\n", !IO))
    else
      io.write_string("No table " ++ Tbl ++ " in " ++ Path ++ "\n", !IO))
  ).
  

main(!IO) :-
  test_toml_parse_file("does_not_exist.toml", !IO),
  test_toml_parse_file("data/simple.toml", !IO),

  test_toml_table_in("data/simple.toml", "hello", !IO),
  test_toml_table_in("data/simple.toml", "does_not_exist", !IO),

  test_toml_string_in("data/simple.toml", "hello", "thing", !IO),
  test_toml_string_in("data/simple.toml", "hello", "does_not_exist", !IO).
