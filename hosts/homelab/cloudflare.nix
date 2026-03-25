{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "homelab" = {
        credentialsFile = config.age.secrets."cloudflare-credentials".path;
        ingress = {
          "*.oxod.nl" = "https://localhost:443";
        };
      };
    };
  };
}
