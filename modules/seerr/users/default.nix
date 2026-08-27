{
  config,
  lib,
  pkgs,
  mylib,
  ...
}:
with lib;
let
  inherit (config) nixflix;
  cfg = nixflix.seerr;
  authUtil = import ../authUtil.nix {
    inherit
      lib
      pkgs
      cfg
      mylib
      ;
  };
  baseUrl = "http://${cfg.connectionAddress}:${toString cfg.port}";
  userSettings = cfg.settings.users;
in
{
  imports = [ ./options.nix ];

  config = mkIf (nixflix.enable && cfg.enable) {
    systemd.services.seerr-user-settings = {
      description = "Configure Seerr default user settings";
      after = [ "seerr-setup.service" ];
      requires = [ "seerr-setup.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script =
        let
          userSettingsJson = builtins.toJSON userSettings;
        in
        ''
          set -euo pipefail

          BASE_URL="${baseUrl}"

          echo "Configuring default user settings..."

          # Use session cookie from setup service if available (API key alone
          # lacks admin perms until an admin user has been created via Jellyfin auth)
          AUTH_ARGS=""
          if [ -f "${authUtil.cookieFile}" ]; then
            AUTH_ARGS="-b ${authUtil.cookieFile}"
          else
            AUTH_ARGS="${authUtil.curlAuthArgs}"
          fi

          SETTINGS_RESPONSE=$(${pkgs.curl}/bin/curl -s -X POST \
            $AUTH_ARGS \
            -H "Content-Type: application/json" \
            -d '${userSettingsJson}' \
            -w "\n%{http_code}" \
            "$BASE_URL/api/v1/settings/main")

          SETTINGS_HTTP_CODE=$(echo "$SETTINGS_RESPONSE" | tail -n1)
          if [ "$SETTINGS_HTTP_CODE" != "200" ] && [ "$SETTINGS_HTTP_CODE" != "201" ] && [ "$SETTINGS_HTTP_CODE" != "204" ]; then
            echo "Failed to configure user settings (HTTP $SETTINGS_HTTP_CODE) - retry after logging in"
            exit 0
          fi

          echo "User settings configured successfully"
        '';
    };
  };
}
