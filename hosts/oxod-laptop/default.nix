{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../profiles/laptop.nix
    ../../system/programs/games.nix
    ../../system/services/gnomeServices.nix
    ../../system/hardware/cpuAmdPstate.nix
    ../../system/hardware/asusBattery.nix
    ../../home
    ../../home/packages/wayland/niri
    ../../home/services/quickshell
    ./hardware.nix
    ./vpn.nix
  ];

  services = {
    asusd.enable = true;
    supergfxd.enable = true;
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      host = "127.0.0.1";
    };
  };

  systemd.services.ollama.wantedBy = lib.mkForce [];

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id === "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") === "ollama.service" &&
          ["start", "stop"].indexOf(action.lookup("verb")) !== -1 &&
          subject.user === "oxod" && subject.local && subject.active) {
        return polkit.Result.YES;
      }
    });
  '';

  networking.hostName = "laptop";

  system.stateVersion = "26.05";
}
