if [[ -n $IN_NIX_SHELL ]]; then
  emulate sh -c '. /etc/nix-session-hook.sh'

  # чистим только если эту сессию зарегистрировали мы, а не родительский bash
  zshexit() {
    [[ $NIX_SESSION_ID == $$ ]] || return
    local root=${XDG_RUNTIME_DIR:-/tmp}/nix-sessions
    rm -rf $root/sessions/$$ $root/share/applications/ns-$$-*.desktop(N)
  }
fi
