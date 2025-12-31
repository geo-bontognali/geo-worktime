#!/bin/bash

# Activity monitor script for Hyprland
# Logs active window and idle status to CSV

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
INTERVAL=90  # seconds between logging

# Create logs directory if it doesn't exist
mkdir -p "$LOG_DIR"

echo "Starting activity monitor (logging every ${INTERVAL} seconds)..."
echo "Log directory: $LOG_DIR"
echo "Press Ctrl+C to stop"

while true; do
    # Get timestamp and current date for filename
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    CURRENT_DATE=$(date +"%Y-%m-%d")
    LOG_FILE="$LOG_DIR/activity_log_$CURRENT_DATE.csv"
    
    # Create CSV header if file doesn't exist
    if [ ! -f "$LOG_FILE" ]; then
        echo "timestamp,window_title,window_class,is_idle" > "$LOG_FILE"
        echo "Created new log file: $LOG_FILE"
    fi
    
    # Get active window info
    WINDOW_JSON=$(hyprctl activewindow -j 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$WINDOW_JSON" ]; then
        # Extract title and class from JSON using grep and sed
        WINDOW_TITLE=$(echo "$WINDOW_JSON" | grep -oP '"title":\s*"\K[^"]*' | head -1 | sed 's/,/;/g')
        WINDOW_CLASS=$(echo "$WINDOW_JSON" | grep -oP '"class":\s*"\K[^"]*' | head -1 | sed 's/,/;/g')
        
        # Set to N/A if empty
        [ -z "$WINDOW_TITLE" ] && WINDOW_TITLE="N/A"
        [ -z "$WINDOW_CLASS" ] && WINDOW_CLASS="N/A"
    else
        WINDOW_TITLE="N/A"
        WINDOW_CLASS="N/A"
    fi
    
    # Check if system is idle using hypridle status file
    if [ -f /tmp/.gtime_ipc ]; then
        IDLE_STATUS=$(cat /tmp/.gtime_ipc 2>/dev/null | tr -d '\n')
        if [ "$IDLE_STATUS" = "1" ]; then
            IS_IDLE="true"
        else
            IS_IDLE="false"
        fi
    else
        IS_IDLE="unknown"
    fi
    
    # Log to CSV
    echo "\"$TIMESTAMP\",\"$WINDOW_TITLE\",\"$WINDOW_CLASS\",\"$IS_IDLE\"" >> "$LOG_FILE"
    
    # Optional: print to console
    echo "[$TIMESTAMP] $WINDOW_CLASS - $WINDOW_TITLE (idle: $IS_IDLE)"
    
    # Wait for next interval
    sleep $INTERVAL
done
