{
  lib,
  pkgs,
  mylib,
  ...
}: let
  vars = import ./_variables.nix;
in {
  imports = mylib.scanPaths ./.;

  networking.firewall = {
    enable = true;
  };

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvpl
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };

  systemd.tmpfiles.rules = [
    "d ${vars.dirs.media} 0775 media media -"
    "d ${vars.dirs.media}/downloads 0775 media media -"

    "d ${vars.dirs.state}/sonarr 0755 media media -"
    "d ${vars.dirs.state}/radarr 0755 media media -"
    "d ${vars.dirs.state}/prowlarr 0755 media media -"
  ];

  users.groups.media.gid = vars.gids.media;
  users.users.media = {
    isSystemUser = true;
    uid = vars.uids.media;
    group = "media";
    createHome = false;
    extraGroups = [
      "video"
      "render"
    ];
  };

  vpnNamespaces.wg = lib.mkIf vars.vpn.enable {
    enable = true;
    openVPNPorts = lib.optional (vars.vpn.vpnTestService.port != null) {
      port = vars.vpn.vpnTestService.port;
      protocol = "tcp";
    };
    accessibleFrom =
      (
        if vars.vpn.exposeOnLAN
        then [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
        ]
        else ["127.0.0.1"]
      )
      ++ vars.vpn.accessibleFrom;
    wireguardConfigFile = vars.vpn.wgConf;
  };

  systemd.services.vpn-test-service = lib.mkIf vars.vpn.vpnTestService.enable {
    enable = true;
    wantedBy = ["multi-user.target"];

    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    script = let
      vpn-test = pkgs.writeShellApplication {
        name = "vpn-test";
        runtimeInputs = with pkgs; [
          util-linux
          unixtools.ping
          coreutils
          curl
          bash
          libressl
          netcat-gnu
          openresolv
          dig
          jq
        ];
        text =
          ''
            cd "$(mktemp -d)"

            echo "=== VPN Confinement Test ==="

            echo -e "\n--- DNS Resolution ---"
            dig google.com

            echo -e "\n--- /etc/resolv.conf ---"
            cat /etc/resolv.conf

            if command -v resolvconf >/dev/null 2>&1; then
              echo -e "\n--- resolvconf output ---"
              resolvconf -l || true
            fi

            echo -e "\n--- External IP ---"
            curl -s https://ipinfo.io || true

            echo -e "\n--- DNS Leak Test ---"
            curl -s https://raw.githubusercontent.com/macvk/dnsleaktest/b03ab54d574adbe322ca48cbcb0523be720ad38d/dnsleaktest.sh -o dnsleaktest.sh || true
            chmod +x dnsleaktest.sh || true
            ./dnsleaktest.sh || true

            echo -e "\n=== Test Complete ==="
          ''
          + (
            if vars.vpn.vpnTestService.port != null
            then ''
              echo -e "\n--- Listening on port ${toString vars.vpn.vpnTestService.port} ---"
              nc -vnlp ${toString vars.vpn.vpnTestService.port}
            ''
            else ""
          );
      };
    in "${vpn-test}/bin/vpn-test";
  };
}
