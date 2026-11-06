{pkgs, ...}: let
  bindings = ''
    # Illogical Impulse shortcuts, adapted from end-4/dots-hyprland.
    # Native globals target the active shell family; Encore extras live below.
    # Descriptions are consumed by the shell's Super+/ cheatsheet.
    bindld = , XF86AudioPlay, Media: Play or pause, exec, playerctl play-pause
    bindld = , XF86AudioStop, Media: Stop, exec, playerctl stop
    bindld = , XF86AudioNext, Media: Next track, exec, playerctl next
    bindld = , XF86AudioPrev, Media: Previous track, exec, playerctl previous
    bindld = , XF86AudioMute, Audio: Mute output, exec, qs ipc call shell mute
    bindld = , XF86AudioMicMute, Audio: Mute microphone, exec, qs ipc call shell micMute
    bindeld = , XF86AudioRaiseVolume, Audio: Raise volume, exec, qs ipc call shell volumeUp
    bindeld = , XF86AudioLowerVolume, Audio: Lower volume, exec, qs ipc call shell volumeDown
    bindeld = , XF86MonBrightnessUp, Display: Raise brightness, exec, qs ipc call brightness increment || brightnessctl s 5%+
    bindeld = , XF86MonBrightnessDown, Display: Lower brightness, exec, qs ipc call brightness decrement || brightnessctl s 5%-

    bindd = $mod, A, Shell: Assistant sidebar, global, quickshell:sidebarLeftToggle
    bindd = $mod, D, Windows: Maximize, fullscreen, 1
    bindd = $mod, N, Shell: Quick controls, global, quickshell:shellControls
    bindd = $mod, Tab, Shell: Workspace overview, global, quickshell:shellOverview
    bindd = $mod, I, Shell: Settings, global, quickshell:shellSettings
    bindd = $mod, slash, Shell: Cheatsheet, global, quickshell:cheatsheetToggle
    bindd = $mod, K, Shell: On-screen keyboard, global, quickshell:oskToggle
    bindd = $mod, V, Shell: Clipboard history, global, quickshell:overviewClipboardToggle
    bindd = $mod, period, Shell: Emoji picker, global, quickshell:overviewEmojiToggle
    bindd = $mod, L, Session: Lock, global, quickshell:lock
    bindd = CTRL ALT, L, Session: Lock, global, quickshell:lock
    bindd = $mod, Escape, Session: Power menu, global, quickshell:sessionToggle
    bindd = $mod CTRL, T, Wallpaper: Choose wallpaper, global, quickshell:wallpaperSelectorToggle
    bindd = $mod CTRL ALT, T, Wallpaper: Random wallpaper, global, quickshell:wallpaperSelectorRandom
    bindd = $mod SHIFT, W, Wallpaper: Choose wallpaper, global, quickshell:wallpaperSelectorToggle
    bindd = $mod CTRL SHIFT, D, Shell: Toggle light or dark, global, quickshell:shellTheme
    bindd = $mod CTRL, R, Shell: Reload, global, quickshell:shellReload
    bindd = $mod CTRL SHIFT, P, Shell: Cycle family, global, quickshell:panelFamilyCycle
    bindd = $mod SHIFT, D, Apps: Fallback launcher, exec, ${pkgs.fuzzel}/bin/fuzzel
    bindd = $mod, Return, Apps: Terminal, exec, ${pkgs.alacritty}/bin/alacritty
    bindd = $mod, X, Apps: Text editor, exec, ${pkgs.kdePackages.kate}/bin/kate

    bindd = $mod, left, Windows: Focus l, movefocus, l
    bindd = $mod, down, Windows: Focus d, movefocus, d
    bindd = $mod, up, Windows: Focus u, movefocus, u
    bindd = $mod, right, Windows: Focus r, movefocus, r
    bindd = $mod ALT, H, Windows: Focus l, movefocus, l
    bindd = $mod ALT, J, Windows: Focus d, movefocus, d
    bindd = $mod ALT, K, Windows: Focus u, movefocus, u
    bindd = $mod ALT, L, Windows: Focus r, movefocus, r

    bindd = $mod CTRL, left, Workspaces: Switch r-1, workspace, r-1
    bindd = $mod CTRL, down, Workspaces: Switch r+5, workspace, r+5
    bindd = $mod CTRL, up, Workspaces: Switch r-5, workspace, r-5
    bindd = $mod CTRL, right, Workspaces: Switch r+1, workspace, r+1
    bindd = $mod CTRL, H, Windows: Move l, movewindow, l
    bindd = $mod CTRL, J, Windows: Move d, movewindow, d
    bindd = $mod CTRL, K, Windows: Move u, movewindow, u
    bindd = $mod CTRL, L, Windows: Move r, movewindow, r

    bindd = $mod SHIFT, left, Windows: Move l, movewindow, l
    bindd = $mod SHIFT, down, Windows: Move d, movewindow, d
    bindd = $mod SHIFT, up, Windows: Move u, movewindow, u
    bindd = $mod SHIFT, right, Windows: Move r, movewindow, r
    bindd = $mod SHIFT, H, Windows: Focus monitor l, focusmonitor, l
    bindd = $mod SHIFT, J, Windows: Focus monitor d, focusmonitor, d
    bindd = $mod SHIFT, K, Windows: Focus monitor u, focusmonitor, u
    bindld = $mod SHIFT, L, Session: Sleep, exec, systemctl suspend || loginctl suspend

    bindd = $mod SHIFT CTRL, left, Windows: Move to workspace r-1, movetoworkspace, r-1
    bindd = $mod SHIFT CTRL, H, Windows: Move mon:l, movewindow, mon:l
    bindd = $mod SHIFT CTRL, right, Windows: Move to workspace r+1, movetoworkspace, r+1
    bindd = $mod SHIFT CTRL, L, Windows: Move mon:r, movewindow, mon:r

    bindd = $mod, Prior, Workspaces: Switch e-1, workspace, e-1
    bindd = $mod, Next, Workspaces: Switch e+1, workspace, e+1
    bindd = $mod, U, Workspaces: Switch e+1, workspace, e+1
    bindd = $mod CTRL, Prior, Workspaces: Switch r-1, workspace, r-1
    bindd = $mod CTRL, Next, Workspaces: Switch r+1, workspace, r+1
    bindd = $mod CTRL, I, Windows: Move to workspace e-1, movetoworkspace, e-1
    bindd = $mod CTRL, U, Windows: Move to workspace e+1, movetoworkspace, e+1
    bindd = $mod SHIFT, Prior, Windows: Move to workspace e-1, movetoworkspace, e-1
    bindd = $mod SHIFT, Next, Windows: Move to workspace e+1, movetoworkspace, e+1
    bindd = $mod SHIFT, I, Windows: Move to workspace e-1, movetoworkspace, e-1
    bindd = $mod SHIFT, U, Windows: Move to workspace e+1, movetoworkspace, e+1

    bindd = $mod, mouse_down, Workspaces: Switch e+1, workspace, e+1
    bindd = $mod, mouse_up, Workspaces: Switch e-1, workspace, e-1
    bindd = $mod CTRL, mouse_down, Workspaces: Switch r+1, workspace, r+1
    bindd = $mod CTRL, mouse_up, Workspaces: Switch r-1, workspace, r-1
    bindd = $mod, mouse_left, Windows: Focus l, movefocus, l
    bindd = $mod, mouse_right, Windows: Focus r, movefocus, r
    bindd = $mod CTRL, mouse_left, Windows: Move l, movewindow, l
    bindd = $mod CTRL, mouse_right, Windows: Move r, movewindow, r
    bindd = $mod SHIFT, mouse_down, Windows: Move to workspace r+1, movetoworkspace, r+1
    bindd = $mod SHIFT, mouse_up, Windows: Move to workspace r-1, movetoworkspace, r-1
    bindd = $mod SHIFT CTRL, mouse_down, Windows: Move r, movewindow, r
    bindd = $mod SHIFT CTRL, mouse_up, Windows: Move l, movewindow, l

    bindd = $mod, 1, Workspaces: Switch 1, workspace, 1
    bindd = $mod, 2, Workspaces: Switch 2, workspace, 2
    bindd = $mod, 3, Workspaces: Switch 3, workspace, 3
    bindd = $mod, 4, Workspaces: Switch 4, workspace, 4
    bindd = $mod, 5, Workspaces: Switch 5, workspace, 5
    bindd = $mod, 6, Workspaces: Switch 6, workspace, 6
    bindd = $mod, 7, Workspaces: Switch 7, workspace, 7
    bindd = $mod, 8, Workspaces: Switch 8, workspace, 8
    bindd = $mod, 9, Workspaces: Switch 9, workspace, 9
    bindd = $mod, 0, Workspaces: Switch 10, workspace, 10

    bindd = $mod CTRL, 1, Windows: Move to workspace 1, movetoworkspace, 1
    bindd = $mod CTRL, 2, Windows: Move to workspace 2, movetoworkspace, 2
    bindd = $mod CTRL, 3, Windows: Move to workspace 3, movetoworkspace, 3
    bindd = $mod CTRL, 4, Windows: Move to workspace 4, movetoworkspace, 4
    bindd = $mod CTRL, 5, Windows: Move to workspace 5, movetoworkspace, 5
    bindd = $mod CTRL, 6, Windows: Move to workspace 6, movetoworkspace, 6
    bindd = $mod CTRL, 7, Windows: Move to workspace 7, movetoworkspace, 7
    bindd = $mod CTRL, 8, Windows: Move to workspace 8, movetoworkspace, 8
    bindd = $mod CTRL, 9, Windows: Move to workspace 9, movetoworkspace, 9
    bindd = $mod CTRL, 0, Windows: Move to workspace 10, movetoworkspace, 10

    bindd = $mod, bracketleft, Windows: Leave group, moveoutofgroup,
    bindd = $mod, bracketright, Windows: Enter group, moveintogroup,
    bindd = $mod, comma, Windows: Enter group, moveintogroup,
    bindd = $mod, R, Windows: Layout togglesplit, layoutmsg, togglesplit
    bindd = $mod CTRL SHIFT, R, Windows: Swap split, layoutmsg, swapsplit
    bindd = $mod, F, Windows: Fullscreen, fullscreen, 0
    bindd = $mod SHIFT, F, Windows: Fullscreen 0, fullscreen, 0
    bindd = $mod SHIFT, V, Windows: Toggle floating, togglefloating,
    bindd = $mod, W, Windows: Toggle group, togglegroup,
    bindd = $mod, minus, Display: Zoom out, exec, python3 ~/.config/quickshell/scripts/desktop/action.py zoom-out
    bindd = $mod, equal, Display: Zoom in, exec, python3 ~/.config/quickshell/scripts/desktop/action.py zoom-in
    bindd = $mod SHIFT, minus, Windows: Resize 0 -40, resizeactive, 0 -40
    bindd = $mod SHIFT, equal, Windows: Resize 0 40, resizeactive, 0 40
    bindd = $mod, C, Windows: Center, centerwindow,
    bindd = $mod, Q, Windows: Close, killactive,
    bindd = $mod, O, Shell: Assistant sidebar, global, quickshell:sidebarLeftToggle
    bindd = $mod SHIFT, O, Windows: Move to workspace special:magic, movetoworkspace, special:magic

    bindld = , Print, Capture: Focused screen to clipboard, exec, python3 ~/.config/quickshell/scripts/desktop/action.py screenshot-clipboard
    bindd = $mod SHIFT, S, Capture: Screen snip, global, quickshell:regionScreenshot
    bindd = $mod SHIFT, X, Capture: OCR to clipboard, global, quickshell:regionOcr
    bindd = $mod SHIFT, A, Capture: Search image with Lens, global, quickshell:regionSearch
    bindld = $mod SHIFT, R, Capture: Record region, global, quickshell:regionRecord
    bindd = $mod CTRL SHIFT, S, Capture: Record region with sound, global, quickshell:regionRecordWithSound

    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow

    bindd = $mod SHIFT, E, Shell: Edit desktop cards, global, quickshell:shellEditDesktop
    bindd = $mod CTRL SHIFT, T, Shell: Customize cards and theme, global, quickshell:shellCustomize

    # Illogical Impulse integrations, adapted to this machine and Encore.
    bindd = $mod, B, Shell: Assistant sidebar, global, quickshell:sidebarLeftToggle
    bindd = $mod ALT, A, Shell: Detach assistant, global, quickshell:shellDetachSidebar
    bindd = $mod, M, Shell: Media controls, global, quickshell:mediaControlsToggle
    bindd = $mod, G, Shell: Widget overlay, global, quickshell:overlayToggle
    bindd = $mod, J, Shell: Toggle side rails, global, quickshell:barToggle
    bindd = CTRL ALT, Delete, Session: Menu, global, quickshell:sessionToggle
    bindd = $mod SHIFT, T, Capture: Translate screen, global, quickshell:screenTranslate
    bindd = $mod SHIFT, C, Capture: Pick color, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a
    bindld = $mod SHIFT, N, Media: Next, exec, playerctl next
    bindld = $mod SHIFT, B, Media: Previous, exec, playerctl previous
    bindld = $mod SHIFT, P, Media: Play or pause, exec, playerctl play-pause
    bindld = $mod SHIFT, M, Audio: Mute, exec, qs ipc call shell mute
    bindld = $mod ALT, M, Audio: Mute microphone, exec, qs ipc call shell micMute
    bindld = , XF86AudioPause, Media: Play or pause, exec, playerctl play-pause
    bindd = $mod ALT, Space, Windows: Float or tile, togglefloating,
    bindd = $mod, P, Windows: Pin floating window, pin,
    binded = $mod, semicolon, Windows: Reduce split ratio, layoutmsg, splitratio -0.1
    binded = $mod, apostrophe, Windows: Increase split ratio, layoutmsg, splitratio +0.1
    bindd = $mod SHIFT ALT, Q, Windows: Pick window to force close, exec, hyprctl kill
    bindd = $mod ALT, F, Windows: Fullscreen spoof, fullscreenstate, 0 3
    bindd = $mod, S, Workspaces: Toggle scratchpad, togglespecialworkspace, magic
    bindd = $mod ALT, S, Windows: Send to scratchpad, movetoworkspacesilent, special:magic
    bindd = $mod CTRL, S, Workspaces: Toggle scratchpad, togglespecialworkspace, magic
    bindd = $mod CTRL, bracketleft, Workspaces: Switch -1, workspace, -1
    bindd = $mod CTRL, bracketright, Workspaces: Switch +1, workspace, +1
    bindd = $mod, E, Apps: Files, exec, ${pkgs.kdePackages.dolphin}/bin/dolphin
    bindd = $mod, T, Apps: Terminal, exec, ${pkgs.alacritty}/bin/alacritty
    bindd = CTRL ALT, T, Apps: Terminal, exec, ${pkgs.alacritty}/bin/alacritty
    bindd = CTRL SHIFT, Escape, Apps: Task manager, exec, ${pkgs.alacritty}/bin/alacritty -e ${pkgs.btop}/bin/btop
    bindd = $mod CTRL, V, Apps: Audio mixer, exec, ${pkgs.pavucontrol}/bin/pavucontrol
    bindd = $mod SHIFT ALT, slash, Shell: Welcome, exec, qs -p ~/.config/quickshell/welcome.qml
    bindld = $mod ALT, R, Capture: Record region, global, quickshell:regionRecord
    bindld = CTRL ALT, R, Capture: Record focused screen, exec, bash ~/.config/quickshell/scripts/videos/record.sh --fullscreen
    bindld = $mod SHIFT ALT, R, Capture: Record screen with audio, exec, bash ~/.config/quickshell/scripts/videos/record.sh --fullscreen --sound
    bindlnd = CTRL, Print, Capture: Save screenshot and copy, exec, python3 ~/.config/quickshell/scripts/desktop/action.py screenshot-file
    bindd = $mod ALT, equal, Testing: Urgent notification, exec, notify-send -u critical "Encore notification" "A little louder, a little brighter ♡"
    binded = $mod ALT, minus, Display: Zoom out, exec, python3 ~/.config/quickshell/scripts/desktop/action.py zoom-out
    bindd = $mod ALT, BackSpace, Display: Reset zoom, exec, python3 ~/.config/quickshell/scripts/desktop/action.py zoom-reset
    bindd = $mod ALT, 1, Windows: Send silently to workspace 1, movetoworkspacesilent, 1
    bindd = $mod, code:87, Workspaces: Keypad 1, workspace, 1
    bindd = $mod ALT, code:87, Windows: Keypad send 1, movetoworkspacesilent, 1
    bindd = $mod ALT, 2, Windows: Send silently to workspace 2, movetoworkspacesilent, 2
    bindd = $mod, code:88, Workspaces: Keypad 2, workspace, 2
    bindd = $mod ALT, code:88, Windows: Keypad send 2, movetoworkspacesilent, 2
    bindd = $mod ALT, 3, Windows: Send silently to workspace 3, movetoworkspacesilent, 3
    bindd = $mod, code:89, Workspaces: Keypad 3, workspace, 3
    bindd = $mod ALT, code:89, Windows: Keypad send 3, movetoworkspacesilent, 3
    bindd = $mod ALT, 4, Windows: Send silently to workspace 4, movetoworkspacesilent, 4
    bindd = $mod, code:83, Workspaces: Keypad 4, workspace, 4
    bindd = $mod ALT, code:83, Windows: Keypad send 4, movetoworkspacesilent, 4
    bindd = $mod ALT, 5, Windows: Send silently to workspace 5, movetoworkspacesilent, 5
    bindd = $mod, code:84, Workspaces: Keypad 5, workspace, 5
    bindd = $mod ALT, code:84, Windows: Keypad send 5, movetoworkspacesilent, 5
    bindd = $mod ALT, 6, Windows: Send silently to workspace 6, movetoworkspacesilent, 6
    bindd = $mod, code:85, Workspaces: Keypad 6, workspace, 6
    bindd = $mod ALT, code:85, Windows: Keypad send 6, movetoworkspacesilent, 6
    bindd = $mod ALT, 7, Windows: Send silently to workspace 7, movetoworkspacesilent, 7
    bindd = $mod, code:79, Workspaces: Keypad 7, workspace, 7
    bindd = $mod ALT, code:79, Windows: Keypad send 7, movetoworkspacesilent, 7
    bindd = $mod ALT, 8, Windows: Send silently to workspace 8, movetoworkspacesilent, 8
    bindd = $mod, code:80, Workspaces: Keypad 8, workspace, 8
    bindd = $mod ALT, code:80, Windows: Keypad send 8, movetoworkspacesilent, 8
    bindd = $mod ALT, 9, Windows: Send silently to workspace 9, movetoworkspacesilent, 9
    bindd = $mod, code:81, Workspaces: Keypad 9, workspace, 9
    bindd = $mod ALT, code:81, Windows: Keypad send 9, movetoworkspacesilent, 9
    bindd = $mod ALT, 0, Windows: Send silently to workspace 10, movetoworkspacesilent, 10
    bindd = $mod, code:90, Workspaces: Keypad 10, workspace, 10
    bindd = $mod ALT, code:90, Windows: Keypad send 10, movetoworkspacesilent, 10
    bindd = $mod ALT, F1, Session: Enter VM passthrough, submap, virtual-machine
    submap = virtual-machine
    bindd = $mod ALT, F1, Session: Leave VM passthrough, submap, reset
    submap = reset

    # Upstream Super tap launcher and hold-to-show workspace numbers.
    bindd = $mod, Super_L, Shell: Search on Super release, global, quickshell:searchToggleRelease
    bindd = $mod, Super_R, Shell: Search on Super release, global, quickshell:searchToggleRelease
    bindit = , Super_L, global, quickshell:workspaceNumber
    bindit = , Super_R, global, quickshell:workspaceNumber
    bindrit = , Super_L, global, quickshell:workspaceNumber
    bindrit = , Super_R, global, quickshell:workspaceNumber

    # Remaining upstream actions and aliases.
    bindd = $mod CTRL, P, Shell: Cycle family, global, quickshell:panelFamilyCycle
    bindld = ALT, XF86AudioMute, Audio: Mute microphone, exec, qs ipc call shell micMute
    bindm = $mod, mouse:274, movewindow
    bindd = $mod, mouse:275, Workspaces: Scratchpad, togglespecialworkspace, magic
    bindd = $mod SHIFT ALT, mouse:275, Media: Previous, exec, playerctl previous
    bindd = $mod SHIFT ALT, mouse:276, Media: Next, exec, playerctl next
    bindd = $mod SHIFT ALT, mouse:273, Utilities: Summarize selection locally, exec, python3 ~/.config/quickshell/scripts/desktop/action.py selection-query
    binded = $mod, code:82, Display: Zoom out with keypad, exec, python3 ~/.config/quickshell/scripts/desktop/action.py zoom-out
    binded = $mod, code:86, Display: Zoom in with keypad, exec, python3 ~/.config/quickshell/scripts/desktop/action.py zoom-in
    bindd = $mod CTRL ALT, left, Workspaces: Previous occupied, workspace, m-1
    bindd = $mod CTRL ALT, right, Workspaces: Next occupied, workspace, m+1
    bindd = $mod ALT, Prior, Windows: Send to previous workspace, movetoworkspace, r-1
    bindd = $mod ALT, Next, Windows: Send to next workspace, movetoworkspace, r+1
    bindd = $mod ALT, mouse_up, Windows: Send to previous workspace, movetoworkspace, r-1
    bindd = $mod ALT, mouse_down, Windows: Send to next workspace, movetoworkspace, r+1
    bindd = CTRL SHIFT ALT $mod, Delete, Session: Shut down, exec, systemctl poweroff || loginctl poweroff
    bindd = CTRL $mod SHIFT ALT, W, Apps: Office, exec, ${pkgs.libreoffice-fresh}/bin/libreoffice
    bindd = CTRL $mod, backslash, Windows: Resize to 640 by 480, resizeactive, exact 640 480
    bindd = $mod ALT, F11, Testing: Notification with profile image, exec, python3 ~/.config/quickshell/scripts/desktop/action.py notification-profile
    bindd = $mod ALT, F12, Testing: Notification with wallpaper, exec, python3 ~/.config/quickshell/scripts/desktop/action.py notification-wallpaper
    binddn = ALT, F4, Windows: Close key hint, exec, notify-send "Close with Super+Q" "Alt+F4 is passed through for virtual machines." -a Hyprland

    # Encore-specific alternatives for actions displaced by upstream defaults.
    bindd = $mod ALT, D, Shell: Launcher, global, quickshell:searchToggle
    bindd = $mod CTRL, W, Windows: Toggle group, togglegroup,
    bindd = $mod ALT, C, Windows: Center, centerwindow,
    bindd = $mod, code:10, Workspaces: Physical number 1, workspace, 1
    bindd = $mod, code:11, Workspaces: Physical number 2, workspace, 2
    bindd = $mod, code:12, Workspaces: Physical number 3, workspace, 3
    bindd = $mod, code:13, Workspaces: Physical number 4, workspace, 4
    bindd = $mod, code:14, Workspaces: Physical number 5, workspace, 5
    bindd = $mod, code:15, Workspaces: Physical number 6, workspace, 6
    bindd = $mod, code:16, Workspaces: Physical number 7, workspace, 7
    bindd = $mod, code:17, Workspaces: Physical number 8, workspace, 8
    bindd = $mod, code:18, Workspaces: Physical number 9, workspace, 9
    bindd = $mod, code:19, Workspaces: Physical number 10, workspace, 10
  '';
  # Match upstream's cancellation of a Super tap after a shortcut chord.
  # Keep these alongside the action so adding a chord cannot forget cancellation.
  interrupt = line: let
    match = builtins.match " *bind[^ ]* = ([^,]*), ([^,]*), .*" line;
  in
    if
      match
      != null
      && pkgs.lib.hasInfix "$mod" (builtins.elemAt match 0)
      && !(builtins.elem (builtins.elemAt match 1) ["Super_L" "Super_R" "F1"])
    then "bind = ${builtins.elemAt match 0}, ${builtins.elemAt match 1}, global, quickshell:searchToggleReleaseInterrupt\n"
    else "";
in
  bindings + pkgs.lib.concatMapStrings interrupt (pkgs.lib.splitString "\n" bindings)
