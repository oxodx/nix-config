{pkgs, ...}: {
  # Unity Hub provides the FHS environment required by Unity 6 editors on NixOS.
  # Install the current Unity 6.3 LTS editor release from the Hub after signing in.
  users.users.oxod.packages = [pkgs.unityhub];
}
