{ config, ... }:
let
  user = "glances";
  dataDir = "/data/apps/glances";
in
{
  users.groups.${user} = { };
  users.users.${user} = {
    group = user;
    home = dataDir;
    isSystemUser = true;
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 ${user} ${user}"
  ];

  virtualisation.oci-containers.containers = {
    glances = {
      hostname = "glances";
      image = "nicolargo/glances:latest-full";

      environment = {
        GLANCES_OPT = "-w";
      };

      volumes = [
        # Container runtime
        "/var/run/docker.sock:/var/run/docker.sock"

        # OS info
        "/etc/os-release:/etc/os-release:ro"

        # App data
        "${dataDir}:/app/data"

        # Host filesystem visibility
        "/proc:/host/proc:ro"
        "/sys:/host/sys:ro"
        "/:/rootfs:ro"
        "/run:/run:ro"

        # systemd service visibility via dbus
        "/run/dbus/system_bus_socket:/run/dbus/system_bus_socket"
        "/run/systemd:/run/systemd:ro"
      ];

      extraOptions = [
        "--pid=host" # See all host processes
        "--network=host" # Real network interface stats
        "--privileged" # Sensors, temps, disk SMART, etc.
        "--ipc=host" # Shared memory stats
      ];

      autoStart = true;
    };
  };
}
