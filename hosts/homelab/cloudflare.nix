{ config, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "homelab" = {
        credentialsFile = config.age.secrets."cloudflare-credentials".path;
        default = "https://localhost:443";
      };
    };
  };
}
