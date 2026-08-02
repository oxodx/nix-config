import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.utils

Rectangle {
  implicitWidth: row.implicitWidth
  implicitHeight: row.implicitHeight

  color: "transparent"

  Row {
    id: row
    anchors.fill: parent
    spacing: 8

    Repeater {
      model: 9

      Text {
        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
        text: index + 1
        color: isActive ? Colors.primary : (ws ? Colors.surfaceVariant : Colors.surfaceContainerHigh)
        font {
          pixelSize: 14
          bold: true
        }

        MouseArea {
          anchors.fill: parent
          onClicked: Hyprland.dispatch("workspace " + (index + 1))
        }
      }
    }
  }
}
