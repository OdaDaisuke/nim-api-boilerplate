import
  mofuw,
  db_sqlite,
  nim_web_apipkg/applications/account, # AccountHandler[obj]
  nim_web_apipkg/applications/app # AppHandler[obj]

AppHandler.appInit() # DBマイグレーションなどが行われる

proc handler(req: mofuwReq, res: mofuwRes) {.async.} =
  routes:

    post "/api/register":
      AccountHandler.register(req, res)

    post "/api/signin":
      AccountHandler.signin(req, res)

    post "/api/me":
      AccountHandler.me(req, res)

echo "Start server on localhost:8080"
handler.mofuwRun()
