let
  pointer = "MacTahoe-dark-cursors";
in {
  environment = {
    CLUTTER_BACKEND = "wayland";
    DISPLAY = ":0";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    GTK_IM_MODULE = "simple";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_DESKTOP = "niri";
  };

  spawn-at-startup = [
    ["xwayland-satellite"]
    ["nm-applet" "--indicator"]
    ["dbus-update-activation-environment" "--systemd" "--all"]
    ["swayidle" "-w" "timeout" "300" "swaylock -f -c 000000" "before-sleep" "swaylock -f -c 000000"]
    ["sh" "-c" "/run/current-system/sw/libexec/polkit-kde-authentication-agent-1 2>/dev/null || true"]
  ];

  input = {
    keyboard.xkb.layout = "us";
    touchpad = {
      click-method = "button-areas";
      dwt = {};
      dwtp = {};
      natural-scroll = {};
      scroll-method = "two-finger";
      tap = {};
      tap-button-map = "left-right-middle";
      middle-emulation = {};
      accel-profile = "adaptive";
    };
    focus-follows-mouse._props = {max-scroll-amount = "90%";};
    warp-mouse-to-focus = {};
    workspace-auto-back-and-forth = {};
  };

  screenshot-path = "~/Pictures/Screenshots/Screenshot-from-%Y-%m-%d-%H-%M-%S.png";

  output = [
    {
      _args = ["eDP-1"];
      scale = 1.0;
      position._props = {
        x = 0;
        y = 0;
      };
    }
    {
      _args = ["HDMI-A-1"];
      mode = "1920x1080";
      scale = 1.0;
      position._props = {
        x = 1920;
        y = 0;
      };
    }
  ];

  overview = {
    workspace-shadow.off = {};
    backdrop-color = "transparent";
  };

  gestures.hot-corners = {};

  cursor = {
    xcursor-size = 24;
    xcursor-theme = pointer;
  };

  layout = {
    background-color = "transparent";
    focus-ring.off = {};
    border = {
      width = 2;
    };
    shadow.off = {};
    preset-column-widths.proportion = [0.25 0.5 0.75 1.0];
    default-column-width.proportion = 0.5;
    always-center-single-column = {};
    gaps = 6;
    struts = {
      left = 0;
      right = 0;
      top = 0;
      bottom = 0;
    };
    tab-indicator = {
      hide-when-single-tab = {};
      place-within-column = {};
      position = "left";
      corner-radius = 20.0;
      gap = -12.0;
      gaps-between-tabs = 10.0;
      width = 4.0;
      length._props = {total-proportion = 0.1;};
    };
  };

  prefer-no-csd = {};
  hotkey-overlay.skip-at-startup = {};
}
