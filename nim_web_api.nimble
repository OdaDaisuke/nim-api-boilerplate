# Package

version       = "1.0.0"
author        = "OdaDaisuke"
description   = "Nim API server implements mofuw framework."
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["nim_web_api"]
skipDirs      = @["tools"]

# Dependencies

requires "nim >= 0.18.0"
requires "mofuw >= 0.1.1"
requires "dotenv >= 1.1.0"
requires "jwt >= 0.0.1"

task server, "start server":
  rmDir "bin"
  exec "nimble build --threads:on"
  exec "bin/nim_web_api"
