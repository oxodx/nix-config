# Hyprland integration

The bindings in `home/packages/wayland/hyprland/binds.nix` follow [illogical-impulse's current upstream defaults](https://github.com/end-4/dots-hyprland/blob/main/dots/.config/hypr/hyprland/keybinds.lua), compared on 2026-11-06. They are translated into this machine's Nix-owned `.conf` configuration and target the active Quickshell family. Upstream Lua itself is not installed.

Upstream defaults win collisions with the earlier SekaiPop layout:

| Keys | Action |
| --- | --- |
| Tap Super | Launcher; holding Super exposes workspace numbers |
| Super+A / B / O | Assistant sidebar |
| Super+D / F | Maximize / fullscreen |
| Super+Shift+arrows | Move window |
| Ctrl+Super+Left/Right | Switch workspace |
| Ctrl+Alt+Super+Left/Right | Switch occupied workspace |
| Ctrl+Super+Up/Down | Jump five workspaces |
| Super+Minus/Equal | Cursor zoom |
| Super+Shift+L | Suspend |
| Super+W / C / X | Browser / code editor / text editor |
| Ctrl+Super+P | Cycle shell family |

The complete set includes physical number keys, keypad workspace navigation and zoom, silent sends, relative workspace movement with wheel/PageUp/PageDown, scratchpad, media mouse buttons, local selected-text AI queries, screenshot-to-file/clipboard, region captures, recording, notification previews, and the VM passthrough submap. `Super+Alt+F1` enters/exits that submap. `Super+/` displays the live described bindings.

Machine-specific adaptations: app launchers use Firefox, VS Code, Kate, Dolphin, Alacritty, LibreOffice and pavucontrol; settings open the shell settings window. All families use this machine's existing `magic` scratchpad. Number shortcuts address its ten configured workspaces. Selection summaries use local Ollama, matching upstream's dependency; a notification explains if it is unavailable. Notification tests use the configured wallpaper/profile image. Screenshot helpers avoid shell interpolation. Existing Encore additions remain: `Super+Shift+E` edits desktop cards, `Ctrl+Shift+Super+T` opens customization, `Super+Alt+D` opens the launcher, `Ctrl+Super+W` groups, and `Super+Alt+C` centers. Original ii appearance is unchanged.

The Super-release interruption bindings are generated from all Super action chords, so another shortcut does not accidentally open the launcher on release. Shell recovery aliases remain available with `Super+Shift+D` (fuzzel) and `Ctrl+Super+R` (reload).

Editing Nix sources does not install keybindings in a running compositor. Rebuild/switch this machine's Nix configuration, then reload Hyprland to install the generated bindings and any newly referenced applications. No system rebuild is run automatically here.

Validation: evaluated the real Nix package paths, passed Hyprland 0.55.4 `--verify-config`, and audited all literal upstream chords plus the generated workspace/directional loops with `tests/check_keybinds.py /tmp/encore-binds.conf /tmp/ii-keybinds.lua`. That audit also checks conflicting actions and the important dispatch targets. Lock visuals and input synchronization were tested in ordinary isolated Wayland windows without locking or authenticating. Desktop motion preserves saved positions and pauses while editing/locked. Hardware brightness commands were mocked for previews.

The compositor-setting adapter persists `hyprctl keyword` arguments under `hyprlandOverrides` and reapplies them after reload. OCR, typing, keyboard injection, network/Bluetooth tools and ydotoold retain their existing Nix configuration. Brightness startup remains read-only; the hardware regression is `tests/check_brightness.py`.
