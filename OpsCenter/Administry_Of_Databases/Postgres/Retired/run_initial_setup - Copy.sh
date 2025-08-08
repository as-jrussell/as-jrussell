#!/bin/bash
# ==========================================
# Script: run_initial_setup.sh
# Purpose: Loop through each host in initial_setup.txt and apply setup.sql
# Injects dynamic \set variables per host (e.g., workstation_name)
# ==========================================


read -p "Enter PostgreSQL user: " PGUSER
read -s -p "Enter PostgreSQL password: " PGPASSWORD
echo
export PGPASSWORD




# --- CONFIGURATION ---
PGPORT="5432"
PGDB="postgres"
SCRIPT_TO_RUN="000_initial_setup_no_permissions.sql"
INPUT_FILE="initial_setup.txt"
LOG_FILE="initial_setup.log"

# Clear previous log
echo "🔧 Initial Setup Log - $(date)" > "$LOG_FILE"

# Read each workstation from file
while read -r HOST; do
  if [[ -z "$HOST" ]]; then continue; fi

  echo "🚀 Running setup on $HOST..."
  echo "=== $HOST ===" >> "$LOG_FILE"

  # Generate temporary SQL script with \set variable
  TEMP_SQL=$(mktemp)
echo "\\set workstation_name '$HOST'" > "$TEMP_SQL"
echo "\\set dbname 'DBA'" >> "$TEMP_SQL"  # or whatever the real DB name i
  cat "$SCRIPT_TO_RUN" >> "$TEMP_SQL"

  # Execute setup
  PGPASSWORD="$PGPASSWORD" psql -U "$PGUSER" -h "$HOST" -p "$PGPORT" -d "$PGDB" -f "$TEMP_SQL" >> "$LOG_FILE" 2>&1
  STATUS=$?

  if [ $STATUS -ne 0 ]; then
    echo "❌ ERROR on $HOST" | tee -a "$LOG_FILE"
  else
    echo "✅ SUCCESS on $HOST" | tee -a "$LOG_FILE"
  fi

  # Clean up temp file
  rm -f "$TEMP_SQL"
done < "$INPUT_FILE"

echo "🎯 All setups complete. See $LOG_FILE for details."
