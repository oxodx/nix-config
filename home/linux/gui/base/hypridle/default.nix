{ ... }:
{
  xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
  services.hypridle.enable = true;
}
