# wrapper around claude adding vim.opt.keymap-style keyboard layout switching
claude() {
    local layout_state="/run/user/$(id -u)/claude-layout/$ALACRITTY_WINDOW_ID"

    if [ -n "$ALACRITTY_WINDOW_ID" ] && command -v alacritty >/dev/null 2>&1; then
        local esc entries spec key mods char mods_part base_bindings
        local toggle_prog="$HOME/.local/bin/claude-layout-toggle"
        local restore_prog="$HOME/.local/bin/claude-layout-restore"
        local alacritty_conf="$HOME/.config/alacritty/alacritty.toml"
        esc=$(printf '\134u001b')

        # alacritty msg config replaces keyboard.bindings wholesale, so pull the
        # static bindings from the config file and prepend them to keep them alive
        base_bindings=$(awk '/^bindings *= *\[/{f=1; next} f && /^\]/{f=0; next} f' "$alacritty_conf" 2>/dev/null)

        entries="$base_bindings"
        entries+='{ key = "Escape", command = { program = "swaymsg", args = ["input", "type:keyboard", "xkb_switch_layout", "0"] } },'
        entries+='{ key = "Escape", chars = "'"$esc"'" },'
        entries+='{ key = "6", mods = "Control", command = { program = "'"$toggle_prog"'", args = ["'"$ALACRITTY_WINDOW_ID"'"] } },'

        # vim insert-mode entry keys: restore the remembered layout, then still type the char
        for spec in "I::i" "I:Shift:I" "A::a" "A:Shift:A" "O::o" "O:Shift:O" "S::s" "C::c"; do
            IFS=':' read -r key mods char <<< "$spec"
            mods_part=""
            [ -n "$mods" ] && mods_part=", mods = \"$mods\""
            entries+="{ key = \"$key\"$mods_part, command = { program = \"$restore_prog\", args = [\"$ALACRITTY_WINDOW_ID\", \"$key\"] } },"
            entries+="{ key = \"$key\"$mods_part, chars = \"$char\" },"
        done

        alacritty msg config "keyboard.bindings=[${entries%,}]" >/dev/null 2>&1
    fi

    if command -v swaymsg >/dev/null 2>&1 && [ -f "$layout_state" ]; then
        local idx
        idx=$(cat "$layout_state")
        [ -n "$idx" ] && swaymsg input type:keyboard xkb_switch_layout "$idx" >/dev/null 2>&1
    fi

    command claude "$@"
}
