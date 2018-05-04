import
  db_sqlite,
  os,
  dotenv

let env = initDotEnv()
env.load

type
  AccountModel* = ref object
    dbCtx: DbConn

proc createAccount*(
  this: type AccountModel,
  dbCtx: DbConn,
  name: string,
  mail_address: string,
  password: string
): string {.inline.} =
  try:
    dbCtx.exec(sql"BEGIN")
    dbCtx.exec(
      sql("INSERT INTO user (name, mail_address, password) VALUES (?, ?, ?)"),
      name, mail_address, password
    )
    dbCtx.exec(sql"COMMIT")
    echo "succeed"
    return "succeed"
  except:
    echo "DB exception!"

proc signin*(
  this: type AccountModel,
  dbCtx: DbConn,
  mail_address: string,
  password: string
): seq[string] {.inline.} =
  try:
    dbCtx.exec(sql"BEGIN")
    var userData = dbCtx.getRow(
      sql("select * from user where mail_address = ? and password = ? limit 1"),
      mail_address, password
    )
    dbCtx.exec(sql"COMMIT")
    return userData
  except:
    echo "DB exception!"

proc getMe*(
  this: type AccountModel,
  dbCtx: DbConn,
  mail_address: string,
  password: string
): seq[string] {.inline.} =
  try:
    dbCtx.exec(sql"BEGIN")
    var userData = dbCtx.getRow(
      sql("select * from user where mail_address = ? and password = ? limit 1"),
      mail_address, password
    )
    dbCtx.exec(sql"COMMIT")
    return userData
  except:
    echo "DB exception!"
