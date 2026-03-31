{
  pkgs,
  config,
  lib,
  ...
}:
let
  makeMsh =
    {
      name,
      port,
      mshPort,
      stopAfter ? 120,
    }:
    let
      mshBinary = pkgs.stdenv.mkDerivation {
        name = "msh";
        src = pkgs.fetchurl {
          url = "https://github.com/gekware/minecraft-server-hibernation/releases/download/v2.5.0/msh-v2.5.0-0876091-linux-amd64.bin";
          hash = "sha256:0lw735rzdg251s3zcbk0ahbrxchw9y98zg1a3wz4r0mp4c54yfmx";
        };
        phases = [
          "installPhase"
          "fixupPhase"
        ];
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        installPhase = ''
          mkdir -p $out/bin
          cp $src $out/bin/msh
          chmod +x $out/bin/msh
        '';
      };
      mshConfig = pkgs.writeText "msh-${name}-config.json" (
        builtins.toJSON {
          Server = {
            Folder = "/data/apps/minecraft/servers/${name}";
            FileName = "minecraft-server.jar";
            StopServer = "stop";
            StopServerAllowKill = 30;
          };
          Msh = {
            MshPort = mshPort;
            MshPortQuery = mshPort;
            EnableQuery = true;
            TimeBeforeStoppingEmptyServer = stopAfter;
            SuspendAllow = false;
            InfoHibernation = " §fserver status:\n §b§lHIBERNATING";
            InfoStarting = " §fserver status:\n §6§lWARMING UP";
            CheckForUpdates = false;
            Debug = 1;
          };
        }
      );
    in
    {
      systemd.services."msh-${name}" = {
        description = "Minecraft Server Hibernation (${name})";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "minecraft";
          Group = "minecraft";
          ExecStart = "${mshBinary}/bin/msh -c ${mshConfig}";
          WorkingDirectory = "/data/apps/minecraft/msh/${name}";
          Restart = "on-failure";
        };
      };
    };

  mshInstances = map makeMsh [
    {
      name = "survival01";
      port = 25571;
      mshPort = 25572;
    }
  ];
in
{
  imports = [
    ./servers/proxy
    ./servers/survival01
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    dataDir = "/data/apps/minecraft/servers";
  };

  systemd.tmpfiles.rules = [
    "d /data/apps/minecraft 0755 minecraft minecraft"
    "d /data/apps/minecraft/servers 0755 minecraft minecraft"
    "d /data/apps/minecraft/msh 0755 minecraft minecraft"
  ]
  ++ lib.concatMap (m: m.systemd.tmpfiles.rules) mshInstances;

  systemd.services = lib.mkMerge (map (m: m.systemd.services) mshInstances);

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "24h";
    ignoreIP = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
    ];
    jails = {
      sshd.enabled = false;
      minecraft = {
        enabled = true;
        filter = "minecraft";
        settings = {
          logpath = "/data/apps/minecraft/servers/logs/latest.log";
          port = "25565";
          maxretry = 2;
          findtime = "1m";
        };
      };
    };
  };

  environment.etc = {
    "fail2ban/filter.d/minecraft.conf".text = ''
      [Definition]
      failregex = ^<HOST>.*Lost connection$
      ignoreregex =
    '';
  };
}
