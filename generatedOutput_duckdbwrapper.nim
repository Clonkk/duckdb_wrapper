
# Extracting /home/rcaillaud/.cache/nim/nimterop/duckdb/libduckdb-linux-amd64.zip
# Importing /home/rcaillaud/.cache/nim/nimterop/duckdb/duckdb.h
# Generated @ 2021-01-04T16:02:09+01:00
# Command line:
#   /home/rcaillaud/.nimble/pkgs/nimterop-0.6.13/nimterop/toast --preprocess -m:c --recurse --pnim --dynlib=/home/rcaillaud/.cache/nim/nimterop/duckdb/libduckdb.so --nim:/home/rcaillaud/.choosenim/toolchains/nim-1.4.2/bin/nim --pluginSourcePath=/home/rcaillaud/.cache/nim/nimterop/cPlugins/nimterop_4294221179.nim /home/rcaillaud/.cache/nim/nimterop/duckdb/duckdb.h -o /home/rcaillaud/.cache/nim/nimterop/toastCache/nimterop_2066011615.nim

{.push hint[ConvFromXtoItselfNotNeeded]: off.}
import macros

macro defineEnum(typ: untyped): untyped =
  result = newNimNode(nnkStmtList)

  # Enum mapped to distinct cint
  result.add quote do:
    type `typ`* = distinct cint

  for i in ["+", "-", "*", "div", "mod", "shl", "shr", "or", "and", "xor", "<", "<=", "==", ">", ">="]:
    let
      ni = newIdentNode(i)
      typout = if i[0] in "<=>": newIdentNode("bool") else: typ # comparisons return bool
    if i[0] == '>': # cannot borrow `>` and `>=` from templates
      let
        nopp = if i.len == 2: newIdentNode("<=") else: newIdentNode("<")
      result.add quote do:
        proc `ni`*(x: `typ`, y: cint): `typout` = `nopp`(y, x)
        proc `ni`*(x: cint, y: `typ`): `typout` = `nopp`(y, x)
        proc `ni`*(x, y: `typ`): `typout` = `nopp`(y, x)
    else:
      result.add quote do:
        proc `ni`*(x: `typ`, y: cint): `typout` {.borrow.}
        proc `ni`*(x: cint, y: `typ`): `typout` {.borrow.}
        proc `ni`*(x, y: `typ`): `typout` {.borrow.}
    result.add quote do:
      proc `ni`*(x: `typ`, y: int): `typout` = `ni`(x, y.cint)
      proc `ni`*(x: int, y: `typ`): `typout` = `ni`(x.cint, y)

  let
    divop = newIdentNode("/")   # `/`()
    dlrop = newIdentNode("$")   # `$`()
    notop = newIdentNode("not") # `not`()
  result.add quote do:
    proc `divop`*(x, y: `typ`): `typ` = `typ`((x.float / y.float).cint)
    proc `divop`*(x: `typ`, y: cint): `typ` = `divop`(x, `typ`(y))
    proc `divop`*(x: cint, y: `typ`): `typ` = `divop`(`typ`(x), y)
    proc `divop`*(x: `typ`, y: int): `typ` = `divop`(x, y.cint)
    proc `divop`*(x: int, y: `typ`): `typ` = `divop`(x.cint, y)

    proc `dlrop`*(x: `typ`): string {.borrow.}
    proc `notop`*(x: `typ`): `typ` {.borrow.}


