{lib}: {
  buildJellyfinPlugin = import ./buildJellyfinPlugin.nix;
  jellyfinPlugins = import ./jellyfinPlugins.nix {inherit lib;};
}
