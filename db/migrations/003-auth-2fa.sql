-- migrate:up

-- 1) add column to user table
ALTER TABLE auth_data.user
ADD COLUMN IF NOT EXISTS "twoFactorEnabled" boolean;

-- 2) create twoFactor table
CREATE TABLE IF NOT EXISTS auth_data.twoFactor (
  "id" text PRIMARY KEY,
  "userId" text NOT NULL REFERENCES auth_data.user("id") ON DELETE CASCADE,
  "secret" text,
  "backupCodes" text
);

-- (optional but recommended) one 2FA row per user
CREATE UNIQUE INDEX IF NOT EXISTS "twoFactor_userId_unique"
ON auth_data.twoFactor ("userId");

