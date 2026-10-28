{
  # Package builders are functions, so they belong in lib rather than packages.
  mkWebApp = pkgs: pkgs.callPackage ../pkgs/webApp {};
}
