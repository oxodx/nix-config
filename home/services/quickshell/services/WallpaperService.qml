pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import QtCore
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules.background

Singleton {
  id: root

  readonly property url pictures: "file://" + Quickshell.env("HOME") + "/Pictures"
  readonly property url source: String(settings.wallpaper) !== "" ? settings.wallpaper : String(pictures) + "/wallpaper.png"
  property alias directory: settings.directory
  property bool opened: false
  property bool downloading: false
  property string error: ""

  readonly property var videoExtensions: ["mp4", "m4v", "mkv", "webm", "mov", "avi"]

  // The wallpaper is one global image for now, so every monitor shares it.
  function pathFor(screenName: string): string {
    try {
      return decodeURIComponent(String(root.source).replace(/^file:\/\//, ""));
    } catch (e) {
      return "";
    }
  }

  function isVideo(path: string): bool {
    const dot = path.lastIndexOf(".");
    return dot >= 0 && root.videoExtensions.indexOf(path.substring(dot + 1).toLowerCase()) >= 0;
  }

  // A still image path to show, or "" for video wallpapers (no still frame yet).
  function imageFor(path: string): string {
    return path !== "" && !root.isVideo(path) ? path : "";
  }

  function videoFor(screenName: string): bool {
    return root.isVideo(root.pathFor(screenName));
  }

  // Kept for the mpvpaper surface, which raises widgets above it. Nothing to
  // restack while the wallpaper is drawn inside the shell.
  function restackWidgets(): void {}

  function open(): void { opened = true; }
  function close(): void { opened = false; }
  function apply(image: url): void {
    settings.wallpaper = image;
    settings.sync();
  }

  function fetchRandom(): void {
    if (downloading) return;
    error = "";
    downloading = true;
    download.command = ["/run/current-system/sw/bin/quickshell-wallpaper", String(source)];
    download.running = true;
    downloadTimeout.restart();
    startupCheck.restart();
  }

  function cancelDownload(): void {
    downloading = false;
    download.running = false;
    downloadTimeout.stop();
    startupCheck.stop();
    error = "";
  }

  Process {
    id: download
    onStarted: startupCheck.stop()
    stdout: StdioCollector { id: downloadOutput }
    onExited: code => {
      if (!root.downloading) return;
      try {
        if (code !== 0) throw new Error("Wallpaper download failed; try again");
        const result = JSON.parse(downloadOutput.text);
        if (result.error) throw new Error(result.error);
        if (!result.image || !result.directory) throw new Error("Invalid wallpaper response");
        root.directory = result.directory;
        downloadedImage.source = result.image;
        // A cached image may already be ready and emit no status change.
        if (downloadedImage.status === Image.Ready) root.finishDownload();
      } catch (failure) {
        root.error = String(failure.message ?? failure);
        root.downloading = false;
        downloadTimeout.stop();
      }
    }
  }

  function finishDownload(): void {
    apply(downloadedImage.source);
    downloading = false;
    downloadTimeout.stop();
  }

  Image {
    id: downloadedImage
    visible: false
    asynchronous: true
    sourceSize: Qt.size(512, 288)
    onStatusChanged: {
      if (!root.downloading) return;
      if (status === Image.Ready) root.finishDownload();
      else if (status === Image.Error) {
        root.error = "Downloaded image could not be opened; try again";
        root.downloading = false;
        downloadTimeout.stop();
      }
    }
  }

  Timer {
    id: downloadTimeout
    interval: 20000
    onTriggered: {
      root.downloading = false;
      download.running = false;
      root.error = "Wallpaper download timed out; try again";
    }
  }

  Timer {
    id: startupCheck
    interval: 1500
    onTriggered: {
      if (root.downloading && !download.running) {
        root.downloading = false;
        downloadTimeout.stop();
        root.error = "Wallpaper downloader is unavailable; rebuild NixOS and try again";
      }
    }
  }

  Settings {
    id: settings
    location: `file://${Quickshell.env("XDG_CONFIG_HOME") || Quickshell.env("HOME") + "/.config"}/quickshell-wallpaper.ini`
    category: "wallpaper"
    property url wallpaper: ""
    property url directory: root.pictures
  }

  IpcHandler {
    target: "wallpaper"
    function open(): void { root.open(); }
    function close(): void { root.close(); }
    function toggle(): void { root.opened = !root.opened; }
    function current(): string { return String(root.source); }
  }

  LazyLoader {
    active: root.opened
    PanelWindow {
      visible: true
      color: "transparent"
      implicitWidth: Math.min(860, (screen?.width ?? 1024) - 48)
      implicitHeight: Math.min(640, (screen?.height ?? 768) - 64)
      WlrLayershell.namespace: "shell:wallpaper"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      WallpaperPicker {
        anchors.fill: parent
        onDismissed: root.close()
      }
    }
  }
}
