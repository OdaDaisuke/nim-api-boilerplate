import
  mofuw,
  json,
  ../models/db # DB[obj]

type
  AppHandler* = ref object of RootObj

proc appInit*(this: type AppHandler): void {.inline.} =
  # DBマイグレーション
  let dbCtx = DB.getContext()
  discard DB.migrate(dbCtx)
  dbCtx.close()
