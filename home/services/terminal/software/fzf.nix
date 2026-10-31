{pkgs, ...}: {
  users.users.oxod.packages = with pkgs; [fzf];

  xdg.configFile = {
    "fish/conf.d/fzf.fish".source = "${pkgs.fzf}/share/fzf/key-bindings.fish";

    "fish/conf.d/fzf-extra.fish".text = ''
      set -gx FZF_DEFAULT_OPTS "--reverse --height 40% --border"
    '';
  };
}
