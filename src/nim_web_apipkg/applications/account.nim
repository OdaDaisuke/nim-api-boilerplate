import
  mofuw,
  json,
  db_sqlite,
  strutils,
  app, # AppHandler[obj]
  ../utils/req, # ReqUtil[obj]
  ../domains/accountDomain, # AccountDomain[obj]
  ../domains/apiauthDomain # APIAuthDomain[obj]

type
  AccountHandler* = ref object of AppHandler

proc verifyToken(token: string): bool =
  return APIAuthDomain.verify(token)

# register
proc register*(this: type AccountHandler, req: mofuwReq, res: mofuwRes): void {.inline.} =
  let params: tuple[
    name: string,
    mailAddress: string,
    password: string
  ] = (
    ReqUtil.getPostParam(req, "name"),
    ReqUtil.getPostParam(req, "mail_address"),
    ReqUtil.getPostParam(req, "password")
  )

  let insertRs = AccountDomain.register(
    params.name,
    params.mailAddress,
    params.password
  )
  let registerRes = %*{
    "status": insertRs
  }

  mofuwResp( HTTP200, "application/json", $registerRes )

# signin
proc signin*(this: type AccountHandler, req: mofuwReq, res: mofuwRes): void {.inline.} =
  let dbParams: tuple[
    mailAddress: string,
    password: string
  ] = (
    ReqUtil.getPostParam(req, "mail_address"),
    ReqUtil.getPostParam(req, "password")
  )
  var token = replace(getHeader(req, "Authorization"), "Bearer ", "")

  if verifyToken(token) != true:
    mofuwResp(HTTP200, "application/json", ${"status": ""})

  var queryRs = AccountDomain.signin(
    dbParams.mailAddress,
    dbParams.password
  )

  if queryRs == nil:
    queryRs = @[""]

  let signinRs = %*{
    "status": queryRs
  }

  mofuwResp(HTTP200, "application/json", $signinRs)

# get logined user account infomation
proc me*(this: type AccountHandler, req: mofuwReq, res: mofuwRes): void {.inline.} =
  var mail_address = ReqUtil.getPostParam(req, "mail_address")
  var password = ReqUtil.getPostParam(req, "password")
  var token = replace(getHeader(req, "Authorization"), "Bearer ", "")

  if verifyToken(token) != true:
    mofuwResp(HTTP200, "application/json", ${"status": ""})

  var queryRs = AccountDomain.me(mail_address, password)
  if queryRs == nil:
    queryRs = @[""]

  let meRs = %*{
    "status": queryRs
  }

  mofuwResp(HTTP200, "application/json", $meRs)
