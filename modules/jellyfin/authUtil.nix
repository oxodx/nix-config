{
  lib,
  pkgs,
  cfg,
}:
let
  secrets = import ../../lib/secrets { inherit lib; };

  tokenFile = "/run/jellyfin/auth-token";
  token = {
    _secret = tokenFile;
  };
in
{
  inherit token;

  authScript = pkgs.writeShellScript "jellyfin-auth" ''
    set -eu

    API_KEY=${secrets.toShellValue cfg.apiKey}
    printf '%s' "$API_KEY" > "${tokenFile}"
    chmod 600 "${tokenFile}"
  '';
}
