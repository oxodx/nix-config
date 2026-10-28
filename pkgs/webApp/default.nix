{
  pkgs,
  lib,
}: {
  name,
  url,
  title ? name,
  width ? 800,
  height ? 600,
  fullscreen ? false,
  privateMode ? false,
  pythonPackages ? pkgs.python3Packages,
  extraPythonPackages ? ps: [],
  qt ? false,
  gtk ? true,
  icon ? null,
  iconHash ? "",
  ignoreSslErrors ? false,
  userAgent ? "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
  desktopName ? title,
  genericName ? "Web Application",
  categories ? ["Network" "WebBrowser"],
}: let
  pywebview = pythonPackages.pywebview;

  dependencies = ps:
    [
      pywebview
    ]
    ++ (
      if qt
      then [ps.pyqt5]
      else []
    )
    ++ (
      if gtk
      then [ps.pygobject3]
      else []
    )
    ++ (extraPythonPackages ps);

  pythonEnv = pythonPackages.python.withPackages dependencies;

  fetchIcon = icon:
    if lib.isString icon && (lib.hasPrefix "http://" icon || lib.hasPrefix "https://" icon)
    then
      if iconHash != ""
      then
        pkgs.fetchurl {
          url = icon;
          hash = iconHash;
        }
      else throw "webApp: fetching icon from '${icon}' requires iconHash to be set"
    else icon;

  processedIcon =
    if icon != null
    then fetchIcon icon
    else null;

  appScript = pkgs.writeText "webview-app-${name}.py" ''
    import webview
    import os
    import sys

    ${lib.optionalString ignoreSslErrors ''
      webview.settings["IGNORE_SSL_ERRORS"] = True
    ''}
    def main():
      name = os.environ.get("WEBVIEW_NAME", "${name}")
      url = os.environ.get("WEBVIEW_URL", "${url}")
      title = os.environ.get("WEBVIEW_TITLE", "${title}")
      width = int(os.environ.get("WEBVIEW_WIDTH", "${toString width}"))
      height = int(os.environ.get("WEBVIEW_HEIGHT", "${toString height}"))
      fullscreen = os.environ.get("WEBVIEW_FULLSCREEN", "0") == "1"
      user_agent = os.environ.get("WEBVIEW_USER_AGENT", "${userAgent}")

      # Try to set application name for better desktop integration (taskbar icon)
      try:
        if "${
      if qt
      then "1"
      else "0"
    }" == "1":
          from PyQt5.QtCore import QCoreApplication
          QCoreApplication.setApplicationName(name)
        else:
          from gi.repository import GLib
          GLib.set_prgname(name)
          GLib.set_application_name(name)
      except Exception as e:
        print(f"Warning: Could not set application name: {e}", file=sys.stderr)

      webview.create_window(title, url, width=width, height=height, fullscreen=fullscreen)
      webview.start(user_agent=user_agent, private_mode=${
      if privateMode
      then "True"
      else "False"
    })

    if __name__ == "__main__":
      main()
  '';

  executable = pkgs.writeShellScriptBin name ''
    # Set up environment for GTK/WebKitGTK
    ${lib.optionalString gtk ''
      # GObject Introspection typelibs
      export GI_TYPELIB_PATH="${lib.makeSearchPath "lib/girepository-1.0" [
        pkgs.gtk3
        pkgs.webkitgtk_4_1
        pkgs.glib.out
        pkgs.pango.out
        pkgs.gdk-pixbuf
        pkgs.atk
        pkgs.libsoup_3
        pkgs.cairo
        pkgs.gobject-introspection.out
        pkgs.harfbuzz.out
        pkgs.freetype.out
      ]}"
      # GSettings schemas and other data
      export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS"
      # GIO TLS backend (required for HTTPS in WebKitGTK)
      export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules''${GIO_EXTRA_MODULES:+:$GIO_EXTRA_MODULES}"
      export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
    ''}

    # Set up environment for Qt (if used)
    ${lib.optionalString qt ''
      export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins"
    ''}

    # App configuration via environment variables
    export WEBVIEW_NAME="${name}"
    export WEBVIEW_URL="${url}"
    export WEBVIEW_TITLE="${title}"
    export WEBVIEW_WIDTH="${toString width}"
    export WEBVIEW_HEIGHT="${toString height}"
    export WEBVIEW_FULLSCREEN="${
      if fullscreen
      then "1"
      else "0"
    }"
    export WEBVIEW_USER_AGENT="${userAgent}"

    # Run the python script with the bundled environment
    exec ${pythonEnv}/bin/python3 ${appScript} "$@"
  '';

  desktopItem = pkgs.makeDesktopItem {
    inherit name categories;
    exec = "${executable}/bin/${name}";
    icon =
      if processedIcon != null
      then processedIcon
      else "web-browser";
    desktopName = desktopName;
    genericName = genericName;
  };
in
  pkgs.symlinkJoin {
    inherit name;
    paths = [
      executable
      desktopItem
    ];
  }
