#!/usr/bin/env bash

STATE_FILE="$XDG_RUNTIME_DIR/driftwm/state"
MONITOR="${WAYBAR_OUTPUT_NAME:-$WAYBAR_OUTPUT}"

while true; do
    if [ -f "$STATE_FILE" ]; then
        if [ -n "$MONITOR" ]; then
            X=$(awk -F'=' -v mon="$MONITOR" '$1 == "outputs."mon".camera_x" {printf "%.0f", $2}' "$STATE_FILE")
            Y=$(awk -F'=' -v mon="$MONITOR" '$1 == "outputs."mon".camera_y" {printf "%.0f", $2}' "$STATE_FILE")
        fi

        if [ -z "$X" ] || [ -z "$Y" ]; then
            X=$(awk -F'=' '$1=="x" {printf "%.0f", $2}' "$STATE_FILE")
            Y=$(awk -F'=' '$1=="y" {printf "%.0f", $2}' "$STATE_FILE")
        fi

        # Печатаем координаты
        printf "%s, %s\n" "$X" "$Y"
    fi
    
    # 0.05 сек = 20 обновлений в секунду.
    sleep 0.05
done

