# Nim API server sample
use Nim with mofuw

```bash
$ nimble install mofuw
$ nimble install dotenv
$ nimble install jwt
$ cp .env.default .env
$ nimble server
```

## Design pattern
Implementing Domain-Driven-Design(Onion architecture)

## Directory

```bash
/docs # PostMan collection
/src
  |
  | - /nim_web_apipkg
        |
        | - nim_web_api.nim
        | - /applications # Request handlers
        | - /domains # Action domains
        | - /gateways # Thirdparty action gateways
        | - /models # DB Models
        | - /utils # Utility actions
# ...etc...
```

## Endpoints

- POST - `/api/register` (name, mail_address, password)
- POST - `/api/signin` (mail_address, password) returns JWT token.
- POST - `/api/me` (mail_address, password) and Set JWT-token to Bearer.
