{
  config,
  pkgs,
  ...
}: let
  configFile = "cliphist/cliphistrc";
in {
  users.users.oxod.packages = with pkgs; [
    cliphist
    wl-clipboard
  ];

  systemd.user.services.cliphist = {
    description = "Clipboard management daemon";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist -max-dedupe-search 10 -max-items 500 store";
      Restart = "on-failure";
      Type = "simple";
    };

    path = [pkgs.cliphist pkgs.wl-clipboard];
  };

  xdg.configFile."${configFile}".text = ''
    allow_images=true
    max_entries=500
    database=${config.xdg.dataHome}/cliphist/db
  '';
}
