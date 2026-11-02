pragma Singleton

import QtQuick
import Quickshell

// Edit Desktop state. The editor itself (EditStage, DesktopMenu) is not part of
// this snapshot, so editing is permanently off. The API is kept so the
// wallpaper layer and overlays can be wired up when the editor lands.
Singleton {
  id: root

  readonly property bool active: false
  readonly property real frameWidth: 0
  readonly property real cardRadius: 0

  function editing(screenName: string): bool { return false; }
  function progressFor(screenName: string): real { return 0; }
  function cardRect(width: real, height: real, uiScale: real): var {
    return { x: 0, y: 0, s: 1 };
  }
  function xFor(screenName: string, width: real, height: real, uiScale: real): real { return 0; }
  function yFor(screenName: string, width: real, height: real, uiScale: real): real { return 0; }
  function scaleFor(screenName: string, width: real, height: real, uiScale: real): real { return 1; }
  function select(name: string): void {}
  function openMenu(screenName: string, x: real, y: real): void {}
}
