{pkgs, ...}: let
  configFile = "gh/config.yml";
  hostsFile = "gh/hosts.yml";
  toYAML = (pkgs.formats.yaml {}).generate;
in {
  users.users.oxod.packages = with pkgs; [
    gh
  ];

  xdg.configFile."${configFile}".source = toYAML "config.yml" {
    version = 1;
    git_protocol = "https";
    editor = "nvim";
    prompt = "enabled";
    prefer_editor_prompt = "disabled";
    pager = "less -FR";
    aliases = {
      co = "pr checkout";
    };
    http_unix_socket = "";
    browser = "firefox";
  };

  xdg.configFile."${hostsFile}".text = ''
    github.com:
      git_protocol: https
      user: oxodx
  '';
}
