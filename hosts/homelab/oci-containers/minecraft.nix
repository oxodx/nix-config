{ config, pkgs, ... }:
let
  dataDir = "/data/apps/minecraft/mc-1";
in
{
  virtualisation.oci-containers = {
    containers = {
      # Lazymc proxy
      lazymc = {
        image = "ghcr.io/joesturge/lazymc-docker-proxy:latest";
        ports = [ "25565:25565" ];
        volumes = [
          "/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro"
          "${dataDir}:/server:ro"
        ];
        extraOptions = [
          "--restart=unless-stopped"
          "--health-cmd=echo ok"
          "--no-healthcheck"
        ];
      };

      # Minecraft server (managed by lazymc)
      minecraft = {
        image = "itzg/minecraft-server:java21";
        volumes = [ "${dataDir}:/data" ];
        environment = {
          EULA = "TRUE";
          DISABLE_HEALTHCHECK = "true";
        };
        labels = {
          "lazymc.enabled" = "true";
          "lazymc.group" = "mc";
          "lazymc.server.address" = "minecraft:25565";
        };
        extraOptions = [
          "--restart=no"
          "--health-cmd=echo ok"
          "--no-healthcheck"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
}
