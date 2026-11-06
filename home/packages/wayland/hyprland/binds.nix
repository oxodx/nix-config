{pkgs, ...}: ''
  bindl = , XF86AudioPlay, exec, playerctl play-pause
  bindl = , XF86AudioStop, exec, playerctl stop
  bindl = , XF86AudioNext, exec, playerctl next
  bindl = , XF86AudioPrev, exec, playerctl previous
  bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  bindl = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0
  bindl = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  bindl = , XF86MonBrightnessUp, exec, qs ipc call brightness increment
  bindl = , XF86MonBrightnessDown, exec, qs ipc call brightness decrement

  bind = CTRL ALT, L, exec, qs ipc call lock activate
  bind = $mod, D, exec, qs ipc call search toggle
  bind = $mod SHIFT, W, exec, qs ipc call wallpaperSelector toggle
  bind = $mod SHIFT, D, exec, ${pkgs.fuzzel}/bin/fuzzel
  bind = $mod, Return, exec, ${pkgs.alacritty}/bin/alacritty
  bind = $mod, X, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a

  bind = $mod, left, movefocus, l
  bind = $mod, down, movefocus, d
  bind = $mod, up, movefocus, u
  bind = $mod, right, movefocus, r
  bind = $mod, H, movefocus, l
  bind = $mod, J, movefocus, d
  bind = $mod, K, movefocus, u
  bind = $mod, L, movefocus, r

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
  bind = $mod, I, workspace, e-1
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
  bind = $mod, period, moveoutofgroup,
  bind = $mod, R, layoutmsg, togglesplit
  bind = $mod SHIFT, R, layoutmsg, swapsplit
  bind = $mod, F, fullscreen, 1
  bind = $mod SHIFT, F, fullscreen, 0
  bind = $mod, V, togglefloating,
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
  bind = $mod SHIFT, S, exec, qs ipc call region screenshot

  bindm = $mod, mouse:272, movewindow
  bindm = $mod, mouse:273, resizewindow
''
