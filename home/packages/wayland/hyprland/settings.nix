''
  monitor = eDP-1, preferred, 0x0, 1
  monitor = HDMI-A-1, 1920x1080, 1920x0, 1
  monitor = , preferred, auto, 1

  env = XCURSOR_THEME,Bibata-Original-Ice
  env = XCURSOR_SIZE,20
  env = QT_QPA_PLATFORMTHEME,qt6ct
  env = QT_QPA_PLATFORM,wayland;xcb
  env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
  env = NIXOS_OZONE_WL,1
  env = MOZ_ENABLE_WAYLAND,1
  env = ELECTRON_OZONE_PLATFORM_HINT,auto
  env = SDL_VIDEODRIVER,wayland
  env = LIBVA_DRIVER_NAME,nvidia
  env = __GLX_VENDOR_LIBRARY_NAME,nvidia
  env = GBM_BACKEND,nvidia-drm

  general {
    gaps_in = 6
    gaps_out = 6
    border_size = 2
    col.active_border = rgba(f4f6fbee)
    col.inactive_border = rgba(45475aaa)
    resize_on_border = true
    allow_tearing = false
    layout = dwindle
  }

  decoration {
    rounding = 20
    active_opacity = 1.0
    inactive_opacity = 1.0

    shadow {
      enabled = true
      range = 12
      render_power = 3
      color = rgba(00000055)
    }

    blur {
      enabled = true
      size = 4
      passes = 2
      vibrancy = 0.1696
    }
  }

  animations {
    enabled = true
    bezier = easeOut, 0.05, 0.9, 0.1, 1.0
    animation = windows, 1, 4, easeOut
    animation = windowsOut, 1, 3, easeOut, popin 90%
    animation = border, 1, 6, easeOut
    animation = fade, 1, 5, easeOut
    animation = workspaces, 1, 4, easeOut, slide
  }

  dwindle {
    preserve_split = true
    smart_split = false
    smart_resizing = true
    force_split = 0
  }

  master {
    new_status = master
    mfact = 0.5
  }

  gesture = 3, horizontal, workspace

  misc {
    force_default_wallpaper = 0
    disable_hyprland_logo = true
    disable_splash_rendering = true
    focus_on_activate = true
    mouse_move_enables_dpms = true
    key_press_enables_dpms = true
  }

  input {
    kb_layout = us
    follow_mouse = 1
    sensitivity = 0
    numlock_by_default = false
    scroll_method = two_finger

    touchpad {
      natural_scroll = true
      tap-to-click = true
      clickfinger_behavior = false
      disable_while_typing = true
      middle_button_emulation = true
    }
  }

  cursor {
    no_hardware_cursors = true
    inactive_timeout = 0
  }

  xwayland {
    force_zero_scaling = true
  }

  ecosystem {
    no_update_news = true
    no_donation_nag = true
  }

  exec-once = dbus-update-activation-environment --systemd --all
  exec-once = nm-applet --indicator
  exec-once = swayidle -w timeout 300 'qs ipc call lockscreen lock' before-sleep 'qs ipc call lockscreen lock' lock 'qs ipc call lockscreen lock'
  exec-once = sh -c '/run/current-system/sw/libexec/polkit-kde-authentication-agent-1 2>/dev/null || true'
''
