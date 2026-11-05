{pkgs, ...}: {
  # Neovim is configured by the standalone config in nvim-config/. The same folder installs
  # on Windows through nvim-config/install.ps1, so there is only one copy to maintain.
  xdg.configFile."nvim".source = ../../nvim-config;

  users.users.oxod.packages = with pkgs; [
    neovim
    ripgrep
    fd
    lazygit
    wl-clipboard
    gnumake
    gcc
    stylua
    shfmt
    prettier
    clang-tools
    python3Packages.yapf
    jdk21
    maven
    gradle
  ];
}
