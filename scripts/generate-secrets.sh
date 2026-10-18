#!/bin/bash
set -euo pipefail

echo "🔐 Generating production secrets..."

# JWT Secret (32 bytes = 64 hex chars, URL & sed safe)
export JWT_SECRET=$(openssl rand -hex 32 | tr -d '\n')

# Encryption Master Key (32 bytes = 64 hex chars)
export ENCRYPTION_MASTER_KEY=$(openssl rand -hex 32 | tr -d '\n')

# PostgreSQL Password (24 bytes = 48 hex chars, URL-safe for DATABASE_URL)
export POSTGRES_PASSWORD=$(openssl rand -hex 24 | tr -d '\n')

# Touch .env if it doesn't exist
touch .env

# Append or update secrets in .env
grep -q "^JWT_SECRET=" .env 2>/dev/null && sed -i.bak "s|^JWT_SECRET=.*|JWT_SECRET=$JWT_SECRET|" .env || echo "JWT_SECRET=$JWT_SECRET" >> .env
grep -q "^ENCRYPTION_MASTER_KEY=" .env 2>/dev/null && sed -i.bak "s|^ENCRYPTION_MASTER_KEY=.*|ENCRYPTION_MASTER_KEY=$ENCRYPTION_MASTER_KEY|" .env || echo "ENCRYPTION_MASTER_KEY=$ENCRYPTION_MASTER_KEY" >> .env
grep -q "^POSTGRES_PASSWORD=" .env 2>/dev/null && sed -i.bak "s|^POSTGRES_PASSWORD=.*|POSTGRES_PASSWORD=$POSTGRES_PASSWORD|" .env || echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> .env

rm -f .env.bak

echo "✅ Secrets generated and updated in .env"
echo "⚠️ Ensure .env is added to .gitignore!"
