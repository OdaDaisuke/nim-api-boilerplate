# APIのJWT認証周り
import
  jwt,
  json,
  times,
  tables

type
  APIAuthDomain* = ref object

var secret = "secret"

proc sign*(this: type APIAuthDomain, seedStr: string): string {.inline.} =
  var token = toJWT(%*{
      "header": {
        "alg": "HS256",
        "typ": "JWT"
      },
      "claims": {
        "seedStr": seedStr,
        "exp": (getTime() + 1.hours).toSeconds().int
      }
    })
  token.sign(secret)
  return $token

proc verify*(this: type APIAuthDomain, token: string): bool {.inline.} =
  try:
    let jwtToken = token.toJWT()
    result = jwtToken.verify(secret)
  except InvalidToken:
    result = false
  return result
