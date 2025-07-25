#!/bin/bash

# Prompt for credentials once
read -p "Enter PostgreSQL user: " PGUSER
read -s -p "Enter PostgreSQL password: " PGPASSWORD
echo
export PGPASSWORD

# Loop through each host in initial_setup.txt
while IFS= read -r HOST || [[ -n "$HOST" ]]; do
  echo "\n🌐 Connecting to host: $HOST"

  # Skip blank or commented lines
  [[ -z "$HOST" || "$HOST" =~ ^# ]] && continue

  # Query list of valid databases (excluding system/admin ones)
  DATABASES=$(psql -h "$HOST" -U "$PGUSER" -d "postgres" -tAc \
  "SELECT datname FROM pg_database \
   WHERE datistemplate = false \
     AND datname NOT IN ('DBA','dba','postgres','rdsadmin');")

  for DB in $DATABASES; do
    echo "\n🔁 [$HOST] Applying permissions to DB: $DB"

    psql -h "$HOST" -U "$PGUSER" -d "$DB" <<EOF
\set customerdbname '$DB'
\i grant_permissions.sql
EOF

    if [ $? -eq 0 ]; then
      echo "✅ [$HOST] $DB - Success"
    else
      echo "❌ [$HOST] $DB - Failed"
    fi
  done

done < initial_setup.txt
