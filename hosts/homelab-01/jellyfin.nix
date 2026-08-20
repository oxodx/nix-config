{config, ...}: let
  customCss = "@import url('https://cdn.jsdelivr.net/npm/jellyskin@latest/dist/main.css');";
  jellyfinDir = config.services.jellyfin.dataDir;
in {
  systemd.services.jellyfin.preStart = ''
    mkdir -p ${jellyfinDir}

    cat << 'EOF' > ${jellyfinDir}/branding.xml
    <?xml version="1.0" encoding="utf-8"?>
    <BrandingOptions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
      <CustomCss>${customCss}</CustomCss>
    </BrandingOptions>
    EOF

    chown -R jellyfin:jellyfin ${jellyfinDir}
  '';

  services.jellyfin.enable = true;
  networking.firewall.allowedTCPPorts = [8096];
}
