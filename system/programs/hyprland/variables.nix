{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.etc."xdg/hypr/variables.lua".text = ''
    cursorName = "Bibata-Modern-Classic"
    cursorSize = "16"

    rounding = 10
    rounding_power = 2.5

    gaps_in = 4
    gaps_out = 5
    gaps_workspaces = 50

    workspaceGroupSize = 10

    local launchFirstAvailable = os.getenv("HOME") .. "/.config/quickshell/scripts/hypr/launch_first_available.sh"
    terminal = launchFirstAvailable .. " 'foot' 'kitty -1' 'alacritty' 'wezterm' 'konsole' 'kgx' 'uxterm' 'xterm'"
    fileManager = launchFirstAvailable .. " 'dolphin' 'nautilus' 'nemo' 'thunar' 'kitty -1 fish -c yazi'"
    browser = launchFirstAvailable .. " 'google-chrome-stable' 'zen-browser' 'firefox' 'brave' 'chromium' 'microsoft-edge-stable' 'opera' 'librewolf'"
    codeEditor = launchFirstAvailable .. " 'zed' 'zedit' 'zeditor' 'windsurf' 'antigravity' 'code' 'codium' 'cursor' 'kate' 'gnome-text-editor' 'emacs' 'command -v nvim && kitty -1 nvim' 'command -v micro && kitty -1 micro'"
    officeSoftware = launchFirstAvailable .. " 'wps' 'onlyoffice-desktopeditors' 'libreoffice'"
    textEditor = launchFirstAvailable .. " 'kate' 'gnome-text-editor' 'emacs'"
    volumeMixer = launchFirstAvailable .. " 'pavucontrol-qt' 'pavucontrol'"
    settingsApp = "XDG_CURRENT_DESKTOP=gnome " .. launchFirstAvailable .. " 'qs -p ~/.config/quickshell/settings.qml' 'systemsettings' 'gnome-control-center' 'better-control'"
    taskManager = launchFirstAvailable .. " 'gnome-system-monitor' 'plasma-systemmonitor --page-name Processes' 'command -v btop && kitty -1 fish -c btop'"

    active_border = "rgba(0DB7D455)"
    inactive_border = "rgba(31313600)"
    text_color = "rgb(000000)"
    text_color_inactive = "rgba(ffffff66)"
    group_active_color = "rgba(ffffff66)"
    group_inactive_color = "rgba(00000066)"

    screencopy_perms = {"${config.programs.hyprland.portalPackage}/libexec/.xdg-desktop-portal-hyprland-wrapped", "${lib.getExe pkgs.grim}", "${lib.getExe pkgs.wl-screenrec}"}
  '';
}
