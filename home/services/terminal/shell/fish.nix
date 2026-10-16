{pkgs, ...}: {
  users.users.oxod.packages = with pkgs; [
    fish
    grc
    (writeShellScriptBin "hx" ''
      ${pkgs.helix}/bin/hx "$@"
    '')
  ];

  xdg.configFile = {
    "fish/config.fish" = {
      text = ''
        set -gx NIXPKGS_ALLOW_UNFREE 1
        set -gx NIXPKGS_ALLOW_INSECURE 1
        set -gx EDITOR hx
        set -gx VISUAL hx
        fish_add_path --path --append "$HOME/.cargo/bin"

        set -g fish_greeting ""

        set -g fish_color_autosuggestion brblack
        set -g fish_color_command blue
        set -g fish_color_error red
        set -g fish_color_param normal

        set -g fish_color_search_match --background=normal

        set -Ux fifc_editor hx
        set -U fifc_keybinding \cv
        set -g __done_min_cmd_duration 10000
      '';
    };

    "fish/functions/fcd.fish" = {
      text = ''
        function fcd
          set -l dir (fd --type d | sk | string trim)
          if test -n "$dir"
            z $dir
          end
        end
      '';
    };

    "fish/functions/installed.fish" = {
      text = ''
        function installed
          nix-store --query --requisites /run/current-system/ | string replace -r '.*?-(.*)' '$1' | sort | uniq | sk
        end
      '';
    };

    "fish/functions/installedall.fish" = {
      text = ''
        function installedall
          nix-store --query --requisites /run/current-system/ | sk | wl-copy
        end
      '';
    };

    "fish/functions/fm.fish" = {
      text = ''
        function fm
          set -l tmp (mktemp -t "yazi-cwd.XXXXX")
          yazi $argv --cwd-file $tmp
          set -l cwd (cat $tmp)
          if test -n "$cwd" -a "$cwd" != "$PWD"
            cd $cwd
          end
          rm -f $tmp
        end
      '';
    };

    "fish/functions/gitgrep.fish" = {
      text = ''
        function gitgrep
          git ls-files | rg $argv
        end
      '';
    };

    "fish/conf.d/aliases.fish" = {
      text = ''
      '';
    };
  };
}
