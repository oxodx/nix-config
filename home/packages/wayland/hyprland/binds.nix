{pkgs, ...}: ''
  # Shell keys follow SekaiPop's layout. Native globals target the active family.
  # Descriptions are consumed by the shell's Super+/ cheatsheet.
  bindld = , XF86AudioPlay, Media: Play or pause, exec, playerctl play-pause
  bindld = , XF86AudioStop, Media: Stop, exec, playerctl stop
  bindld = , XF86AudioNext, Media: Next track, exec, playerctl next
  bindld = , XF86AudioPrev, Media: Previous track, exec, playerctl previous
  bindld = , XF86AudioMute, Audio: Mute output, exec, qs ipc call shell mute
  bindld = , XF86AudioMicMute, Audio: Mute microphone, exec, qs ipc call shell micMute
  bindeld = , XF86AudioRaiseVolume, Audio: Raise volume, exec, qs ipc call shell volumeUp
  bindeld = , XF86AudioLowerVolume, Audio: Lower volume, exec, qs ipc call shell volumeDown
  bindeld = , XF86MonBrightnessUp, Display: Raise brightness, exec, qs ipc call brightness increment
  bindeld = , XF86MonBrightnessDown, Display: Lower brightness, exec, qs ipc call brightness decrement

  bindd = $mod, A, Shell: Launcher, global, quickshell:searchToggle
  bindd = $mod, D, Shell: Launcher, global, quickshell:searchToggle
  bindd = $mod, N, Shell: Quick controls, global, quickshell:shellControls
  bindd = $mod, Tab, Shell: Overview or launcher, global, quickshell:shellOverview
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
  bind = $mod, Return, exec, ${pkgs.alacritty}/bin/alacritty
  bind = $mod, X, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a

  bind = $mod, left, movefocus, l
  bind = $mod, down, movefocus, d
  bind = $mod, up, movefocus, u
  bind = $mod, right, movefocus, r
  bindd = $mod ALT, H, Windows: Focus l, movefocus, l
  bindd = $mod ALT, J, Windows: Focus d, movefocus, d
  bindd = $mod ALT, K, Windows: Focus u, movefocus, u
  bindd = $mod ALT, L, Windows: Focus r, movefocus, r

  bind = $mod CTRL, left, movewindow, l
  bind = $mod CTRL, down, movewindow, d
  bind = $mod CTRL, up, movewindow, u
  bind = $mod CTRL, right, movewindow, r
  bind = $mod CTRL, H, movewindow, l
  bind = $mod CTRL, J, movewindow, d
  bind = $mod CTRL, K, movewindow, u
  bind = $mod CTRL, L, movewindow, r

  bind = $mod SHIFT, left, focusmonitor, l
  bind = $mod SHIFT, down, focusmonitor, d
  bind = $mod SHIFT, up, focusmonitor, u
  bind = $mod SHIFT, right, focusmonitor, r
  bind = $mod SHIFT, H, focusmonitor, l
  bind = $mod SHIFT, J, focusmonitor, d
  bind = $mod SHIFT, K, focusmonitor, u
  bind = $mod SHIFT, L, focusmonitor, r

  bind = $mod SHIFT CTRL, left, movewindow, mon:eDP-1
  bind = $mod SHIFT CTRL, H, movewindow, mon:eDP-1
  bind = $mod SHIFT CTRL, right, movewindow, mon:HDMI-A-1
  bind = $mod SHIFT CTRL, L, movewindow, mon:HDMI-A-1

  bind = $mod, Prior, workspace, e-1
  bind = $mod, Next, workspace, e+1
  bind = $mod, U, workspace, e+1
  bind = $mod CTRL, Prior, movetoworkspace, e-1
  bind = $mod CTRL, Next, movetoworkspace, e+1
  bind = $mod CTRL, I, movetoworkspace, e-1
  bind = $mod CTRL, U, movetoworkspace, e+1
  bind = $mod SHIFT, Prior, movetoworkspace, e-1
  bind = $mod SHIFT, Next, movetoworkspace, e+1
  bind = $mod SHIFT, I, movetoworkspace, e-1
  bind = $mod SHIFT, U, movetoworkspace, e+1

  bind = $mod, mouse_down, workspace, e+1
  bind = $mod, mouse_up, workspace, e-1
  bind = $mod CTRL, mouse_down, movetoworkspace, e+1
  bind = $mod CTRL, mouse_up, movetoworkspace, e-1
  bind = $mod, mouse_left, movefocus, l
  bind = $mod, mouse_right, movefocus, r
  bind = $mod CTRL, mouse_left, movewindow, l
  bind = $mod CTRL, mouse_right, movewindow, r
  bind = $mod SHIFT, mouse_down, movefocus, r
  bind = $mod SHIFT, mouse_up, movefocus, l
  bind = $mod SHIFT CTRL, mouse_down, movewindow, r
  bind = $mod SHIFT CTRL, mouse_up, movewindow, l

  bind = $mod, 1, workspace, 1
  bind = $mod, 2, workspace, 2
  bind = $mod, 3, workspace, 3
  bind = $mod, 4, workspace, 4
  bind = $mod, 5, workspace, 5
  bind = $mod, 6, workspace, 6
  bind = $mod, 7, workspace, 7
  bind = $mod, 8, workspace, 8
  bind = $mod, 9, workspace, 9
  bind = $mod, 0, workspace, 10

  bind = $mod CTRL, 1, movetoworkspace, 1
  bind = $mod CTRL, 2, movetoworkspace, 2
  bind = $mod CTRL, 3, movetoworkspace, 3
  bind = $mod CTRL, 4, movetoworkspace, 4
  bind = $mod CTRL, 5, movetoworkspace, 5
  bind = $mod CTRL, 6, movetoworkspace, 6
  bind = $mod CTRL, 7, movetoworkspace, 7
  bind = $mod CTRL, 8, movetoworkspace, 8
  bind = $mod CTRL, 9, movetoworkspace, 9
  bind = $mod CTRL, 0, movetoworkspace, 10

  bind = $mod, bracketleft, moveoutofgroup,
  bind = $mod, bracketright, moveintogroup,
  bind = $mod, comma, moveintogroup,
  bind = $mod, R, layoutmsg, togglesplit
  bindd = $mod CTRL SHIFT, R, Windows: Swap split, layoutmsg, swapsplit
  bind = $mod, F, fullscreen, 1
  bind = $mod SHIFT, F, fullscreen, 0
  bindd = $mod SHIFT, V, Windows: Toggle floating, togglefloating,
  bind = $mod, W, togglegroup,
  bind = $mod, minus, resizeactive, -40 0
  bind = $mod, equal, resizeactive, 40 0
  bind = $mod SHIFT, minus, resizeactive, 0 -40
  bind = $mod SHIFT, equal, resizeactive, 0 40
  bind = $mod, C, centerwindow,
  bind = $mod, Q, killactive,
  bind = $mod, O, togglespecialworkspace, magic
  bind = $mod SHIFT, O, movetoworkspace, special:magic

  bind = , Print, exec, grim - | wl-copy
  bindd = $mod SHIFT, S, Capture: Screen snip, global, quickshell:regionScreenshot
  bindd = $mod SHIFT, X, Capture: OCR to clipboard, global, quickshell:regionOcr
  bindd = $mod SHIFT, A, Capture: Search image with Lens, global, quickshell:regionSearch
  bindd = $mod SHIFT, R, Capture: Record region, global, quickshell:regionRecord
  bindd = $mod CTRL SHIFT, S, Capture: Record region with sound, global, quickshell:regionRecordWithSound

  bindm = $mod, mouse:272, movewindow
  bindm = $mod, mouse:273, resizewindow
''
