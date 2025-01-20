%----------------------------------------------------------------------------%
% The entry point to the program.
%----------------------------------------------------------------------------%

:- module jorg.
:- interface.

:- import_module io.

%----------------------------------------------------------------------------%

:- pred main(io::di, io::uo) is cc_multi.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:- import_module list, string, pair, assoc_list, maybe, bool.
:- import_module driver, result.
:- import_module colipa.

%----------------------------------------------------------------------------%

:- func argdescl = assoc_list(cla, list(colipa.property)).
:- pred print_help(io::di, io::uo) is det.

:- type action --->
  help;
  request(driver.request);
  error(err).

% Creates a request from an toml and outfile.
:- pred make_request(arguments::in, list(string)::in, action::out) is multi.

:- func jorg_description = string.

%----------------------------------------------------------------------------%

argdescl = [
  cla("help") -
  [ prop_long("help"), prop_short('h'), prop_switch,
    prop_description("Print this help message")
  ],

  cla("outfile") -
  [ prop_long("out"), prop_short('o'), prop_switch_value("Outfile"),
    'new prop_default'("a.out"),
    prop_description("The path of the file generated from a config")
  ]
].

jorg_description = 
  "\
Usage: jorg [OPTIONS] INPUT_TOML

Options:
".

print_help(!IO) :-
  print_on_terminal(jorg_description, !IO),
  print_usage_info(argdescl, !IO).

make_request(Arguments, NonArguments, Out) :-
  (
    Outfile = arg_value(Arguments, cla("outfile")),
    index0(NonArguments, 0, Infile),
    Out = request(request(Infile, Outfile))
  ;
    Out = error(arg_parse_err("No INPUT_TOML specified"))
  ).

main(!IO) :-
  (try [io(!IO)]
    colipa(argdescl, Arguments, NonArguments, !IO)
  then
    (
      yes = arg_switch(Arguments, cla("help")),
      Action = help
    ;
      make_request(Arguments, NonArguments, Action)
    )
  catch (ADE : arg_desc_error) ->
    Action = error(bug_err(ade_message(ADE)))
  catch (CLE : command_line_error) ->
    Action = error(arg_parse_err(cle_message(CLE))))
  ,

  (
    Action = request(R),
    Result = driver.run(R)
  ;
    Action = error(E),
    Result = error(E)
  ;
    Action = help,
    print_help(!IO),
    Result = ok(no_output_suc)
  ),

  (
    Result = error(Err), 
    Msg = err_msg(Err),
    print_on_terminal("Error: " ++ Msg ++ "\n", !IO),
    io.set_exit_status(1, !IO)
  ;
    Result = ok(Suc),
    Msg = suc_msg(Suc),
    (
      Msg = yes(Str), 
      print_on_terminal(Str ++ "\n", !IO)
    ;
      Msg = no
    ),
    io.set_exit_status(0, !IO)
  ).