{.pragma: impduckdbHdr,
  header: "/home/rcaillaud/.cache/nim/nimterop/duckdb/duckdb.h".}
{.pragma: impduckdbDyn,
  dynlib: "/home/rcaillaud/.cache/nim/nimterop/duckdb/libduckdb.so".}
{.experimental: "codeReordering".}
defineEnum(DUCKDB_TYPE)
defineEnum(duckdb_state)
const
  DUCKDB_TYPE_INVALID* = (0).DUCKDB_TYPE ## ```
                                         ##   bool
                                         ## ```
  DUCKDB_TYPE_BOOLEAN* = (DUCKDB_TYPE_INVALID + 1).DUCKDB_TYPE ## ```
                                                               ##   bool
                                                               ## ```
  DUCKDB_TYPE_TINYINT* = (DUCKDB_TYPE_BOOLEAN + 1).DUCKDB_TYPE ## ```
                                                               ##   int8_t
                                                               ## ```
  DUCKDB_TYPE_SMALLINT* = (DUCKDB_TYPE_TINYINT + 1).DUCKDB_TYPE ## ```
                                                                ##   int16_t
                                                                ## ```
  DUCKDB_TYPE_INTEGER* = (DUCKDB_TYPE_SMALLINT + 1).DUCKDB_TYPE ## ```
                                                                ##   int32_t
                                                                ## ```
  DUCKDB_TYPE_BIGINT* = (DUCKDB_TYPE_INTEGER + 1).DUCKDB_TYPE ## ```
                                                              ##   int64_t
                                                              ## ```
  DUCKDB_TYPE_FLOAT* = (DUCKDB_TYPE_BIGINT + 1).DUCKDB_TYPE ## ```
                                                            ##   float
                                                            ## ```
  DUCKDB_TYPE_DOUBLE* = (DUCKDB_TYPE_FLOAT + 1).DUCKDB_TYPE ## ```
                                                            ##   double
                                                            ## ```
  DUCKDB_TYPE_TIMESTAMP* = (DUCKDB_TYPE_DOUBLE + 1).DUCKDB_TYPE ## ```
                                                                ##   duckdb_timestamp
                                                                ## ```
  DUCKDB_TYPE_DATE* = (DUCKDB_TYPE_TIMESTAMP + 1).DUCKDB_TYPE ## ```
                                                              ##   duckdb_date
                                                              ## ```
  DUCKDB_TYPE_TIME* = (DUCKDB_TYPE_DATE + 1).DUCKDB_TYPE ## ```
                                                         ##   duckdb_time
                                                         ## ```
  DUCKDB_TYPE_INTERVAL* = (DUCKDB_TYPE_TIME + 1).DUCKDB_TYPE ## ```
                                                             ##   duckdb_interval
                                                             ## ```
  DUCKDB_TYPE_HUGEINT* = (DUCKDB_TYPE_INTERVAL + 1).DUCKDB_TYPE ## ```
                                                                ##   duckdb_hugeint
                                                                ## ```
  DUCKDB_TYPE_VARCHAR* = (DUCKDB_TYPE_HUGEINT + 1).DUCKDB_TYPE ## ```
                                                               ##   const char*
                                                               ## ```
  DuckDBSuccess* = (0).duckdb_state
  DuckDBError* = (1).duckdb_state
type
  idx_t* {.importc, impduckdbHdr.} = uint64
  duckdb_type* {.importc, impduckdbHdr.} = DUCKDB_TYPE
  duckdb_date* {.bycopy, importc, impduckdbHdr.} = object
    year*: int32
    month*: int8
    day*: int8

  duckdb_time* {.bycopy, importc, impduckdbHdr.} = object
    hour*: int8
    min*: int8
    sec*: int8
    msec*: int16

  duckdb_timestamp* {.bycopy, importc, impduckdbHdr.} = object
    date*: duckdb_date
    time*: duckdb_time

  duckdb_interval* {.bycopy, importc, impduckdbHdr.} = object
    months*: int32
    days*: int32
    msecs*: int64

  duckdb_hugeint* {.bycopy, importc, impduckdbHdr.} = object
    lower*: uint64
    upper*: int64

  duckdb_column* {.bycopy, importc, impduckdbHdr.} = object
    data*: pointer
    nullmask*: ptr bool
    `type`*: duckdb_type
    name*: cstring

  duckdb_result* {.bycopy, importc, impduckdbHdr.} = object
    column_count*: idx_t
    row_count*: idx_t
    columns*: ptr duckdb_column
    error_message*: cstring

  duckdb_database* {.importc, impduckdbHdr.} = pointer
  duckdb_connection* {.importc, impduckdbHdr.} = pointer
  duckdb_prepared_statement* {.importc, impduckdbHdr.} = pointer
