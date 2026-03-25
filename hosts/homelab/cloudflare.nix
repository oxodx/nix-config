{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "homelab" = {
        # Use token instead of credentials file
        tokenFile = config.age.secrets."cloudflare-token".path;
        ingress = {
          "*.oxod.nl" = "https://localhost:443";
        };
      };
    };
  };
}
