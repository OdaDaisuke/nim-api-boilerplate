# APIのJWT認証周り
import
  jwt,
  json,
  times,
  tables

type
  APIAuthDomain* = ref object
    secret*: string

proc init*(this: APIAuthDomain): void {.inline.} =
  this.secret = "secret"

proc getSignedToken*(this: APIAuthDomain, mailAddress: string, password : string): string {.inline.} =
  var token = toJWT(%*{
      "header": {
        "alg": "HS256",
        "typ": "JWT"
      },
      "claims": {
        "mail_address": mailAddress,
        "password": password,
        "exp": (getTime() + 24.hours).toSeconds().int
      }
    })
  token.sign(this.secret)
  return $token

proc verify*(this: APIAuthDomain, token: string): bool {.inline.} =
  try:
    return token.toJWT().verify(this.secret)
  except InvalidToken:
    return false

proc decode*(this: APIAuthDomain, token: string): string {.inline.} =
  try:
    let jwtToken = token.toJWT()
    return $jwtToken.claims["mail_address"].node.str
  except InvalidToken:
    return ""