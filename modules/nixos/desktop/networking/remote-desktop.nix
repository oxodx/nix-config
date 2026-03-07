# This file is copied from ryan4yin's nix-config, with some modifications. The original file can be found at:
# https://github.com/ryan4yin/nix-config/blob/3bf1b986cfbfcd333f0a835861728ec405a0a759/modules/nixos/desktop/networking/remote-desktop.nix

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    moonlight-qt # moonlight client, for streaming games/desktop from a PC
  ];

  # ===============================================================================
  #
  # Sunshine: A self-hosted game stream server for Moonlight(Client).
  # It's designed for game streaming, but it can be used for remote desktop as well.
  #
  # How to use:
  #  1. setup user via Web Console: <https://localhost:47990/>):
  #  2. on another machine, connect to sunshine on via moonlight-qt client
  #
  # Docs:
  #  https://docs.lizardbyte.dev/projects/sunshine/latest/index.html
  #
  # Check Service Status
  #   systemctl --user status sunshine
  # Check logs
  #   journalctl --user -u sunshine --since "2 minutes ago"
  #
  # References:
  #   https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/services/networking/sunshine.nix
  #
  # ===============================================================================
  services.sunshine = {
    enable = false; # default to false, for security reasons.
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
    settings = {
      # pc  - Only localhost may access the web ui
      # lan - Only LAN devices may access the web ui
      origin_web_ui_allowed = "pc";
      # 2   -	encryption is mandatory and unencrypted connections are rejected
      lan_encryption_mode = 2;
      wan_encryption_mode = 2;
    };
  };
}
