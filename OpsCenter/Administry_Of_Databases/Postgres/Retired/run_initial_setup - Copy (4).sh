#!/bin/bash
# ==========================================
# Script: run_initial_setup_folder_split.sh
# Purpose: Run SQL scripts on DBA and user DBs from structured folder sets
# ==========================================

read -p "Enter PostgreSQL user: " PGUSER
read -s -p "Enter PostgreSQL password: " PGPASSWORD
echo
export PGPASSWORD

# --- CONFIGURATION ---
PGPORT="5432"
DEPLOY_DIR="/c/GitHub/as-jrussell/Opscenter/Administry_Of_Databases/Postgres/Postgres_Deploy/chmod/Deploy"
INPUT_FILE="initial_setup.txt"
LOG_DIR="logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M")
LOG_FILE="$LOG_DIR/initial_setup_$TIMESTAMP.log"
LATEST_LOG_LINK="initial_setup.log"

mkdir -p "$LOG_DIR"
ABS_LOG_FILE=$(realpath "$LOG_FILE")
ABS_LINK_TARGET=$(realpath "$(dirname "$0")")/$LATEST_LOG_LINK
ln -sf "$ABS_LOG_FILE" "$ABS_LINK_TARGET"
echo "🔧 Initial Setup Log - $TIMESTAMP" > "$LOG_FILE"

# Define folder sets as arrays to support spaces
DBA_FOLDERS=(
  "$DEPLOY_DIR/1 initial"
  "$DEPLOY_DIR/2 deploy"
  "$DEPLOY_DIR/3 info"
  "$DEPLOY_DIR/4 admin"
)

USER_DB_FOLDERS=(
  "$DEPLOY_DIR/5 other"
)

# === HOST LOOP ===
while read -r HOST; do
  [[ -z "$HOST" ]] && continue
  echo "🚀 Running on $HOST..."
  echo "=== $HOST ===" >> "$LOG_FILE"

  # --- 1. Run Against DBA if Present ---
  DBA_EXISTS=$(psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d postgres -Atc "SELECT 1 FROM pg_database WHERE datname = 'DBA';")
  if [[ "$DBA_EXISTS" == "1" ]]; then
    echo "✅ DBA found. Executing against DBA..." | tee -a "$LOG_FILE"

    for FOLDER in "${DBA_FOLDERS[@]}"; do
      find "$FOLDER" -type f -name '*.sql' | sort | while read -r SCRIPT; do
        echo "📄 [DBA] $SCRIPT" >> "$LOG_FILE"
        echo "🔗 Running: psql -U \"$PGUSER\" -h \"$HOST\" -p \"$PGPORT\" -d DBA -f \"$SCRIPT\"" >> "$LOG_FILE"
        psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d DBA -f "$SCRIPT" >> "$LOG_FILE" 2>&1
        if [[ $? -ne 0 ]]; then
          echo "❌ ERROR running $SCRIPT against DBA" | tee -a "$LOG_FILE"
          echo "--- FAILED COMMAND ---" >> "$LOG_FILE"
          echo "psql -U \"$PGUSER\" -h \"$HOST\" -p \"$PGPORT\" -d DBA -f \"$SCRIPT\"" >> "$LOG_FILE"
          echo "--- BEGIN FAILED SCRIPT: $SCRIPT ---" >> "$LOG_FILE"
          cat "$SCRIPT" >> "$LOG_FILE"
          echo "--- END FAILED SCRIPT ---" >> "$LOG_FILE"
        fi
      done
    done

  else
    echo "⚠️ DBA not found on $HOST. Skipping DBA deployment." | tee -a "$LOG_FILE"
  fi

  # --- 2. Run Against All Non-System DBs ---
  USER_DBS=$(psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d postgres -Atc \
    "SELECT datname FROM pg_database WHERE datname NOT IN ('postgres','rdsadmin','DBA') AND NOT datistemplate;")

  for DB in $USER_DBS; do
    echo "🔁 Running on $DB..." | tee -a "$LOG_FILE"

    for FOLDER in "${USER_DB_FOLDERS[@]}"; do
      find "$FOLDER" -type f -name '*.sql' | sort | while read -r SCRIPT; do
        echo "📄 [$DB] $SCRIPT" >> "$LOG_FILE"
        echo "🔗 Running: psql -U \"$PGUSER\" -h \"$HOST\" -p \"$PGPORT\" -d \"$DB\" -f \"$SCRIPT\"" >> "$LOG_FILE"
        psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d "$DB" -f "$SCRIPT" >> "$LOG_FILE" 2>&1
        if [[ $? -ne 0 ]]; then
          echo "❌ ERROR running $SCRIPT against $DB" | tee -a "$LOG_FILE"
          echo "--- FAILED COMMAND ---" >> "$LOG_FILE"
          echo "psql -U \"$PGUSER\" -h \"$HOST\" -p \"$PGPORT\" -d \"$DB\" -f \"$SCRIPT\"" >> "$LOG_FILE"
          echo "--- BEGIN FAILED SCRIPT: $SCRIPT ---" >> "$LOG_FILE"
          cat "$SCRIPT" >> "$LOG_FILE"
          echo "--- END FAILED SCRIPT ---" >> "$LOG_FILE"
        fi
      done
    done

  done

done < "$INPUT_FILE"

# === WRAP UP ===
echo "✅ All deployments complete. Log: $LOG_FILE"
cd "$LOG_DIR" && ls -1t initial_setup_*.log | tail -n +11 | xargs -r rm -f
