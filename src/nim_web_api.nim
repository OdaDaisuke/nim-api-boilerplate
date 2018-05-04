import
  mofuw,
  db_sqlite,
  nim_web_apipkg/applications/account, # AccountHandler[obj]
  nim_web_apipkg/applications/apiauth, # APIAuthHandler[obj]
  nim_web_apipkg/applications/app # AppHandler[obj]

AppHandler.appInit() # DBマイグレーションなどが行われる

proc handler(req: mofuwReq, res: mofuwRes) {.async.} =
  routes:
    post "/api/get_token":
      APIAuthHandler.getToken(req, res)

    put "/api/refresh":
      APIAuthHandler.refresh(req, res)

    post "/api/register":
      AccountHandler.register(req, res)

    post "/api/signin":
      AccountHandler.signin(req, res)

    post "/api/me":
      AccountHandler.me(req, res)

echo "Start server on localhost:8080"
handler.mofuwRun()
