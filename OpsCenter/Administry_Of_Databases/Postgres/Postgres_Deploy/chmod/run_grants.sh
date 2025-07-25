#!/bin/bash

# --- Prompt for connection info ---
read -p "Enter PostgreSQL user: " PGUSER
read -s -p "Enter PostgreSQL password: " PGPASSWORD
echo
export PGPASSWORD

# --- Set your DB connection target ---
DB_HOST="localhost"
DEFAULT_DB="postgres"

# --- Get user-defined databases (excluding system ones) ---
DATABASES=$(psql -h "$DB_HOST" -U "$PGUSER" -d "$DEFAULT_DB" -tAc \
"SELECT datname FROM pg_database WHERE datistemplate = false AND datname NOT IN ('DBA','dba','postgres');")

# --- Set the schema to apply permissions to ---
SCHEMA_NAME="myspecialschema"  # <- Replace with your actual schema name

# --- Loop through each database ---
for DB in $DATABASES; do
  echo "🔁 Processing database: $DB"

  # Run the SQL script with variables injected
  psql -h "$DB_HOST" -U "$PGUSER" -d "$DB" <<EOF
\set customerdbname '$DB'
\set schemaname '$SCHEMA_NAME'
\i grant_permissions.sql
EOF

  # Check if it succeeded
  if [ $? -eq 0 ]; then
    echo "✅ Permissions applied to $DB"
  else
    echo "❌ Failed to apply permissions to $DB"
  fi

done
