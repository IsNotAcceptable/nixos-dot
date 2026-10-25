#!/usr/bin/env bash
sid=$1; shift
dir="${XDG_RUNTIME_DIR:-/tmp}/nix-sessions/sessions/$sid"
if [ -d "$dir" ]; then
  while IFS= read -r -d '' kv; do export "$kv" 2>/dev/null; done < "$dir/env"
  cd "$(cat "$dir/cwd")" 2>/dev/null
fi
exec "$@"
