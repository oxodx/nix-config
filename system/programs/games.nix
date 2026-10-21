{
  pkgs,
  self,
  ...
}: {
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
      args = ["--rt" "--expose-wayland"];
    };

    steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      gamescopeSession.enable = true;
    };
  };

  environment.systemPackages = [
    (pkgs.prismlauncher.overrideAttrs (old: {
      qtWrapperArgs = (old.qtWrapperArgs or []) ++ ["--set-default DISPLAY :0"];
    }))
    self.packages.${pkgs.stdenv.hostPlatform.system}.eden
  ];

  systemd.user.tmpfiles.rules = [
    "d %h/Games/roms/switch 0755 - - -"
  ];
}
