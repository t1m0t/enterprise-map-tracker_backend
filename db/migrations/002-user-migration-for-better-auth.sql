-- Better Auth core schema (PostgreSQL)

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'auth_user') THEN
    CREATE ROLE auth_user
      WITH LOGIN PASSWORD 'auth_password';
  END IF;
END $$;

CREATE SCHEMA IF NOT EXISTS auth_data AUTHORIZATION auth_user;

CREATE TABLE IF NOT EXISTS "user" (
  "id"            text PRIMARY KEY,
  "name"          text NOT NULL,
  "email"         text NOT NULL,
  "emailVerified" boolean NOT NULL DEFAULT false,
  "image"         text NULL,
  "createdAt"     timestamptz NOT NULL DEFAULT now(),
  "updatedAt"     timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS "user_email_uq" ON "user" ("email");


CREATE TABLE IF NOT EXISTS "session" (
  "id"        text PRIMARY KEY,
  "userId"    text NOT NULL REFERENCES "user"("id") ON DELETE CASCADE,
  "token"     text NOT NULL,
  "expiresAt" timestamptz NOT NULL,
  "ipAddress" text NULL,
  "userAgent" text NULL,
  "createdAt" timestamptz NOT NULL DEFAULT now(),
  "updatedAt" timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS "session_token_uq" ON "session" ("token");
CREATE INDEX IF NOT EXISTS "session_userId_idx" ON "session" ("userId");
CREATE INDEX IF NOT EXISTS "session_expiresAt_idx" ON "session" ("expiresAt");


CREATE TABLE IF NOT EXISTS "account" (
  "id"                   text PRIMARY KEY,
  "userId"               text NOT NULL REFERENCES "user"("id") ON DELETE CASCADE,
  "accountId"            text NOT NULL,
  "providerId"           text NOT NULL,
  "accessToken"          text NULL,
  "refreshToken"         text NULL,
  "accessTokenExpiresAt" timestamptz NULL,
  "refreshTokenExpiresAt" timestamptz NULL,
  "scope"                text NULL,
  "idToken"              text NULL,
  "password"             text NULL,
  "createdAt"            timestamptz NOT NULL DEFAULT now(),
  "updatedAt"            timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT "account_provider_account_uq" UNIQUE ("providerId", "accountId")
);

CREATE INDEX IF NOT EXISTS "account_userId_idx" ON "account" ("userId");
CREATE INDEX IF NOT EXISTS "account_providerId_idx" ON "account" ("providerId");


CREATE TABLE IF NOT EXISTS "verification" (
  "id"        text PRIMARY KEY,
  "identifier" text NOT NULL,
  "value"     text NOT NULL,
  "expiresAt" timestamptz NOT NULL,
  "createdAt" timestamptz NOT NULL DEFAULT now(),
  "updatedAt" timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS "verification_identifier_idx" ON "verification" ("identifier");
CREATE INDEX IF NOT EXISTS "verification_expiresAt_idx" ON "verification" ("expiresAt");

