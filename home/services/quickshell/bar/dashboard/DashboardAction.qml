import QtQuick
import qs
import qs.components

SkewedSurface {
  id: root

  signal triggered

  property string icon
  property string label
  property bool active: false

  implicitWidth: 102
  implicitHeight: 62
  slantLeft: true
  slantRight: true
  slant: 10
  fillColor: active ? Appearance.colors.m3primaryContainer : mouse.containsMouse ? Appearance.colors.widgetActive : Appearance.colors.widget
  outlineColor: active ? Appearance.colors.m3tertiary : Appearance.colors.widgetOutline
  shadowColor: "transparent"
  opacity: enabled ? 1 : 0.4
  Behavior on fillColor { ColorAnimation { duration: 150 } }
  Behavior on outlineColor { ColorAnimation { duration: 150 } }

  Column {
    anchors.centerIn: parent
    spacing: 2

    MaterialIcon {
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.icon
      fill: root.active ? 1 : 0
      color: root.active ? Appearance.colors.m3onPrimaryContainer : Appearance.colors.m3onSurface
      font.pointSize: Appearance.font.size.large
    }

    StyledText {
      visible: root.label !== ""
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.label
      color: root.active ? Appearance.colors.m3onPrimaryContainer : Appearance.colors.m3onSurfaceVariant
      font.pointSize: Appearance.font.size.smaller
    }
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.triggered()
  }
}
