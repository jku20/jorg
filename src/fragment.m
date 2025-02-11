%----------------------------------------------------------------------------%
% File fragments. 
% These are the atomic blocks which each toml table fills in the gaps for.
%----------------------------------------------------------------------------%

:- module fragment.
:- interface.

%----------------------------------------------------------------------------%

:- type fragment.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:- import_module map.
:- import_module list.

%----------------------------------------------------------------------------%

:- type value --->
  repeating(list(string));
  single(string).

:- type substitution --->
  mul(
    % The diliminator to separate repeating variables.
    delim :: string,

    % The name of the variable to replace.
    label :: string
  );

  % The name of the variable to replace.
  one(key :: string).


:- type text_piece --->
  lit(string);
  subst(substitution).


:- type fragment ---> 
  fragment(
    src :: list(text_piece),
    vars :: map(string, value)
  ).

%----------------------------------------------------------------------------%
