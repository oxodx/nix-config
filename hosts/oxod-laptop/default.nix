{
  lib,
  pkgs,
  mylib,
  ...
}: {
  imports = [
    "${mylib.relativeToRoot}/profiles/laptop.nix"
    "${mylib.relativeToRoot}/system/programs/games.nix"
    "${mylib.relativeToRoot}/system/services/gnomeServices.nix"
    "${mylib.relativeToRoot}/system/hardware/cpuAmdPstate.nix"
    "${mylib.relativeToRoot}/system/hardware/asusBattery.nix"
    "${mylib.relativeToRoot}/home"
    "${mylib.relativeToRoot}/home/packages/wayland/niri"
    "${mylib.relativeToRoot}/home/services/quickshell"
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

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
    logDriver = "journald";
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
