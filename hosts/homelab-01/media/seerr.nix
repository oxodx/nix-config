let
  vars = import ./_variables.nix;
in {
  nixflix = {
    seerr = {
      enable = true;
      openFirewall = true;
      apiKey._secret = vars.secrets.seerr.apiKey;
      settings.users.defaultPermissions = 160;
    };
  };
}
