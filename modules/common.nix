{ config, pkgs, lib, ... }: {
  config = {
    my.home-manager.enabled-users = [ "oxod" ];

    i18n = {
      defaultLocale = "en_US.UTF-8";
      supportedLocales = [ "en_US.UTF-8/UTF-8" ];
    };
    time.timeZone = "Europe/Amsterdam";
    services.xserver.xkb.layout = "us";

    services.xserver.enable = true;
    services.displayManager.sddm.enable = false;
    services.displayManager.gdm.enable = true;
    services.displayManager.gdm.wayland = true;
    services.desktopManager.plasma6.enable = true;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      lowLatency.enable = true;
    };
    hardware.bluetooth.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    nix = {
      daemonCPUSchedPolicy = "idle";
      extraOptions = "experimental-features = nix-command flakes";
      autoOptimiseStore = true;
    };

    networking = {
      networkmanager.enable = true;
      networkmanager.wifi.backend = "iwd";
      resolvconf.dnsExtensionMechanism = false;
    };

    services.avahi = {
      enable = true;
      publish.enable = true;
      publish.addresses = true;
    };

    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
      challengeResponseAuthentication = false;
      banner = "This computer system may not be used for any perpose.\nBe gay, do crime.\n";
    };

    services.fstrim.enable = true;

    nix.settings.allowed-users = [ "@users" ];
    security.sudo.execWheelOnly = true;

    environment.systemPackages = with pkgs; [
      bash
      wget
      curl
      nano
      ripgrep
      fd
      killall
      traceroute
      dnsutils
    ];

    assertions = [
      {
        assertion = config.hardware.cpu.amd.updateMicrocode || config.hardware.cpu.intel.updateMicrocode;
        message = "updateMicrocode should be set for amd or intel";
      }
    ];
  };
}
