import
  mofuw,
  db_sqlite,
  nim_web_apipkg/models/db, # DB[obj]
  nim_web_apipkg/models/accountModel, # AccountModel[obj]
  nim_web_apipkg/domains/accountDomain, # AccountDomain[obj]
  nim_web_apipkg/domains/apiauthDomain, # APIAuthDomain[obj]
  nim_web_apipkg/applications/app, # App[obj]
  nim_web_apipkg/applications/account # AccountHandler[obj]

let dbCtx = DB.getContext()
App(dbCtx: dbCtx).init() # DB init

# Models
let acm = AccountModel(dbCtx: dbCtx)

# Domain
let acd = AccountDomain(dbCtx: dbCtx, accountModel: acm)
let aad = APIAuthDomain()
aad.init()

let accountHandler = AccountHandler(accountDomain: acd, apiAuthDomain: aad)

routes:
  post "/api/register":
    accountHandler.register(ctx)

  post "/api/signin":
    accountHandler.signin(ctx)

  post "/api/me":
    accountHandler.me(ctx)

echo "Start server on localhost:8080"

newServeCtx(
  port = 8080,
  handler = mofuwHandler
).serve()