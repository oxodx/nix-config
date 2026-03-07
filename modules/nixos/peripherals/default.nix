{ config, pkgs, lib, ... }: {
  services.fwupd.enable = true;
  hardware.steam-hardware.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.wirelessRegulatoryDatabase = true;
  hardware.ledger.enable = true;
  services.ratbagd.enable = true;
}
