%----------------------------------------------------------------------------%
% Bindings for the tomlc99 (https://github.com/cktan/tomlc99) library
%----------------------------------------------------------------------------%

:- module tomlc99.
:- interface.

:- import_module string.
:- import_module maybe.
:- import_module io.

%----------------------------------------------------------------------------%

:- type toml_table.

% Given a file path, this returns either ok(toml_table) or error(message)
:- pred toml_parse_file(string::in, maybe.maybe_error(toml_table)::out, io::di,
  io::uo) is det.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:- import_module bool.

%----------------------------------------------------------------------------%

:- pred toml_parse_file_h(string::in, bool.bool::out, string::out,
  toml_table::out, io::di, io::uo) is det.

:- pragma foreign_decl("C", 
"
  #include ""toml.h""
  #define ERR_MSG_BUFFER_SIZE 512
").

:- pragma foreign_type("C", toml_table, "toml_table_t*").

:- pragma foreign_proc("C",
  toml_parse_file_h(Path::in, Error::out, ErrMsg::out, Table::out, IO0::di,
    IO1::uo),
  [will_not_call_mercury, promise_pure, tabled_for_io],
"
  FILE* fp;
  MR_allocate_aligned_string_msg(ErrMsg, ERR_MSG_BUFFER_SIZE, MR_ALLOC_ID);
  ErrMsg[0] = '\\0';

  fp = fopen(Path, ""r"");
  if (!fp) {
    snprintf(ErrMsg, ERR_MSG_BUFFER_SIZE, ""cannot open file %s"", Path);
    Error = MR_YES;
  } else {
    Table = toml_parse_file(fp, ErrMsg, ERR_MSG_BUFFER_SIZE);
    fclose(fp);
    if (!Table) {
      Error = MR_YES;
    } else {
      Error = MR_NO;
    }
  }

  IO1 = IO0;
").

toml_parse_file(Path, Maybe, !IO) :-
  toml_parse_file_h(Path, Error, ErrMsg, Table, !IO),
  Maybe = (
    if Error = yes then
      error(ErrMsg)
    else
      ok(Table)
  ).
