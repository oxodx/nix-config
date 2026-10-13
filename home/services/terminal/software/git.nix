{
  config,
  pkgs,
  ...
}: let
  configFile = "git/config";
  ignoreFile = "git/ignore";
  toINI = (pkgs.formats.ini {}).generate;
in {
  users.users.oxod.packages = with pkgs; [
    git
    delta
    gnupg
    git-lfs
    peco
  ];

  xdg.configFile."${configFile}".source = toINI "config" {
    alias = {
      af = "!git add $(git ls-files -m -o --exclude-standard | fzf -m)";
      br = "branch";
      ca = "commit -am";
      co = "checkout";
      d = "diff";
      df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
      "edit-unmerged" = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; hx `f`";
      fuck = "commit --amend -m";
      hist = "log --pretty=format:\"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)\" --graph --date=relative --decorate --all";
      llog = "log --graph --name-status --pretty=format:\"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset\" --date=relative";
      pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
      ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
      st = "status";
    };
    commit = {
      gpgSign = "true";
    };
    core = {
      editor = "nvim";
      pager = "${pkgs.delta}/bin/delta";
      whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      excludesFile = "${config.xdg.configHome}/${ignoreFile}";
    };
    delta = {
      features = "unobtrusive-line-numbers decorations";
      navigate = "true";
      "side-by-side" = "true";
      "true-color" = "never";
    };
    "delta-decorations" = {
      "commit-decoration-style" = "bold grey box ul";
      "file-decoration-style" = "ul";
      "file-style" = "bold blue";
      "hunk-header-decoration-style" = "box";
    };
    "delta-unobtrusive-line-numbers" = {
      "line-numbers" = "true";
      "line-numbers-left-format" = "{nm:>4}│";
      "line-numbers-left-style" = "grey";
      "line-numbers-right-format" = "{np:>4}│";
      "line-numbers-right-style" = "grey";
    };
    diff = {
      colorMoved = "default";
    };
    "filter-lfs" = {
      clean = "git-lfs clean -- %f";
      process = "git-lfs filter-process";
      required = "true";
      smudge = "git-lfs smudge -- %f";
    };
    gpg = {
      format = "openpgp";
    };
    "gpg-openpgp" = {
      program = "${pkgs.gnupg}/bin/gpg";
    };
    init = {
      defaultBranch = "main";
    };
    interactive = {
      diffFilter = "${pkgs.delta}/bin/delta --color-only";
    };
    merge = {
      conflictstyle = "diff3";
      stat = "true";
    };
    pull = {
      ff = "only";
    };
    push = {
      autoSetupRemote = "true";
      default = "current";
    };
    rebase = {
      autoSquash = "true";
      autoStash = "true";
    };
    repack = {
      usedeltabaseoffset = "true";
    };
    rerere = {
      autoupdate = "true";
      enabled = "true";
    };
    tag = {
      gpgSign = "true";
    };
    user = {
      email = "git@oxod.nl";
      name = "oxod";
    };
  };

  xdg.configFile."${ignoreFile}".text = ''
    *~
    *.swp
    *result*
    .direnv
    node_modules
    .opencode/
    .codex/
    AGENTS.md
  '';
}
