{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
{
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  programs.gh.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user.email = myvars.useremail;
      user.name = myvars.userfullname;

      init.defaultBranch = "main";
      trim.bases = "develop,master,main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      log.date = "iso";

      url = {
        "ssh://git@github.com/0x0Dx" = {
          insteadOf = "https://github.com/0x0Dx";
        };
      };

      alias = {
        br = "branch";
        co = "checkout";
        st = "status";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        cm = "commit -m";
        ca = "commit -am";
        dc = "diff --cached";

        amend = "commit --amend -m";
        unstage = "reset HEAD --";
        merged = "branch --merged";
        unmerged = "branch --no-merged";
        nonexist = "remote prune origin --dry-run";

        delmerged = ''! git branch --merged | egrep -v "(^\*|main|master|dev|staging)" | xargs git branch -d'';
        delnonexist = "remote prune origin";

        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      diff-so-fancy = true;
      line-numbers = true;
      true-color = "always";
    };
  };

  programs.lazygit.enable = true;

  programs.gitui.enable = false;
}
