#!/bin/bash
set -e

DBNAME="DBA2"
USERNAME="postgres"

# Step 1: Check if database exists
echo "Checking if database '$DBNAME' exists..."
DB_EXISTS=$(psql -U "$USERNAME" -tAc "SELECT 1 FROM pg_database WHERE datname = '$DBNAME'")
if [ "$DB_EXISTS" != "1" ]; then
  echo "Database '$DBNAME' does not exist. Creating..."
  createdb -U "$USERNAME" --encoding='UTF8' --lc-collate='en_US.UTF-8' --lc-ctype='en_US.UTF-8' --template=template0 "$DBNAME"
  echo "PASS: Database '$DBNAME' created."
else
  echo "SKIP: Database '$DBNAME' already exists."
fi

# Step 2: Run the test script
echo "Running testme.sql against database '$DBNAME'..."
psql -U "$USERNAME" -d "$DBNAME" -f testme.sql
