import
  db_sqlite,
  os,
  sha1,
  dotenv

let env = initDotEnv()
env.load

type
  AccountModel* = ref object
    dbCtx*: DbConn

proc createAccount*(
  this: AccountModel,
  name: string,
  mail_address: string,
  password: SHA1Digest
): string {.inline.} =
  try:
    this.dbCtx.exec(sql"BEGIN")
    this.dbCtx.exec(
      sql("INSERT INTO user (name, mail_address, password) VALUES (?, ?, ?)"),
      name, mail_address, password
    )
    this.dbCtx.exec(sql"COMMIT")
    echo "succeed"
    return "succeed"
  except:
    echo "DB exception!"

proc signin*(
  this: AccountModel,
  email: string,
  password: SHA1Digest
): seq[string] {.inline.} =
  try:
    this.dbCtx.exec(sql"BEGIN")
    var userData = this.dbCtx.getRow(
      sql("select * from user where mail_address = ? and password = ? limit 1"),
      email, password
    )
    this.dbCtx.exec(sql"COMMIT")
    return userData
  except:
    echo "DB exception!"

proc getMe*(
  this: AccountModel,
  email: string,
  password: string
): seq[string] {.inline.} =
  try:
    this.dbCtx.exec(sql"BEGIN")
    var userData = this.dbCtx.getRow(
      sql("select * from user where mail_address = ? and password = ? limit 1"),
      email, password
    )
    this.dbCtx.exec(sql"COMMIT")
    return userData
  except:
    echo "DB exception!"

proc getMeByEmail*(this: AccountModel, email: string): seq[string] {.inline.} =
  try:
    this.dbCtx.exec(sql"BEGIN")
    var userData = this.dbCtx.getRow(
      sql("select * from user where mail_address = ? limit 1"),
      email
    )
    this.dbCtx.exec(sql"COMMIT")
    return userData
  except:
    echo "DB exception!"