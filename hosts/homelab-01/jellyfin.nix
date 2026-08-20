{
  config,
  pkgs,
  ...
}: let
  customCss = "@import url('https://cdn.jsdelivr.net/npm/jellyskin@latest/dist/main.css');";
  jellyfinDir = config.services.jellyfin.dataDir;
  brandingXml = pkgs.writeText "branding.xml" ''
    <?xml version="1.0" encoding="utf-8"?>
    <BrandingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <CustomCss>${customCss}</CustomCss>
    </BrandingOptions>
  '';
in {
  systemd.services.jellyfin.serviceConfig.ExecStartPre = [
    "+mkdir -p ${jellyfinDir}"
    "+cp ${brandingXml} ${jellyfinDir}/branding.xml"
    "+chown -R jellyfin:jellyfin ${jellyfinDir}"
  ];

  services.jellyfin.enable = true;
  networking.firewall.allowedTCPPorts = [8096];
}
