include duckdb_wrapper

# You should now be able to use duckdb API
proc main() =
  var db: duckdb_database
  var con: duckdb_connection

  if (duckdb_open(nil, db.addr) == DuckDBError):
    echo "Error"
  if (duckdb_connect(db, con.addr) == DuckDBError):
    echo "Error"

  ##  create a table
  if duckdb_query(con, "CREATE TABLE integers(i INTEGER, j INTEGER);", nil) == DuckDBError:
    echo "Error"
  if duckdb_query(con, "INSERT INTO integers VALUES (3, 4), (5, 6), (7, NULL);", nil) == DuckDBError:
    echo "Error"

  var res : duckdb_result
  if duckdb_query(con, "SELECT * FROM integers", addr(res)) == DuckDBError:
    echo "Error"

  # 3 Rows
  for row in 0..<3:
    # 2 Col
    for col in 0..<2:
      let val = duckdb_value_varchar(addr(res), col.csize_t, row.csize_t)
      echo val
      dealloc(val)

  duckdb_destroy_result(addr(res))

main()
