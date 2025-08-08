#!/bin/bash
# ==========================================
# Script: run_initial_setup_folder_split.sh
# Purpose: Run SQL scripts on DBA and user DBs from structured folder sets
# ==========================================

read -p "Enter PostgreSQL user: " PGUSER
read -s -p "Enter PostgreSQL password: " PGPASSWORD
echo
export PGPASSWORD

# --- FLAGS ---
VERBOSE=false
if [[ "$1" == "--verbose" ]]; then
  VERBOSE=true
fi

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

# --- LOG FUNCTION ---
log() {
  echo "$1" >> "$LOG_FILE"
  if [ "$VERBOSE" = true ]; then
    echo "$1"
  fi
}

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
  log "🚀 Running on $HOST..."
  log "=== $HOST ==="

  # --- 1. Run Against DBA if Present ---
  DBA_EXISTS=$(psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d postgres -Atc "SELECT 1 FROM pg_database WHERE datname = 'DBA';")
  if [[ "$DBA_EXISTS" == "1" ]]; then
    log "✅ DBA found. Executing against DBA..."
    if [ "$VERBOSE" = false ]; then echo "▶ Working on DBA..."; fi

    for FOLDER in "${DBA_FOLDERS[@]}"; do
      find "$FOLDER" -type f -name '*.sql' | sort | while read -r SCRIPT; do
        log "📄 [DBA] $SCRIPT"
        log "🔗 Running: psql -U \"$PGUSER\" -h \"$HOST\" -p \"$PGPORT\" -d DBA -f \"$SCRIPT\""

        if [ "$VERBOSE" = true ]; then
          psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d DBA -f "$SCRIPT" 2>&1 | tee -a "$LOG_FILE"
        else
          psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d DBA -f "$SCRIPT" >> "$LOG_FILE" 2>&1
        fi

        if [[ $? -ne 0 ]]; then
          log "❌ ERROR running $SCRIPT against DBA"
          log "--- FAILED COMMAND ---"
          log "psql -U \"$PGUSER\" -h \"$HOST\" -p \"$PGPORT\" -d DBA -f \"$SCRIPT\""
          log "--- BEGIN FAILED SCRIPT: $SCRIPT ---"
          cat "$SCRIPT" >> "$LOG_FILE"
          log "--- END FAILED SCRIPT ---"
        fi
      done
    done

  else
    log "⚠️ DBA not found on $HOST. Skipping DBA deployment."
  fi

  # --- 2. Run Against All Non-System DBs ---
  USER_DBS=$(psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d postgres -Atc \
    "SELECT datname FROM pg_database WHERE datname NOT IN ('postgres','rdsadmin','DBA', 'model') AND NOT datistemplate;")

  for DB in $USER_DBS; do
    if [ "$VERBOSE" = false ]; then echo "▶ Working on database: $DB"; fi
    log "🔁 Running on $DB..."

    for FOLDER in "${USER_DB_FOLDERS[@]}"; do
      find "$FOLDER" -type f -name '*.sql' | sort | while read -r SCRIPT; do
        log "📄 [$DB] $SCRIPT"
        log "🔗 Running: psql -U \"$PGUSER\" -h \"$HOST\" -p \"$PGPORT\" -d \"$DB\" -f \"$SCRIPT\""

        if [ "$VERBOSE" = true ]; then
          psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d "$DB" -f "$SCRIPT" 2>&1 | tee -a "$LOG_FILE"
        else
          psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d "$DB" -f "$SCRIPT" >> "$LOG_FILE" 2>&1
        fi

        if [[ $? -ne 0 ]]; then
          log "❌ ERROR running $SCRIPT against $DB"
          log "--- FAILED COMMAND ---"
          log "psql -U \"$PGUSER\" -h \"$HOST\" -p \"$PGPORT\" -d \"$DB\" -f \"$SCRIPT\""
          log "--- BEGIN FAILED SCRIPT: $SCRIPT ---"
          cat "$SCRIPT" >> "$LOG_FILE"
          log "--- END FAILED SCRIPT ---"
        fi
      done
    done
  done

done < "$INPUT_FILE"

# === WRAP UP ===
log "✅ All deployments complete. Log: $LOG_FILE"
cd "$LOG_DIR" && ls -1t initial_setup_*.log | tail -n +11 | xargs -r rm -f
