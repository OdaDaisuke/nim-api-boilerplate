import
  mofuw,
  json,
  db_sqlite,
  strutils,
  app, # App[obj]
  ../domains/accountDomain, # AccountDomain[obj]
  ../domains/apiauthDomain # APIAuthDomain[obj]

type
  AccountHandler* = ref object of App
    accountDomain*: AccountDomain
    apiAuthDomain*: APIAuthDomain

# register
proc register*(this: AccountHandler, ctx: MofuwCtx): void {.inline.} =
  let params: tuple[
    name: string,
    mailAddress: string,
    password: string
  ] = (
    ctx.body("name"),
    ctx.body("mail_address"),
    ctx.body("password")
  )

  let insertRs = this.accountDomain.register(
    params.name,
    params.mailAddress,
    params.password
  )
  let registerRes = %*{
    "status": insertRs
  }

  mofuwResp( HTTP200, "application/json", $registerRes )

# signin
proc signin*(this: AccountHandler, ctx: MofuwCtx): void {.inline.} =
  let dbParams: tuple[
    mailAddress: string,
    password: string
  ] = (
    ctx.body("mail_address"),
    ctx.body("password")
  )

  var queryRs = this.accountDomain.signin(
    dbParams.mailAddress,
    dbParams.password
  )

  if queryRs == nil:
    queryRs = @[""]

  # publish JWT
  var token = this.apiAuthDomain.getSignedToken(dbParams.mailAddress, dbParams.password)

  let signinRs = %*{
    "status": queryRs,
    "token": token
  }

  mofuwResp(HTTP200, "application/json", $signinRs)

# get logined user account infomation
proc me*(this: AccountHandler, ctx: MofuwCtx): void {.inline.} =
  var token = replace(getHeader(ctx, "Authorization"), "Bearer ", "")

  if this.apiAuthDomain.verify(token) != true:
    mofuwResp(HTTP200, "application/json", ${"status": ""})

  let mailAddress = decodeUrl(this.apiAuthDomain.decode(token))
  var queryRs = this.accountDomain.getMeByEmail(mailAddress)
  if queryRs == nil:
    queryRs = @[""]

  let meRs = %*{
    "status": queryRs
  }

  mofuwResp(HTTP200, "application/json", $meRs)
