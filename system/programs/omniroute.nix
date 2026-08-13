{
  ...
}: {
  # https://github.com/diegosouzapw/OmniRoute
  # Free AI gateway. Served at http://localhost:20128 (dashboard + /v1 API).
  #
  # NixOS-only module (virtualisation.oci-containers is a system option).
  # The underscore prefix keeps it out of home-manager's scanPaths.
  # Started/stopped on demand by the `claude` wrapper (see
  # home/programs/agents/claude/default.nix), so it only runs while claude is open.
  virtualisation.oci-containers.containers.omniroute = {
    image = "diegosouzapw/omniroute:latest";
    autoStart = false;
    ports = [
      "127.0.0.1:20128:20128"
    ];
    volumes = [
      "omniroute-data:/app/data"
    ];
    extraOptions = [
      # Allow SQLite WAL checkpointing to finish on stop
      "--stop-timeout"
      "40"
    ];
    environment = {
      OMNIROUTE_MEMORY_MB = "2048";
    };
  };

  # Let the user's claude wrapper start/stop the gateway without a password.
  security.sudo.extraRules = [
    {
      users = [ "oxod" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/systemctl start podman-omniroute";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/systemctl stop podman-omniroute";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
