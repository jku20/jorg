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
:- type toml_array.

% Given a file path, this returns either ok(toml_table) or error(message)
:- pred toml_parse_file(string::in, maybe.maybe_error(toml_table)::out, io::di,
  io::uo) is det.

% Given a table and a key, returns a table at that key if one exists.
% If no table exists, this function is not satisfied.
:- func toml_table_in(toml_table::in, string::in) = (toml_table::out)
  is semidet.

% Given a table and a key, returns a string at that key if one exists.
% If no table exists, this function is not satisfied.
:- func toml_string_in(toml_table::in, string::in) = (string::out)
  is semidet.

% Given a table and a key, returns an array at that key if one exists.
% If no table exists, this function is not satisfied.
:- func toml_array_in(toml_table::in, string::in) = (toml_array::out)
  is semidet.

% Given an array and an index, returns the string at that index if one exists.
% If the index is too large, this function is not satisfied.
:- func toml_string_at(toml_array::in, int::in) = (string::out)
  is semidet.

% Given an array and an index, returns the table at that index if one exists.
% If the index is too large, this function is not satisfied.
:- func toml_table_at(toml_array::in, int::in) = (toml_table::out)
  is semidet.

% Given a table and an index, returns the key at that index.
% If the index is too large, this function is not satisfied.
:- func toml_key_in(toml_table::in, int::in) = (string::out) is semidet.

%----------------------------------------------------------------------------%
%----------------------------------------------------------------------------%

:- implementation.

:- import_module bool.

%----------------------------------------------------------------------------%

:- pragma foreign_decl("C", 
"
  #include ""toml.h""
  #define ERR_MSG_BUFFER_SIZE 512
").

:- pragma foreign_type("C", toml_table, "toml_table_t*").
:- pragma foreign_type("C", toml_array, "toml_array_t*").

:- pragma foreign_proc("C",
  toml_key_in(InTable::in, Index::in) = (Str::out),
  [will_not_call_mercury, promise_pure],
"
  const char *s = toml_key_in(InTable, Index);
  if (s) {
    MR_make_aligned_string_copy_msg(Str, s, MR_ALLOC_ID);
  }
  SUCCESS_INDICATOR = !!s;
").

:- pragma foreign_proc("C",
  toml_array_in(InTable::in, Key::in) = (OutArray::out),
  [will_not_call_mercury, promise_pure],
"
  OutArray = toml_array_in(InTable, Key);
  SUCCESS_INDICATOR = !!OutArray;
").

:- pragma foreign_proc("C",
  toml_table_in(InTable::in, Key::in) = (OutTable::out),
  [will_not_call_mercury, promise_pure],
"
  OutTable = toml_table_in(InTable, Key);
  SUCCESS_INDICATOR = !!OutTable;
").

:- pragma foreign_proc("C",
  toml_table_at(InTable::in, Idx::in) = (OutTable::out),
  [will_not_call_mercury, promise_pure],
"
  OutTable = toml_table_at(InTable, Idx);
  SUCCESS_INDICATOR = !!OutTable;
").

:- pragma foreign_proc("C",
  toml_string_in(InTable::in, Key::in) = (Str::out),
  [will_not_call_mercury, promise_pure],
"
  toml_datum_t s = toml_string_in(InTable, Key);
  if (s.ok) {
    MR_make_aligned_string_copy_msg(Str, s.u.s, MR_ALLOC_ID);
  }
  SUCCESS_INDICATOR = s.ok;
").

:- pragma foreign_proc("C",
  toml_string_at(Arr::in, Idx::in) = (Str::out),
  [will_not_call_mercury, promise_pure],
"
  toml_datum_t s = toml_string_at(Arr, Idx);
  if (s.ok) {
    MR_make_aligned_string_copy_msg(Str, s.u.s, MR_ALLOC_ID);
  }
  SUCCESS_INDICATOR = s.ok;
").

:- pred toml_parse_file_h(string::in, bool.bool::out, string::out,
  toml_table::out, io::di, io::uo) is det.

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
