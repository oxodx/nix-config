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
  authUtil = import ./authUtil.nix {
    inherit
      lib
      pkgs
      cfg
      mylib
      ;
  };
  baseUrl = "http://${cfg.connectionAddress}:${toString cfg.port}";
in
{
  config = mkIf (nixflix.enable && cfg.enable) {
    systemd.services.seerr-libraries = {
      description = "Sync Seerr library selections";
      after = [
        "seerr-jellyfin.service"
      ]
      ++ optional nixflix.jellyfin.enable "jellyfin-libraries.service";
      requires = [
        "seerr-jellyfin.service"
      ]
      ++ optional nixflix.jellyfin.enable "jellyfin-libraries.service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script =
        let
          typeFilter =
            if cfg.jellyfin.libraryFilter.types == [ ] then
              "true"
            else
              let
                typeList = map (t: ''"${t}"'') cfg.jellyfin.libraryFilter.types;
              in
              "[.type] | inside([${concatStringsSep "," typeList}])";

          nameFilter =
            if cfg.jellyfin.libraryFilter.names == [ ] then
              "true"
            else
              let
                nameList = map (n: ''"${n}"'') cfg.jellyfin.libraryFilter.names;
              in
              "[.name] | inside([${concatStringsSep "," nameList}])";

          libraryFilterExpr = "select(${typeFilter} and ${nameFilter})";
        in
        ''
          set -euo pipefail

          BASE_URL="${baseUrl}"

          # Authenticate
          source ${authUtil.authScript}

          # Fetch library list
          echo "Fetching library list from Jellyfin..."
          LIBRARIES_RESPONSE=$(${pkgs.curl}/bin/curl -s \
            ${authUtil.curlAuthArgs} \
            "$BASE_URL/api/v1/settings/jellyfin/library?sync=true" \
            -w "\n%{http_code}" 2>/dev/null || true)

          LIBRARIES_HTTP_CODE=$(echo "$LIBRARIES_RESPONSE" | tail -n1)
          LIBRARIES_BODY=$(echo "$LIBRARIES_RESPONSE" | sed '$d')

          if [ "$LIBRARIES_HTTP_CODE" != "200" ]; then
            echo "Failed to fetch libraries (HTTP $LIBRARIES_HTTP_CODE) - retry after logging in"
            exit 0
          fi

          echo "Available libraries:"
          echo "$LIBRARIES_BODY" | ${pkgs.jq}/bin/jq -r '.[] | "\(.id) - \(.name) (\(.type))"'

          # Apply filters and get IDs to enable
          ${
            if cfg.jellyfin.enableAllLibraries then
              ''
                # Enable all libraries
                LIBRARY_IDS=$(echo "$LIBRARIES_BODY" | ${pkgs.jq}/bin/jq -r '.[].id' | paste -sd,)
              ''
            else
              ''
                # Apply filters to select libraries
                LIBRARY_IDS=$(echo "$LIBRARIES_BODY" | ${pkgs.jq}/bin/jq -r \
                  '.[] | ${libraryFilterExpr} | .id' | paste -sd,)
              ''
          }

          if [ -n "$LIBRARY_IDS" ]; then
            echo "Enabling libraries: $LIBRARY_IDS"
            ${pkgs.curl}/bin/curl -s \
              ${authUtil.curlAuthArgs} \
              "$BASE_URL/api/v1/settings/jellyfin/library?enable=$LIBRARY_IDS" >/dev/null 2>&1 || true
            echo "Libraries enabled successfully"
          else
            echo "Warning: No libraries matched the filter criteria"
          fi
        '';
    };
  };
}
