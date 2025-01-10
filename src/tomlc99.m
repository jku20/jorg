%----------------------------------------------------------------------------%
% Bindings for the tomlc99 (https://github.com/cktan/tomlc99) library
%----------------------------------------------------------------------------%

:- module tomlc99.
:- interface.

:- import_module string.
:- import_module maybe.

%----------------------------------------------------------------------------%

:- type toml_table.

% Given a file path, this returns either ok(toml_table) or error(message)
:- func toml_parse_file(string) = maybe.maybe_error(toml_table).

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:- import_module bool.

:- pred toml_parse_file_h(string::in, bool.bool::out, string::out, toml_table::out)
  is det.

%----------------------------------------------------------------------------%

:- pragma foreign_decl("C", "#include ""toml.h""").

:- pragma foreign_type("C", toml_table, "toml_table_t*").

:- pragma foreign_proc("C",
  toml_parse_file_h(Path::in, Error::out, ErrMsg::out, Table::out),
  [will_not_call_mercury, promise_pure],
"
  FILE* fp;
  char *errbuf = MR_GC_malloc(sizeof(char) * 200);
  errbuf[0] = 0;

  fp = fopen(Path, ""r"");
  if (!fp) {
    snprintf(errbuf, 200, ""cannot open file %s"", Path);
    ErrMsg = errbuf;
    Error = MR_YES;
  } else {
    Table = toml_parse_file(fp, errbuf, sizeof(errbuf));
    fclose(fp);
    if (!Table) {
      ErrMsg = errbuf;
      Error = MR_YES;
    } else {
      ErrMsg = """";
      Error = MR_NO;
    }
  }
").

toml_parse_file(Path) =
  (if Error = yes then
    error(ErrMsg)
  else
    ok(Table))
:-
  toml_parse_file_h(Path, Error, ErrMsg, Table).
