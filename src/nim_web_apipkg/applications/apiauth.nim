import
  mofuw,
  json,
  db_sqlite,
  strutils,
  app, # AppCtrl[obj]
  ../utils/req, # ReqUtil[obj]
  ../domains/apiauthDomain # APIAuthDomain[obj]

type
  APIAuthHandler* = ref object of AppHandler

proc signToken(s: string): string =
  return APIAuthDomain.sign(s)

proc getToken*(this: type APIAuthHandler, req: mofuwReq, res: mofuwRes): void {.inline.} =
  var mailAddress = ReqUtil.getPostParam(req, "mail_address")
  var password = ReqUtil.getPostParam(req, "password")
  var jwtRes = signToken(mailAddress & password)
  let authRes = %*{
    "access_token": jwtRes
  }
  mofuwResp(HTTP200, "application/json", $authRes)

# refresh token
proc refresh*(this: type APIAuthHandler, req: mofuwReq, res: mofuwRes): void {.inline.} =
  var oldAccessToken = replace(getHeader(req, "Authorization"), "Bearer ", "")
  if APIAuthDomain.verify(oldAccessToken) != true:
    mofuwResp(HTTP200, "application/json", ${"status": "failed"})
  var jwtRes = signToken(oldAccessToken)
  let authRes = %*{
    "access_token": jwtRes
  }
  mofuwResp(HTTP200, "application/json", $authRes)
