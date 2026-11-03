import qs.services
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.theme

PanelWindow {
  id: root

  WlrLayershell.namespace: "shell:notifications"
  exclusionMode: ExclusionMode.Ignore
  color: "transparent"
  //color: Qt.alpha(Appearance.colors.m3onSurface, 0.0)

  anchors {
    left: true
    top: true
    bottom: true
    right: true
  }

  property var bar: null
  readonly property var focusedMonitor: Hyprland.focusedMonitor
  readonly property bool isFocused: focusedMonitor === null || screen?.name === focusedMonitor.name
  readonly property bool fullscreen: Hyprland.monitorFor(root.screen)?.activeWorkspace?.hasFullscreen ?? false

  property Component notifComponent: DaemonNotification {}

  NotificationDisplay {
    id: display

    anchors.fill: parent

    stack.y: root.bar.height + 8
    stack.x: 10
  }

  visible: display.stack.children.length != 0

  mask: Region {
    item: display.stack
  }
  onIsFocusedChanged: {
    if (isFocused)
      NotificationService.overlay = root;
  }

  Component.onCompleted: {
    if (isFocused)
      NotificationService.overlay = root;
  }

  Connections {
    target: NotificationService

    function onNotif(notification) {
      if (root.isFocused)
        display.addNotification(notification);
    }

    function onShowAll(notifications) {
      if (root.isFocused)
        display.addSet(notifications);
    }

    function onDismissAll() {
      display.dismissAll();
    }

    function onDiscardAll() {
      display.discardAll();
    }
  }
}
