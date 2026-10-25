__ns_register() {
  local root="${XDG_RUNTIME_DIR:-/tmp}/nix-sessions"
  local apps="$root/share/applications"
  local sdir="$root/sessions/$$"
  local label="${NIX_SESSION_LABEL:-nix:$(basename "$PWD")}"
  label=${label//[^A-Za-z0-9._:-]/_}
  local p src icon f

  mkdir -p "$apps" "$sdir" || return
  export NIX_SESSION_ID=$$
  pwd > "$sdir/cwd"
  env -0 | grep -zvE '^(PWD|OLDPWD|SHLVL|_|WAYLAND_DISPLAY|DISPLAY|XDG_RUNTIME_DIR|DBUS_SESSION_BUS_ADDRESS|XDG_SESSION_[A-Z]+|XAUTHORITY|SSH_AUTH_SOCK|XDG_CURRENT_DESKTOP|XDG_VTNR|XDG_SEAT)=' > "$sdir/env"

  local cands
  cands=$(
    {
      for p in $buildInputs $nativeBuildInputs $propagatedBuildInputs $propagatedNativeBuildInputs; do
        echo "$p"
        nix-store -q --references "$p" 2>/dev/null
      done
      echo "$PATH" | tr ':' '\n' | sed -n 's|^\(/nix/store/[^/]*\)/bin$|\1|p'
    } | sort -u
  )
  for p in $cands; do
    for src in "$p"/share/applications/*.desktop; do
      [ -f "$src" ] || continue
      icon=$(sed -n 's/^Icon=//p' "$src" | head -1)
      f=""
      if [ -n "$icon" ] && [ "${icon#/}" = "$icon" ]; then
        f=$(find -L "$p/share/icons" "$p/share/pixmaps" \( -name "$icon.png" -o -name "$icon.svg" \) 2>/dev/null | head -1)
      fi
      sed -E \
        -e '/^(TryExec|DBusActivatable)=/d' \
        -e "s|^Name=(.*)|Name=\1  [$label]|" \
        -e "s|^Exec=|Exec=nix-session-run $$ |" \
        ${f:+-e "s|^Icon=.*|Icon=$f|"} \
        "$src" > "$apps/ns-$$-$(basename "$src")"
    done
  done

  # Терминал внутри сессии (для CLI-инструментов)
  cat > "$apps/ns-$$-shell.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Shell  [$label]
Exec=nix-session-run $$ bash
Terminal=true
Icon=utilities-terminal
EOF

}

__ns_prompt_hook() {
  PROMPT_COMMAND=${PROMPT_COMMAND/__ns_prompt_hook/:}
  if [ -n "${IN_NIX_SHELL:-}" ] && { [ -z "${NIX_SESSION_ID:-}" ] || ! kill -0 "$NIX_SESSION_ID" 2>/dev/null; }; then
    __ns_register
  fi
}

PROMPT_COMMAND="__ns_prompt_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
