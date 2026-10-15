import QtQuick
import qs.theme

SkewedSurface {
  id: root
  signal triggered
  property string icon
  property string label: ""
  property bool active: false
  property real iconSize: Appearance.font.size.large
  property real disabledOpacity: 0.4
  property int transitionDuration: 150
  readonly property color contentColor: active ? Appearance.colors.m3onPrimaryContainer : Appearance.colors.m3onSurface

  implicitWidth: 40
  implicitHeight: 40
  slantLeft: true
  slantRight: true
  slant: 0
  fillColor: active ? Appearance.colors.m3primaryContainer : mouse.containsMouse ? Appearance.colors.widgetActive : Appearance.colors.widget
  outlineColor: active ? Appearance.colors.m3tertiary : Appearance.colors.widgetOutline
  shadowColor: "transparent"
  opacity: enabled ? 1 : disabledOpacity

  Behavior on fillColor {
    ColorAnimation {
      duration: root.transitionDuration
    }
  }

  Behavior on outlineColor {
    ColorAnimation {
      duration: root.transitionDuration
    }
  }

  Column {
    anchors.centerIn: parent
    spacing: 2

    MaterialIcon {
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.icon
      fill: root.active ? 1 : 0
      color: root.contentColor
      font.pointSize: root.iconSize
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
