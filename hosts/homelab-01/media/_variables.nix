rec {
  secrets =
    "root/secrets/"
    ++ {
      vpn = "mullvad.conf";
      jellyfin = {
        apiKey = "jellyfin/api_key";
        passwords = {
          oxod = "jellyfin/passwords/oxod";
        };
      };
    };
}
