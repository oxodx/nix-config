{
  lib,
  pkgs,
  ...
}: let
  version = "0.10.2";
  gitPages = pkgs.stdenvNoCC.mkDerivation {
    pname = "git-pages";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://codeberg.org/git-pages/git-pages/releases/download/v${version}/git-pages.linux-amd64";
      hash = "sha256-zhveGS1MgQVFki8hk6l2XyR3MimAtD7+oGk4eyw2NG0=";
    };

    dontUnpack = true;
    installPhase = ''
      runHook preInstall
      install -Dm755 "$src" "$out/bin/git-pages"
      runHook postInstall
    '';

    meta = {
      description = "Static site server for Git forges";
      homepage = "https://codeberg.org/git-pages/git-pages";
      license = lib.licenses.bsd0;
      mainProgram = "git-pages";
      platforms = ["x86_64-linux"];
    };
  };

  pagesRouter = pkgs.buildGoModule {
    pname = "pages-router";
    version = "1.0.0";
    src = ./pages-router;
    vendorHash = null;
    meta.mainProgram = "pages-router";
  };

  configFile = (pkgs.formats.toml {}).generate "git-pages.toml" {
    log-format = "text";

    server = {
      pages = "tcp/127.0.0.1:3003";
      proxy = "-";
      metrics = "tcp/127.0.0.1:3004";
      https = "-";
    };

    # git-pages normally maps <user>.<domain>/<project>. Since this is a
    # single-user forge, pages.oxod.nl is the oxod namespace and the project is
    # selected by the first URL path component.
    wildcard = [
      {
        domain = "oxod.nl";
        clone-url = "https://git.oxod.nl/<user>/<project>.git";
        index-repo = "pages";
        index-repo-branch = "pages";
        authorization = "forgejo";
      }
    ];

    secrets = {
      type = "fs";
      fs.root = "/var/lib/git-pages/data";
    };

    storage = {
      type = "fs";
      fs.root = "/var/lib/git-pages/data";
    };

    limits = {
      max-site-size = "512M";
      allowed-repository-url-prefixes = ["https://git.oxod.nl/"];
      allowed-custom-headers = [
        "X-Clacks-Overhead"
        "Content-Security-Policy"
        "Cross-Origin-Embedder-Policy"
        "Cross-Origin-Opener-Policy"
        "Cross-Origin-Resource-Policy"
        "Permissions-Policy"
      ];
      allow-basic-auth = false;
      allow-expiration = false;
    };
  };
in {
  systemd.services.git-pages = {
    description = "Forgejo Pages static site server";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target" "forgejo.service"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      StateDirectory = "git-pages";
      StateDirectoryMode = "0750";
      WorkingDirectory = "/var/lib/git-pages";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/lib/git-pages/data";
      ExecStart = "${lib.getExe gitPages} -config ${configFile}";
      Restart = "on-failure";
      RestartSec = "5s";
      UMask = "0027";

      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = ["@system-service" "~@privileged" "~@resources"];
    };
  };

  systemd.services.pages-router = {
    description = "Forgejo Pages owner-aware URL router";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target" "forgejo.service" "git-pages.service"];
    requires = ["git-pages.service"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "simple";
      DynamicUser = true;
      ExecStart = lib.getExe pagesRouter;
      Restart = "on-failure";
      RestartSec = "5s";

      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictAddressFamilies = ["AF_INET" "AF_INET6" "AF_UNIX"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = ["@system-service" "~@privileged" "~@resources"];
    };
  };
}
