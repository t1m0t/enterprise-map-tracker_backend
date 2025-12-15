-- migrate:up
-- Better Auth core schema (PostgreSQL)

CREATE TABLE IF NOT EXISTS auth_data.user (
  "id"            text PRIMARY KEY,
  "name"          text NOT NULL,
  "email"         text NOT NULL,
  "emailVerified" boolean NOT NULL DEFAULT false,
  "image"         text NULL,
  "createdAt"     timestamptz NOT NULL DEFAULT now(),
  "updatedAt"     timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS "user_email_uq" ON auth_data.user ("email");


CREATE TABLE IF NOT EXISTS auth_data.session (
  "id"        text PRIMARY KEY,
  "userId"    text NOT NULL REFERENCES auth_data.user("id"),
  "token"     text NOT NULL,
  "expiresAt" timestamptz NOT NULL,
  "ipAddress" text NULL,
  "userAgent" text NULL,
  "createdAt" timestamptz NOT NULL DEFAULT now(),
  "updatedAt" timestamptz NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS "session_token_uq" ON auth_data.session ("token");
CREATE INDEX IF NOT EXISTS "session_userId_idx" ON auth_data.session ("userId");
CREATE INDEX IF NOT EXISTS "session_expiresAt_idx" ON auth_data.session ("expiresAt");


CREATE TABLE IF NOT EXISTS auth_data.account (
  "id"                   text PRIMARY KEY,
  "userId"               text NOT NULL REFERENCES auth_data.user("id"),
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

CREATE INDEX IF NOT EXISTS "account_userId_idx" ON auth_data.account ("userId");
CREATE INDEX IF NOT EXISTS "account_providerId_idx" ON auth_data.account ("providerId");


CREATE TABLE IF NOT EXISTS auth_data.verification (
  "id"        text PRIMARY KEY,
  "identifier" text NOT NULL,
  "value"     text NOT NULL,
  "expiresAt" timestamptz NOT NULL,
  "createdAt" timestamptz NOT NULL DEFAULT now(),
  "updatedAt" timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS "verification_identifier_idx" ON auth_data.verification ("identifier");
CREATE INDEX IF NOT EXISTS "verification_expiresAt_idx" ON auth_data.verification ("expiresAt");

