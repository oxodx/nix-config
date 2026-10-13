{pkgs, ...}: {
  users.users.oxod.packages = [pkgs.firefox];
}
