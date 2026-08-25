rec {
  secrets = {
    vpn = "/root/secrets/mullvad.conf";
    jellyfin = {
      apiKey = "/root/secrets/jellyfin/api_key";
      passwords = {
        oxod = "/root/secrets/jellyfin/passwords/oxod";
      };
    };
    qbittorrent.password = "/root/secrets/qbittorrent/password";
  };
}
