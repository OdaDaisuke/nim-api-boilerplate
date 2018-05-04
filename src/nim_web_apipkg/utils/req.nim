import
  strutils,
  pegs,
  mofuw,
  unicode

type
  ReqUtil* = ref object
    # req: mofuwReq # インスタンス変数としてmofuwReqをもたせたいけどなんかエラーでできない

# POStリクエストのボディパーサ
proc getPostParam*(this: type ReqUtil, req: mofuwReq, key: string): string {.inline.} =
  let reqParams = req.body.split('&')
  for i in countup(0, reqParams.len - 1) :
    let curParam = reqParams[i]
    let curParamSet = curParam.split("=")
    if curParamSet[0] == key:
      return curParamset[1]
  return ""
