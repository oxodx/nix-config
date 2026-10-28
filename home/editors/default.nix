{pkgs, ...}: {
  imports = [
    ./nvim
    ./vscode
    ./zed
  ];

  users.users.oxod.packages = with pkgs; [jetbrains.idea];
}
