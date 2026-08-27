{
  lib,
  cfg,
  pkgs,
  ...
}: let
  tokenFile = "/run/jellyfin/auth-token";
  token = {
    _secret = tokenFile;
  };
  isSecretRef = value: (builtins.isAttrs value) && (value ? _secret) && !(value ? __unfix__);
  toShellValue = value:
    if isSecretRef value
    then "$(cat ${lib.escapeShellArg value._secret})"
    else "${lib.escapeShellArg (toString value)}";
in {
  inherit token;

  authScript = pkgs.writeShellScript "jellyfin-auth" ''
    set -eu

    API_KEY=${toShellValue cfg.apiKey}
    printf '%s' "$API_KEY" > "${tokenFile}"
    chmod 600 "${tokenFile}"
  '';
}
