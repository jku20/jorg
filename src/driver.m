%----------------------------------------------------------------------------%
% The driver for the program.
%----------------------------------------------------------------------------%

:- module driver.
:- interface.

:- import_module maybe, io.
:- import_module result.

%----------------------------------------------------------------------------%

:- type request ---> 
  request(
    config :: string,
    outfile :: string
  ).

:- pred run(request::in, maybe_error(suc, err)::out, io::di, io::uo) is det.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:-import_module list.
:-import_module tomlc99, fragment.

%----------------------------------------------------------------------------%

:- func make_fragment_list(toml_table) = maybe_error(list(fragment), err).

%----------------------------------------------------------------------------%

make_fragment_list(_) = 
  error(bug_err("not implemented")).

run(Req, Res, !IO) :-
  toml_parse_file(Req^config, Config, !IO),
  (
    Config = ok(_),
    Res = ok(no_output_suc)
  ;
    Config = error(Msg),
    Res = error(table_parse_err(Msg))
  ).


