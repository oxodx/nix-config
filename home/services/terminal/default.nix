{
  mylib,
  config,
  ...
}: {
  imports = mylib.scanPaths ./.;

  environment.sessionVariables = {
    LESSHISTFILE = "${config.users.users.oxod.home}/.cache/less/history";
    LESKEY = "${config.users.users.oxod.home}/.config/less/lesskey";

    EDITOR = "nvim";
    DIRENV_LOG_FORMAT = "";
  };
}