proc duckdb_open*(path: cstring; out_database: ptr duckdb_database): duckdb_state {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Opens a database file at the given path (nullptr for in-memory). Returns DuckDBSuccess on success, or DuckDBError on
                                  ##     ! failure. [OUT: database]
                                  ## ```
proc duckdb_close*(database: ptr duckdb_database) {.importc, cdecl, impduckdbDyn.}
  ## ```
                                                                                  ##   ! Closes the database.
                                                                                  ## ```
proc duckdb_connect*(database: duckdb_database;
                     out_connection: ptr duckdb_connection): duckdb_state {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Creates a connection to the specified database. [OUT: connection]
                                  ## ```
proc duckdb_disconnect*(connection: ptr duckdb_connection) {.importc, cdecl,
    impduckdbDyn.}
  ## ```
                  ##   ! Closes the specified connection handle
                  ## ```
proc duckdb_query*(connection: duckdb_connection; query: cstring;
                   out_result: ptr duckdb_result): duckdb_state {.importc,
    cdecl, impduckdbDyn.}
  ## ```
                         ##   ! Executes the specified SQL query in the specified connection handle. [OUT: result descriptor]
                         ## ```
proc duckdb_destroy_result*(result: ptr duckdb_result) {.importc, cdecl,
    impduckdbDyn.}
  ## ```
                  ##   ! Destroys the specified result
                  ## ```
proc duckdb_column_name*(result: ptr duckdb_result; col: idx_t): cstring {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Returns the column name of the specified column. The result does not need to be freed;
                                  ##     ! the column names will automatically be destroyed when the result is destroyed.
                                  ## ```
proc duckdb_value_boolean*(result: ptr duckdb_result; col: idx_t; row: idx_t): bool {.
    importc, cdecl, impduckdbDyn.}
proc duckdb_value_int8*(result: ptr duckdb_result; col: idx_t; row: idx_t): int8 {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Converts the specified value to an int8_t. Returns 0 on failure or NULL.
                                  ## ```
proc duckdb_value_int16*(result: ptr duckdb_result; col: idx_t; row: idx_t): int16 {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Converts the specified value to an int16_t. Returns 0 on failure or NULL.
                                  ## ```
proc duckdb_value_int32*(result: ptr duckdb_result; col: idx_t; row: idx_t): int32 {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Converts the specified value to an int64_t. Returns 0 on failure or NULL.
                                  ## ```
proc duckdb_value_int64*(result: ptr duckdb_result; col: idx_t; row: idx_t): int64 {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Converts the specified value to an int64_t. Returns 0 on failure or NULL.
                                  ## ```
proc duckdb_value_float*(result: ptr duckdb_result; col: idx_t; row: idx_t): cfloat {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Converts the specified value to a float. Returns 0.0 on failure or NULL.
                                  ## ```
proc duckdb_value_double*(result: ptr duckdb_result; col: idx_t; row: idx_t): cdouble {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Converts the specified value to a double. Returns 0.0 on failure or NULL.
                                  ## ```
proc duckdb_value_varchar*(result: ptr duckdb_result; col: idx_t; row: idx_t): cstring {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Converts the specified value to a string. Returns nullptr on failure or NULL. The result must be freed with free.
                                  ## ```
proc duckdb_prepare*(connection: duckdb_connection; query: cstring;
                     out_prepared_statement: ptr duckdb_prepared_statement): duckdb_state {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   Prepared Statements
                                  ##     ! prepares the specified SQL query in the specified connection handle. [OUT: prepared statement descriptor]
                                  ## ```
proc duckdb_nparams*(prepared_statement: duckdb_prepared_statement;
                     nparams_out: ptr idx_t): duckdb_state {.importc, cdecl,
    impduckdbDyn.}
proc duckdb_bind_boolean*(prepared_statement: duckdb_prepared_statement;
                          param_idx: idx_t; val: bool): duckdb_state {.importc,
    cdecl, impduckdbDyn.}
  ## ```
                         ##   ! binds parameters to prepared statement
                         ## ```
proc duckdb_bind_int8*(prepared_statement: duckdb_prepared_statement;
                       param_idx: idx_t; val: int8): duckdb_state {.importc,
    cdecl, impduckdbDyn.}
proc duckdb_bind_int16*(prepared_statement: duckdb_prepared_statement;
                        param_idx: idx_t; val: int16): duckdb_state {.importc,
    cdecl, impduckdbDyn.}
proc duckdb_bind_int32*(prepared_statement: duckdb_prepared_statement;
                        param_idx: idx_t; val: int32): duckdb_state {.importc,
    cdecl, impduckdbDyn.}
proc duckdb_bind_int64*(prepared_statement: duckdb_prepared_statement;
                        param_idx: idx_t; val: int64): duckdb_state {.importc,
    cdecl, impduckdbDyn.}
proc duckdb_bind_float*(prepared_statement: duckdb_prepared_statement;
                        param_idx: idx_t; val: cfloat): duckdb_state {.importc,
    cdecl, impduckdbDyn.}
proc duckdb_bind_double*(prepared_statement: duckdb_prepared_statement;
                         param_idx: idx_t; val: cdouble): duckdb_state {.
    importc, cdecl, impduckdbDyn.}
proc duckdb_bind_varchar*(prepared_statement: duckdb_prepared_statement;
                          param_idx: idx_t; val: cstring): duckdb_state {.
    importc, cdecl, impduckdbDyn.}
proc duckdb_bind_null*(prepared_statement: duckdb_prepared_statement;
                       param_idx: idx_t): duckdb_state {.importc, cdecl,
    impduckdbDyn.}
proc duckdb_execute_prepared*(prepared_statement: duckdb_prepared_statement;
                              out_result: ptr duckdb_result): duckdb_state {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Executes the prepared statements with currently bound parameters
                                  ## ```
proc duckdb_destroy_prepare*(prepared_statement: ptr duckdb_prepared_statement) {.
    importc, cdecl, impduckdbDyn.}
  ## ```
                                  ##   ! Destroys the specified prepared statement descriptor
                                  ## ```
{.pop.}

