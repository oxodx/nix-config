# Hyprland integration

Compared against Illogical Impulse's current `dots/.config/hypr/hyprland/keybinds.lua` on 2026-11-06, with SekaiPop's launcher/control conventions retained. These are adapted to the Nix-owned `.conf` setup; upstream's Lua config, host-specific monitors and debug/prank bindings are not installed.

Added the assistant sidebar and detach action, media controls, widget overlay, real Encore workspace overview, rail toggle, screen translation, color picker, keyboard media aliases, floating/pinning/fullscreen-spoof controls, split ratio controls, silent workspace moves and keypad navigation, scratchpad aliases, app launchers, fullscreen recording, screenshot-to-file, zoom controls and a VM passthrough submap. Existing monitor moves now use directions instead of hardcoded display names. Descriptions populate the shell cheatsheet.

`Super+Alt+F1` enters the VM submap; the same chord exits. `Super+Alt+Backspace` resets zoom. `Super+A` / `Super+D` are the launchers; bare Super is not rebound, preserving the existing modifier behavior. `Super+B` opens the assistant, `Super+M` media controls, `Super+G` the widget overlay, `Super+J` the rails, `Super+Shift+T` translation. Use `Super+/` for the other combinations.

Quickshell's compositor-setting adapter now applies `hyprctl keyword` arguments directly and persists them under `hyprlandOverrides` in its JSON configuration. They are reapplied after a Hyprland reload. This replaces the previously unused, virtualenv-dependent Lua override path and does not rewrite Nix-managed files.

Nix supplies OCR, typing, keyboard injection, mixer, network and Bluetooth settings tools. The `ydotoold` service and the user's group membership are configured; a new login after the system switch is needed for group membership. No NixOS rebuild is performed by editing these files.

Brightness initialization is read-only. Startup animations cannot send a zero level to the device, and output rounding no longer loses a percent on repeated reloads. Tested with fake brightness/DDC commands; the actual backlight was restored from 17% to the earlier 61% reading. The desktop purple overlay was also reduced to preserve wallpaper brightness.

Validated with Hyprland 0.55.4 `--verify-config`, NixOS service evaluation, global-target and duplicate-chord checks, and an isolated Wayland runtime run. Brightness writes were mocked during runtime tests.

References: https://github.com/end-4/dots-hyprland/blob/main/dots/.config/hypr/hyprland/keybinds.lua and https://github.com/Blapples/SekaiPop#keybinds.

Follow-up: Encore now has a real overview, `Super+Shift+E` desktop editing, `Ctrl+Shift+Super+T` customization, and actual frame work-area reservations. The final binding check covers 199 non-conflicting chords and verifies every global target in all three families. The old generic `Super+Tab` “or launcher” description is superseded by the real overview.
