{
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      "$scheme" = "https://starship.rs/config-schema.json";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      aws.disabled = true;
      gcloud.disabled = true;

      kubernetus = {
        symbol = "⛵";
        disabled = false;
      };
      os.disabled = false;
    };
  };
}
