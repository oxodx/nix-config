{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = false;
    installBatSyntax = false;
    settings = {
      font-family = "Maple Mono NF CN";
      font-size = 13;

      background-opacity = 0.93;
      background-blur-radius = 10;
      scrollback-limit = 20000;

      command = "${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'";
    };
  };
}
