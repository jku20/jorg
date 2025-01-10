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
  

main(!IO) :-
  test_toml_parse_file("does_not_exist.toml", !IO),
  test_toml_parse_file("data/simple.toml", !IO).
