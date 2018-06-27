# Mofuw(Nim) API Boilerplate
use Nim with mofuw

```bash
$ nimble install mofuw
$ nimble install dotenv
$ nimble install jwt
$ cp .env.default .env
$ sh setup.sh YOUR_PROJECT_NAME # change project name
$ nimble server # start server
```

## Design pattern
Implementing Domain-Driven-Design(Eric's Layered architecture)

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
