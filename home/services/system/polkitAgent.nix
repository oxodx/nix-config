{pkgs, ...}: {
  users.users.oxod.packages = with pkgs; [polkit_gnome];

  systemd.user.services.polkit-gnome = {
    description = "GNOME PolicyKit Agent";
    wantedBy = ["graphical-session.target"];
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };
  };
}
