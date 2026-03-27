{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix related
    nix-output-monitor
    hydra-check
    nix-index
    nix-init
    nix-melt
    nix-tree

    # Misc
    cowsay
    gnupg
    caddy
    ast-grep
  ];

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  programs.bat = {
    enable = true;
    config = {
      paper = "less -FR";
    };
  };

  programs.fzf.enable = true;

  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
    settings = {
      display = {
        compact = false;
        use_pager = true;
      };
      updates = {
        auto_update = false;
        auto_update_interval_hours = 720;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
