pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs
import qs.bar
import qs.components

FullwidthMouseArea {
  id: root
  required property var bar
  property int wsCount: 10

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

    if (offset != 0) {
      const targetWorkspace = Math.max(1, Math.min(wsCount, currentIndex + offset));
      if (targetWorkspace != currentIndex)
        NiriState.focusWorkspace(bar.screen.name, targetWorkspace);
    }
  }

  readonly property var monitorWorkspaces: NiriState.workspaces.filter(workspace => workspace.output == bar.screen.name)
  readonly property var visibleWorkspaces: monitorWorkspaces.filter(workspace => workspace.idx <= wsCount).sort((a, b) => a.idx - b.idx)
  readonly property var activeWorkspace: monitorWorkspaces.find(workspace => workspace.is_active) ?? null
  readonly property int currentIndex: activeWorkspace?.idx ?? 1
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
        onPressed: NiriState.focusWorkspace(root.bar.screen.name, workspaceIndex)

        Layout.fillHeight: true
        implicitWidth: active ? 38 : 30

        fillWindowWidth: false

        required property var modelData
        property int workspaceIndex: modelData.idx
        property bool active: modelData.is_active

        property real animActive: active ? 1 : 0
        Behavior on animActive {
          NumberAnimation {
            duration: 150
          }
        }

        StyledRect {
          anchors.centerIn: parent
          height: 30
          width: parent.width
          radius: 2
          border.color: wsItem.active ? Appearance.colors.widgetOutlineSeparate : "transparent"
          border.width: 1
          color: Appearance.interpolateColors(wsItem.animActive, "transparent", Appearance.colors.widgetActive)

          StyledText {
            anchors.centerIn: parent
            text: wsItem.workspaceIndex
            color: wsItem.active ? "white" : "#b8ffffff"
            font.pointSize: Appearance.font.size.smaller
            font.weight: wsItem.active ? Font.DemiBold : Font.Normal
          }
        }
      }
    }
  }
}
