import
  db_sqlite,
  os,
  dotenv

let env = initDotEnv()
env.load()

type
  DB* = ref object

proc getContext*(this: type DB): DbConn {.inline.} =
  let db = open(os.getEnv("DB_NAME"), nil, nil, nil)
  return db

proc migrate*(this: type DB, dbCtx: DbConn): bool {.inline.} =
  let file = open(os.getEnv("DB_NAME"))

  echo "Init DB"
  try:
    if file.getFileSize() == 0:
      dbCtx.exec(sql("""
        create table user (
          id integer primary key autoincrement,
          name text not null,
          mail_address text not null,
          password text not null)
      """))
  except:
    echo "DB Error occured"
    return false
  echo "---[end]Init DB---"

  return true
