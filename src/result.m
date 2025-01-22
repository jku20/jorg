%----------------------------------------------------------------------------%
% Types for various results which occur at different stages in the program
% and should get propogated up to the user's terminal.
%----------------------------------------------------------------------------%

:- module result.
:- interface.

:- import_module maybe.

%----------------------------------------------------------------------------%

:- type err --->
  % An error due to something which should never happen.
  % This getting returned indicates an implementation bug.
  bug_err(string);

  % An error occuring when argument parsing. 
  arg_parse_err(string);

  % Error due to table parse fail. This could be due to IO such as a file path
  % not existing or a malformed toml.
  table_parse_err(string).

:- func err_msg(err) = string.

:- type suc --->
  % A success with no extra information propogated to the terminal.
  no_output_suc.

:- func suc_msg(suc) = maybe(string).

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

%----------------------------------------------------------------------------%

err_msg(Err) = Msg :-
  Err = arg_parse_err(Msg);
  Err = table_parse_err(Msg);
  Err = bug_err(Msg).

suc_msg(Suc) = Out :- 
  Suc = no_output_suc,
  Out = no.
