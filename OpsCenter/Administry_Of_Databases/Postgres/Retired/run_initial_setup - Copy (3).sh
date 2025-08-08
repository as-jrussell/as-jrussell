#!/bin/bash
# ==========================================
# Script: run_initial_setup_folder_final.sh
# Purpose: Loop through each host and apply all SQL scripts in a folder (including subfolders)
# Includes log rotation and safe symlink creation
# ==========================================

read -p "Enter PostgreSQL user: " PGUSER
read -s -p "Enter PostgreSQL password: " PGPASSWORD
echo
export PGPASSWORD

# --- CONFIGURATION ---
PGPORT="5432"
PGDB="postgres"
SCRIPT_FOLDER="/c/Github/as-jrussell/Opscenter/Administry_Of_Databases/postgres/Postgres_Deploy/chmod/Deploy/"
INPUT_FILE="initial_setup.txt"
LOG_DIR="logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M")

# Ensure log directory exists
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/initial_setup_$TIMESTAMP.log"
LATEST_LOG_LINK="initial_setup.log"

# === DEBUG: Check variables ===
echo "DEBUG: LOG_FILE = $LOG_FILE"
echo "DEBUG: LATEST_LOG_LINK = $LATEST_LOG_LINK"

# Safe symlink: always point to most recent log in script's directory
ABS_LOG_FILE=$(realpath "$LOG_FILE")
ABS_LINK_TARGET=$(realpath "$(dirname "$0")")/$LATEST_LOG_LINK
ln -sf "$ABS_LOG_FILE" "$ABS_LINK_TARGET"

# Start new log
echo "🔧 Initial Setup Log - $TIMESTAMP" > "$LOG_FILE"

# Read each workstation from file
while read -r HOST; do
  [[ -z "$HOST" ]] && continue

  echo "🚀 Running setup on $HOST..."
  echo "=== $HOST ===" >> "$LOG_FILE"

  # Generate temporary SQL script
  TEMP_SQL=$(mktemp)
  echo "\set workstation_name '$HOST'" > "$TEMP_SQL"
  echo "\set dbname 'DBA'" >> "$TEMP_SQL"

  # Recursively include all .sql scripts from folder and subfolders
  find "$SCRIPT_FOLDER" -type f -name '*.sql' | sort | while read -r SCRIPT; do
    echo "📄 Including $SCRIPT" >> "$LOG_FILE"
    echo "\echo Running $SCRIPT" >> "$TEMP_SQL"
    cat "$SCRIPT" >> "$TEMP_SQL"
    echo "
" >> "$TEMP_SQL"
  done

  # Execute SQL script
  PGPASSWORD="$PGPASSWORD" psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d "$PGDB" -f "$TEMP_SQL" >> "$LOG_FILE" 2>&1
  STATUS=$?

  if [ $STATUS -ne 0 ]; then
    echo "❌ ERROR on $HOST" | tee -a "$LOG_FILE"
  else
    echo "✅ SUCCESS on $HOST" | tee -a "$LOG_FILE"
  fi

  rm -f "$TEMP_SQL"
done < "$INPUT_FILE"

echo "🎯 All setups complete. See $LOG_FILE for details."

# 🔄 Purge old logs (keep only 10 most recent)
cd "$LOG_DIR" && ls -1t initial_setup_*.log | tail -n +11 | xargs -r rm -f
