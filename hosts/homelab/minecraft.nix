{
  pkgs,
  ...
}:
{
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/services/games/minecraft-server.nix
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;

    package = pkgs.minecraft-server_1_21;
    dataDir = "/data/apps/minecraft/mc-1";

    serverProperties = {
      gamemode = "survival";
      difficulty = "hard";
      simulation-distance = 10;
      white-list = true;
      allow-cheats = true;
    };

    whitelist = {
      "0x0D_" = "ef9ebb67-034c-4520-a700-6c67a3d63bb1";
      "jaydon30" = "52566ea2-67eb-4266-8a9a-ad10ca6ec0df";
    };

    jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC";
  };
}
