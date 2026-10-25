#!/usr/bin/env bash
root="${XDG_RUNTIME_DIR:-/tmp}/nix-sessions"
for d in "$root"/sessions/*/; do
  [ -d "$d" ] || continue
  id=$(basename "$d")
  kill -0 "$id" 2>/dev/null || rm -rf "$d" "$root"/share/applications/ns-"$id"-*.desktop
done
export XDG_DATA_DIRS="$root/share:${XDG_DATA_DIRS:-/run/current-system/sw/share}"
exec wofi --show drun "$@"
