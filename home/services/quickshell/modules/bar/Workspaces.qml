pragma ComponentBehavior: Bound

import qs.theme
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.modules.bar
import qs.components

FullwidthMouseArea {
  id: root
  required property var bar

  implicitWidth: row.implicitWidth + 12

  fillWindowWidth: true
  acceptedButtons: Qt.NoButton

  property int scrollAccumulator: 0

  onWheel: event => {
    event.accepted = true;
    let acc = scrollAccumulator - event.angleDelta.y;
    const sign = Math.sign(acc);
    acc = Math.abs(acc);

    const offset = sign * Math.floor(acc / 120);
    scrollAccumulator = sign * (acc % 120);

    if (offset == 0)
      return;

    const workspaces = root.visibleWorkspaces;
    const index = workspaces.findIndex(workspace => workspace.id === root.currentIndex);
    const target = Math.max(0, Math.min(workspaces.length - 1, index + offset));
    if (target != index)
      ShellIpc.focusWorkspace(workspaces[target].id);
  }

  readonly property var monitorWorkspaces: Hyprland.workspaces.values.filter(workspace => workspace.monitor?.name === bar.screen.name)
  readonly property var visibleWorkspaces: monitorWorkspaces.filter(workspace => workspace.id > 0).sort((a, b) => a.id - b.id)
  readonly property var activeWorkspace: monitorWorkspaces.find(workspace => workspace.active) ?? null
  readonly property int currentIndex: activeWorkspace?.id ?? 1
  visible: visibleWorkspaces.length > 0

  RowLayout {
    id: row
    spacing: 5
    anchors {
      fill: parent
      topMargin: 0
      margins: 5
    }

    Repeater {
      model: root.visibleWorkspaces

      FullwidthMouseArea {
        id: wsItem
        onPressed: ShellIpc.focusWorkspace(workspaceIndex)

        Layout.fillHeight: true
        implicitWidth: active ? 38 : 30

        fillWindowWidth: false
        hoverEnabled: true

        required property var modelData
        property int workspaceIndex: modelData.id
        property bool active: modelData.active

        property real animActive: active ? 1 : 0
        Behavior on animActive {
          NumberAnimation {
            duration: 150
          }
        }

        Pill {
          anchors.centerIn: parent
          height: 26
          width: parent.width
          shadowDy: 3
          pressed: wsItem.pressed
          fillColor: wsItem.active ? Appearance.colors.m3primary
                   : wsItem.containsMouse ? Appearance.colors.widgetActive
                   : Appearance.colors.widget
          outlineColor: Appearance.colors.ink
          borderWidth: 2
          ringWidth: 2
          ringColor: wsItem.active ? Qt.alpha(Appearance.colors.m3onPrimary, 0.4) : Qt.alpha(Appearance.colors.m3onSurface, 0.2)

          StyledText {
            anchors.centerIn: parent
            text: wsItem.workspaceIndex
            color: wsItem.active ? Appearance.colors.m3onPrimary : Appearance.colors.m3onSurfaceVariant
            font.pointSize: Appearance.font.size.smaller
            font.weight: wsItem.active ? Font.DemiBold : Font.Normal
          }
        }
      }
    }
  }
}
