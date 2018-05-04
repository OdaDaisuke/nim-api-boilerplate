import
  db_sqlite,
  ../models/db,
  ../models/accountModel

type
  AccountDomain* = ref object

let dbCtx = DB.getContext()

# Create new account.
proc register*(
  this: type AccountDomain,
  name: string,
  mailAddress: string,
  password: string
): string {.inline.} =
  try:
    var createRs = AccountModel.createAccount(
      dbCtx,
      name,
      mailAddress,
      password
    )
    return createRs
  except:
    return ""

proc signin*(
  this: type AccountDomain,
  mailAddress: string,
  password: string
): seq[string] {.inline.} =
  var signinRs: seq[string]
  try:
    signinRs = AccountModel.signin(
      dbCtx,
      mailAddress,
      password
    )
  except:
    echo "failed"
    return @[""]
  return signinRs

proc me*(
  this: type AccountDomain,
  mailAddress: string,
  password: string
): seq[string] {.inline.} =

  var me: seq[string]
  try:
    me = AccountModel.getMe(
      dbCtx,
      mailAddress,
      password
    )
  except:
    echo "failed"
  return me
