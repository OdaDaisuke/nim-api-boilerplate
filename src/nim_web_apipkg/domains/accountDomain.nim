import
  db_sqlite,
  sha1,
  ../models/db,
  ../models/accountModel

type
  AccountDomain* = ref object
    dbCtx*: DbConn
    accountModel*: AccountModel

proc hashPw(pw: string): SHA1Digest =
  const salt = "A0cek2_"
  return sha1.compute(pw & salt)

# Create new account.
proc register*(
  this: AccountDomain,
  name: string,
  mailAddress: string,
  password: string
): string {.inline.} =
  try:
    return this.accountModel.createAccount(
      name,
      mailAddress,
      hashPw(password)
    )
  except:
    return ""

proc signin*(
  this: AccountDomain,
  mailAddress: string,
  password: string
): seq[string] {.inline.} =
  var signinRs: seq[string]
  try:
    return this.accountModel.signin(mailAddress, hashPw(password))
  except:
    echo "failed"
    return @[""]

proc me*(
  this: AccountDomain,
  email: string,
  password: string
): seq[string] {.inline.} =

  var me: seq[string]
  try:
    me = this.accountModel.getMe(email, password)
  except:
    echo "failed"
  return me

proc getMeByEmail*(this: AccountDomain, email: string): seq[string] {.inline.} =
  var me: seq[string]
  try:
    me = this.accountModel.getMeByEmail(email)
  except:
    echo "failed"
  return me