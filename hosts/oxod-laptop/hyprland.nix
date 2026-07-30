{
  environment.etc."xdg/hypr/per_host.lua".text = ''
    ----------------------
    ---- HOST-SPECIFIC ---
    ----------------------
    hl.monitor({
      output   = "eDP-1",
      mode     = "1920x1080@144",
      position = "auto-left",
      scale    = 1,
    })
    hl.monitor({
      output   = "HDMI-A-1",
      mode     = "1920x1080@60",
      position = "auto-right",
      scale    = 1,
    })
  '';
}
