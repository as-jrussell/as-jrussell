#!/bin/bash

# --- CONFIGURATION ---
SOURCE_DB="dba_jcr"
TARGET_DB="InventoryDWH"
PGUSER="your_postgres_user"
PGHOST="your_host"
PGPORT="5432"
TABLE="info.instances"
DUMP_FILE="instances_data.sql"

# --- STEP 1: Create new database ---
createdb -U $PGUSER -h $PGHOST -p $PGPORT $TARGET_DB

# --- STEP 2: Recreate table structure manually ---
psql -U $PGUSER -h $PGHOST -p $PGPORT -d $TARGET_DB <<EOF
CREATE SCHEMA IF NOT EXISTS info;

CREATE TABLE info.instances (
    instance_name TEXT PRIMARY KEY,
    environment TEXT,
    db_host TEXT,
    db_port INT,
    db_name TEXT,
    db_user TEXT,
    db_description TEXT
);
EOF

# --- STEP 3: Dump data from source database ---
pg_dump -U $PGUSER -h $PGHOST -p $PGPORT -d $SOURCE_DB -t $TABLE --data-only --column-inserts > $DUMP_FILE

# --- STEP 4: Load data into new database ---
psql -U $PGUSER -h $PGHOST -p $PGPORT -d $TARGET_DB -f $DUMP_FILE

# --- DONE ---
echo "✅ Migration complete. Data copied from $SOURCE_DB.$TABLE to $TARGET_DB.$TABLE"
