{ pkgs, lib, ... }: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
    extest.enable = true;
  };

  services.pipewire.lowLatency.enable = true;
  programs.steam.platformOptimizations.enable = true;

  programs.gamemode.enable = true;
}
