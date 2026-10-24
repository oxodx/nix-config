{pkgs, ...}: {
  environment = {
    shells = [pkgs.fish];
    pathsToLink = ["/share/fish"];
    systemPackages = with pkgs; [
      eza
      lazygit
    ];
  };

  programs = {
    less.enable = true;

    fish = {
      enable = true;
      shellAliases = {
        cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
        listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
        nixremove = "nix-store --gc";
        bloat = "nix path-info -Sh /run/current-system";
        cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
        trimall = "sudo fstrim -va";
        c = "clear";
        q = "exit";
        temp = "cd /tmp/";
        test-build = "sudo nixos-rebuild test --flake .#oxod-laptop";
        switch-build = "sudo nixos-rebuild switch --flake .#oxod-laptop";
        add = "git add .";
        commit = "git commit";
        push = "git push";
        pull = "git pull";
        diff = "git diff --staged";
        gcld = "git clone --depth 1";
        gitui = "lazygit";

        ls = "eza -al --color=always --group-directories-first --icons";
        la = "eza -a --color=always --group-directories-first --icons";
        ll = "eza -l --color=always --group-directories-first --icons";
        lt = "eza -aT --color=always --group-directories-first --icons";
        tree = "eza --tree --icons --tree";

        cat = "${pkgs.bat}/bin/bat --paging=never";
        store-path = "${pkgs.coreutils-full}/bin/readlink (${pkgs.which}/bin/which $argv)";
        us = "systemctl --user";
        rs = "sudo systemctl";
        zed = "zeditor";
      };
    };
  };
}
