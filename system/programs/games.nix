{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];

      gamescopeSession = {
        enable = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };
}
