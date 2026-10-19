pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.launcher
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

Singleton {
  id: root
  function open(): void { persist.launcherOpen = true; }
  function close(): void { persist.launcherOpen = false; }
  function toggle(): void { persist.launcherOpen = !persist.launcherOpen; }
  PersistentProperties {
    id: persist
    property bool launcherOpen: false
  }

  IpcHandler {
    target: "launcher"

    function open(): void {
      root.open();
    }

    function close(): void {
      root.close();
    }

    function toggle(): void {
      root.toggle();
    }
  }

  LazyLoader {
    id: loader
    active: persist.launcherOpen

    PanelWindow {
      id: launcherWindow
      visible: true
      color: "transparent"
      implicitWidth: 560
      implicitHeight: content.height
      WlrLayershell.namespace: "shell:launcher"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      LaunchContent {
        id: content
        maximumHeight: Math.max(240, launcherWindow.screen.height - 80)
        anchors.centerIn: parent
        onDismissed: persist.launcherOpen = false
      }
    }
  }

  function init() {
  }
}
