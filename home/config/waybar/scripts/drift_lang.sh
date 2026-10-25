#!/usr/bin/env bash
STATE_FILE="$XDG_RUNTIME_DIR/driftwm/state"

if [ -f "$STATE_FILE" ]; then
    LANG_RAW=$(awk -F'=' '$1=="layout" {print tolower(substr($2,1,2))}' "$STATE_FILE")
    echo "${LANG_RAW^^}"
fi

