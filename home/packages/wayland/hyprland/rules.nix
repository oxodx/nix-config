''
  windowrule {
    name = telegram-no-screenshare
    match:class = ^(org.telegram.desktop)$
    no_screen_share = true
  }

  windowrule {
    name = paperplane-no-screenshare
    match:class = ^(app.drey.PaperPlane)$
    no_screen_share = true
  }

  windowrule {
    name = zen-maximize
    match:class = ^(zen)$
    maximize = true
  }

  windowrule {
    name = helium-maximize
    match:class = ^(helium)$
    maximize = true
  }

  windowrule {
    name = firefox-maximize
    match:class = ^(firefox)$
    maximize = true
  }

  windowrule {
    name = chromium-maximize
    match:class = ^(chromium-browser)$
    maximize = true
  }

  windowrule {
    name = edge-maximize
    match:class = ^(edge)$
    maximize = true
  }

  windowrule {
    name = picture-in-picture
    match:title = ^Picture-in-Picture$
    float = true
    size = 480 270
    center = true
  }

  windowrule {
    name = discord-popout
    match:title = Discord Popout
    float = true
  }

  windowrule {
    name = pavucontrol-float
    match:class = ^(pavucontrol)$
    float = true
  }

  windowrule {
    name = pavucontrol-qt-float
    match:class = ^(pavucontrol-qt)$
    float = true
  }

  windowrule {
    name = pwvucontrol-float
    match:class = ^(com.saivert.pwvucontrol)$
    float = true
  }

  windowrule {
    name = cavalier-float
    match:class = ^(io.github.fsobolev.Cavalier)$
    float = true
  }

  windowrule {
    name = dialog-float
    match:class = ^(dialog)$
    float = true
  }

  windowrule {
    name = popup-float
    match:class = ^(popup)$
    float = true
  }

  windowrule {
    name = task-dialog-float
    match:class = ^(task_dialog)$
    float = true
  }

  windowrule {
    name = gcr-prompter-float
    match:class = ^(gcr-prompter)$
    float = true
  }

  windowrule {
    name = file-roller-float
    match:class = ^(file-roller)$
    float = true
  }

  windowrule {
    name = gnome-file-roller-float
    match:class = ^(org.gnome.FileRoller)$
    float = true
  }

  windowrule {
    name = nm-connection-editor-float
    match:class = ^(nm-connection-editor)$
    float = true
  }

  windowrule {
    name = blueman-manager-float
    match:class = ^(blueman-manager)$
    float = true
  }

  windowrule {
    name = portal-gtk-float
    match:class = ^(xdg-desktop-portal-gtk)$
    float = true
  }

  windowrule {
    name = polkit-agent-float
    match:class = ^(org.kde.polkit-kde-authentication-agent-1)$
    float = true
  }

  windowrule {
    name = swayimg-float
    match:class = ^(swayimg)$
    float = true
  }

  windowrule {
    name = pinentry-float
    match:class = ^(pinentry)$
    float = true
  }

  windowrule {
    name = progress-float
    match:title = ^Progress$
    float = true
  }

  windowrule {
    name = file-operations-float
    match:title = ^File Operations$
    float = true
  }

  windowrule {
    name = confirm-float
    match:title = ^Confirm$
    float = true
  }

  windowrule {
    name = error-float
    match:title = ^Error$
    float = true
  }
''
