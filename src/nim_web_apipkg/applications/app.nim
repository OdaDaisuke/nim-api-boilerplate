import
  db_sqlite,
  ../models/db # DB[obj]

type
  App* = ref object of RootObj
    dbCtx*: DbConn

proc init*(this: App): void {.inline.} =
  discard DB.migrate(this.dbCtx)
