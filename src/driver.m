%----------------------------------------------------------------------------%
% The driver for the program.
%----------------------------------------------------------------------------%

:- module driver.
:- interface.

:- import_module maybe.
:- import_module result.

%----------------------------------------------------------------------------%

:- type request ---> 
  request(
    config :: string,
    outfile :: string
  ).

:- func run(request::in) = (maybe_error(suc, err)::out) is det.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

run(Req) =
  ok(no_output_suc).
