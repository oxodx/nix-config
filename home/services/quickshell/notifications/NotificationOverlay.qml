import QtQuick
import Quickshell
import Quickshell.Wayland
import qs

PanelWindow {
  id: root

  WlrLayershell.namespace: "shell:notifications"
  exclusionMode: ExclusionMode.Ignore
  color: "transparent"
  //color: "#30606000"

  anchors {
    left: true
    top: true
    bottom: true
    right: true
  }

  property var bar: null
  readonly property bool isFocused: screen?.name == NiriState.focusedOutput || NiriState.focusedOutput === ""
  //property var fullscreen: Hyprland.monitorFor(root.screen)?.activeWorkspace?.hasFullscreen ?? false

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
      NotificationManager.overlay = root;
  }

  Component.onCompleted: {
    if (isFocused)
      NotificationManager.overlay = root;
  }

  Connections {
    target: NotificationManager

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
