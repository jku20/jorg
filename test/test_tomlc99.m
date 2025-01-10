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
    (if _ = toml_table_in(Table, Key) then
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

:- pred test_toml_array_in(string::in, string::in, string::in, io::di, io::uo)
  is det.
test_toml_array_in(Path, Tbl, Key, !IO) :-
  toml_parse_file(Path, Res, !IO),
  (
    Res = error(Msg),
    io.write_string(Msg ++ "\n", !IO)
  ;
    Res = ok(BigTable),
    (if Table = toml_table_in(BigTable, Tbl) then 
      (if _ = toml_array_in(Table, Key) then
        io.write_string("Found array at " ++ Key ++ " in " ++ Path ++ "\n", !IO)
      else
        io.write_string("No array at " ++ Key ++ " in " ++ Path ++ "\n", !IO))
    else
      io.write_string("No table " ++ Tbl ++ " in " ++ Path ++ "\n", !IO))
  ).

:- pred test_toml_string_at(string::in, string::in, string::in, int::in, 
  io::di, io::uo) is det.
test_toml_string_at(Path, Tbl, Key, Idx, !IO) :-
  toml_parse_file(Path, Res, !IO),
  (
    Res = error(Msg),
    io.write_string(Msg ++ "\n", !IO)
  ;
    Res = ok(BigTable),
    (if Table = toml_table_in(BigTable, Tbl) then 
      (if Arr = toml_array_in(Table, Key) then
        (if Str = toml_string_at(Arr, Idx) then 
          io.write_string(
            "Found string " ++ Str ++ " at " ++ string(Idx) ++ "\n", !IO
          )
        else
          io.write_string( "No string at index " ++ string(Idx) ++ "\n", !IO))
      else
        io.write_string("No array at " ++ Key ++ " in " ++ Path ++ "\n", !IO))
    else
      io.write_string("No table " ++ Tbl ++ " in " ++ Path ++ "\n", !IO))
  ).

:- pred test_toml_table_at(string::in, string::in, int::in, io::di, io::uo)
  is det.
test_toml_table_at(Path, Key, Idx, !IO) :-
  toml_parse_file(Path, Res, !IO),
  (
    Res = error(Msg),
    io.write_string(Msg ++ "\n", !IO)
  ;
    Res = ok(Table),
    (if T = toml_array_in(Table, Key) then
      (if _ = toml_table_at(T, Idx) then
        io.write_string(
          "Found table at " ++ string(Idx) ++ " at " ++ Key ++ "\n", !IO
        )
      else
        io.write_string("No table found at " ++ string(Idx) ++ "\n", !IO))
    else
      io.write_string("No table at " ++ Key ++ "\n", !IO))
  ).

main(!IO) :-
  test_toml_parse_file("does_not_exist.toml", !IO),
  test_toml_parse_file("data/simple.toml", !IO),

  test_toml_table_in("data/simple.toml", "hello", !IO),
  test_toml_table_in("data/simple.toml", "does_not_exist", !IO),

  test_toml_string_in("data/simple.toml", "hello", "thing", !IO),
  test_toml_string_in("data/simple.toml", "hello", "does_not_exist", !IO),

  test_toml_array_in("data/simple.toml", "hello", "thing two", !IO),
  test_toml_array_in("data/simple.toml", "hello", "does_not_exist", !IO),

  test_toml_string_at("data/simple.toml", "hello", "thing two", 1, !IO),
  test_toml_string_at("data/simple.toml", "hello", "thing two", 2, !IO),

  test_toml_table_at("data/simple.toml", "world", 0, !IO),
  test_toml_table_at("data/simple.toml", "world", 1, !IO).
