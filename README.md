# SETUP

The backend app is composed of:

- postgres database (see db/SETUP.md)
- home made migration tool (so far uses only .sql files, .ts migration handling
  will be added)
- backoffice app in hono
- pg_tileserver to server maplibre gl js client
