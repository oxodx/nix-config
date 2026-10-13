import QtQuick
import qs
import qs.components

Rectangle {
  id: root

  signal triggered

  property string icon
  property bool active: false
  property bool prominent: false
  property real buttonSize: prominent ? 48 : 40

  implicitWidth: prominent ? buttonSize + 14 : buttonSize
  implicitHeight: buttonSize
  color: prominent || active
    ? Appearance.colors.m3primaryContainer
    : mouse.containsMouse ? Appearance.colors.widgetActive : Appearance.colors.widget
  border.color: prominent || active ? Appearance.colors.m3tertiary : Appearance.colors.widgetOutline
  border.width: 1
  opacity: enabled ? 1 : 0.35

  MaterialIcon {
    anchors.centerIn: parent
    text: root.icon
    fill: root.prominent || root.active ? 1 : 0
    font.pointSize: root.prominent ? Appearance.font.size.extraLarge : Appearance.font.size.large
    color: root.prominent || root.active
      ? Appearance.colors.m3onPrimaryContainer
      : Appearance.colors.m3onSurface
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    enabled: root.enabled
    cursorShape: Qt.PointingHandCursor
    onClicked: root.triggered()
  }
}
