{pkgs, ...}: {
  imports = [
    ./vscode
    ./zed
  ];

  users.users.oxod.packages = with pkgs; [
    jetbrains.idea
  ];
}
