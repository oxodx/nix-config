{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "homelab" = {
        credentialsFile = config.age.secrets."cloudflare-creds".path;
        default = "http://localhost:80";
        edgeIPVersion = "4";
      };
    };
  };
}
