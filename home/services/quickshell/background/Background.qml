pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components

Loader {
  asynchronous: true
  active: true

  sourceComponent: Variants {
    model: Quickshell.screens

    StyledWindow {
      id: win

      required property ShellScreen modelData

      screen: modelData
      name: "background"
      WlrLayershell.exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Background

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }

      Wallpaper {}
      DesktopClock {}
    }
  }
}
