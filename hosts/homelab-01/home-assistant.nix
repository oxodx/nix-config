{config, ...}: {
  services.home-assistant = {
    enable = true;
    configDir = "/var/lib/home-assistant";
    extraComponents = [
      "analytics"
      "default_config"
      "esphome"
      "my"
      "shopping_list"
      "wled"
      "tapo"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };

  networking.firewall.allowedTCPPorts = [config.services.home-assistant.config.http.server_port];
}
