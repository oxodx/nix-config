{
  lib,
  pkgs,
  ...
}: let
  settings = import ./settings.nix;
  binds = import ./binds.nix {inherit pkgs;};
  rules = import ./rules.nix;

  unitySplashWatcher = pkgs.writeShellApplication {
    name = "unity-splash-watcher";
    runtimeInputs = with pkgs; [hyprland jq socat];
    text = ''
      hide_stale_splash() {
        while IFS= read -r address; do
          hyprctl dispatch movetoworkspacesilent \
            "special:unity-splash,address:$address"
        done < <(
          hyprctl clients -j | jq -r '
            [.[] | select(.class | startswith("Unity-"))] as $unity
            | if any($unity[]; .title != "Unity")
              then $unity[] | select(.title == "Unity") | .address
              else empty
              end
          '
        )
      }

      while true; do
        socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

        if [[ -S "$socket" ]]; then
          hide_stale_splash

          while IFS= read -r event; do
            case "$event" in
              openwindow\>\>*|windowtitlev2\>\>*) hide_stale_splash ;;
            esac
          done < <(socat -u "UNIX-CONNECT:$socket" -)
        fi

        sleep 1
      done
    '';
  };

  hyprlandConfig = ''
    $mod = SUPER

    ${settings}

    source = ~/.config/hypr/binds.conf
    source = ~/.config/hypr/rules.conf
  '';
in {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  qt.platformTheme = "qt5ct";

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      GTK_USE_PORTAL = 1;
    };

    systemPackages = with pkgs; [
      brightnessctl
      fuzzel
      grim
      hyprpicker
      kdePackages.polkit-kde-agent-1
      networkmanagerapplet
      playerctl
      slurp
      swayidle
      wl-clipboard
    ];
  };

  systemd.user.services.unity-splash-watcher = {
    description = "Hide Unity's launch screen after the editor opens";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = lib.getExe unitySplashWatcher;
      Restart = "on-failure";
      RestartSec = 1;
    };
  };

  xdg.configFile = {
    "hypr/hyprland.conf".text = hyprlandConfig;
    "hypr/binds.conf".text = binds;
    "hypr/rules.conf".text = rules;
  };
}
