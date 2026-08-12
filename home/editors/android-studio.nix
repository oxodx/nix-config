{pkgs, ...}: {
  home.packages = with pkgs; [
    android-studio
  ];

  nixpkgs.config.android_sdk.accept_license = true;
}
