import
  strutils,
  pegs,
  mofuw,
  unicode

type
  ReqUtil* = ref object
    mofuwCtx*: MofuwCtx

# Body parser of POST Request.
proc getPostParam*(this: ReqUtil, key: string): string {.inline.} =
  let reqParams = this.mofuwCtx.body.split('&')
  for i in countup(0, reqParams.len - 1) :
    let curParam = reqParams[i]
    let curParamSet = curParam.split("=")
    if curParamSet[0] == key:
      return curParamset[1]
  return ""
