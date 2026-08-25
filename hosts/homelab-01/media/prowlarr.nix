let
  vars = import ./_variables.nix;
in {
  nixflix = {
    prowlarr = {
      enable = true;
      openFirewall = true;
      config = {
        apiKey._secret = vars.secrets.prowlarr.apiKey;
        hostConfig.password._secret = vars.secrets.prowlarr.password;
      };
    };
  };
}
