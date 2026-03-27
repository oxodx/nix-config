{
  pkgs,
  config,
  ...
}:
{
  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 3003;
    settings = {
      dns = {
        upstream_dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
      # The following notation uses map
      # to not have to manually create {enabled = true; url = "";} for every filter
      # This is, however, fully optional
      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
          ];
    };
  };
}
