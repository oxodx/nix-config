{
  pkgs,
  mylib,
  config,
  inputs,
  ...
}: {
  imports = mylib.scanPaths ./.;

  home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
    rtk
    herdr
  ];
}
