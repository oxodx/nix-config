let
  vars = import ./_variables.nix;
in {
  nixflix = {
    prowlarr = {
      enable = true;
      openFirewall = true;
      vpn.enable = true;
      config = {
        apiKey._secret = vars.secrets.prowlarr.apiKey;
        hostConfig.username = "oxod";
        hostConfig.password._secret = vars.secrets.prowlarr.password;
      };
    };
  };
}
