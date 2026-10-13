{
  window-rule = [
    {
      geometry-corner-radius._args = [20.0 20.0 20.0 20.0];
      clip-to-geometry = true;
      draw-border-with-background = false;
    }
    {
      match._props = {is-floating = true;};
      shadow = {};
    }
    {
      match._props = {is-window-cast-target = true;};
      focus-ring = {
        active-color = "#f38ba8";
        inactive-color = "#7d0d2d";
      };
      border.inactive-color = "#7d0d2d";
      shadow.color = "#7d0d2d70";
      tab-indicator = {
        active-color = "#f38ba8";
        inactive-color = "#7d0d2d";
      };
    }
    {
      match._props = {app-id = "org.telegram.desktop";};
      block-out-from = "screencast";
    }
    {
      match._props = {app-id = "app.drey.PaperPlane";};
      block-out-from = "screencast";
    }
    {
      match = [
        {_props = {app-id = "zen";};}
        {_props = {app-id = "helium";};}
        {_props = {app-id = "firefox";};}
        {_props = {app-id = "chromium-browser";};}
        {_props = {app-id = "xdg-desktop-portal-gtk";};}
      ];
      scroll-factor = 0.9;
    }
    {
      match = [
        {_props = {app-id = "zen";};}
        {_props = {app-id = "helium";};}
        {_props = {app-id = "firefox";};}
        {_props = {app-id = "chromium-browser";};}
        {_props = {app-id = "edge";};}
      ];
      open-maximized = true;
    }
    {
      match._props = {title = "^Picture-in-Picture$";};
      open-floating = true;
      default-floating-position._props = {
        x = 32;
        y = 32;
        relative-to = "bottom-right";
      };
      default-column-width.fixed = 480;
      default-window-height.fixed = 270;
    }
    {
      match._props = {title = "Discord Popout";};
      open-floating = true;
      default-floating-position._props = {
        x = 32;
        y = 32;
        relative-to = "bottom-right";
      };
    }
    {
      match._props = {app-id = "pavucontrol";};
      open-floating = true;
    }
    {
      match._props = {app-id = "pavucontrol-qt";};
      open-floating = true;
    }
    {
      match._props = {app-id = "com.saivert.pwvucontrol";};
      open-floating = true;
    }
    {
      match._props = {app-id = "io.github.fsobolev.Cavalier";};
      open-floating = true;
    }
    {
      match._props = {app-id = "dialog";};
      open-floating = true;
    }
    {
      match._props = {app-id = "popup";};
      open-floating = true;
    }
    {
      match._props = {app-id = "task_dialog";};
      open-floating = true;
    }
    {
      match._props = {app-id = "gcr-prompter";};
      open-floating = true;
    }
    {
      match._props = {app-id = "file-roller";};
      open-floating = true;
    }
    {
      match._props = {app-id = "org.gnome.FileRoller";};
      open-floating = true;
    }
    {
      match._props = {app-id = "nm-connection-editor";};
      open-floating = true;
    }
    {
      match._props = {app-id = "blueman-manager";};
      open-floating = true;
    }
    {
      match._props = {app-id = "xdg-desktop-portal-gtk";};
      open-floating = true;
    }
    {
      match._props = {app-id = "org.kde.polkit-kde-authentication-agent-1";};
      open-floating = true;
    }
    {
      match._props = {app-id = "swayimg";};
      open-floating = true;
    }
    {
      match._props = {app-id = "pinentry";};
      open-floating = true;
    }
    {
      match._props = {title = "Progress";};
      open-floating = true;
    }
    {
      match._props = {title = "File Operations";};
      open-floating = true;
    }
    {
      match._props = {title = "Confirm";};
      open-floating = true;
    }
    {
      match._props = {title = "Error";};
      open-floating = true;
    }
  ];

  layer-rule = [];
}
