import
  db_sqlite,
  sha1,
  ../models/db,
  ../models/accountModel

type
  AccountDomain* = ref object

let dbCtx = DB.getContext()

proc hashPw(pw: string): SHA1Digest =
  const salt = "A0cek2_"
  return sha1.compute(pw & salt)

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
      hashPw(password)
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
      hashPw(password)
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
