import QtQuick
import qs.theme

Item {
  id: root
  property color backgroundColor: Appearance.colors.m3onSurfaceVariant
  property real backgroundOpacity: 1.0
  property alias innerBorderColor: center.border.color
  property alias innerX: center.x
  property alias innerY: center.y
  property alias innerW: center.width
  property alias innerH: center.height

  Rectangle {
    id: center
    border.color: Appearance.colors.m3onSurface
    border.width: 2
    color: "transparent"
  }

  Rectangle {
    color: root.backgroundColor
    opacity: backgroundOpacity

    anchors {
      top: parent.top
      left: parent.left
      right: parent.right
      bottom: center.top
    }
  }

  Rectangle {
    color: root.backgroundColor
    opacity: backgroundOpacity

    anchors {
      top: center.bottom
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }
  }

  Rectangle {
    color: root.backgroundColor
    opacity: backgroundOpacity

    anchors {
      top: center.top
      left: parent.left
      right: center.left
      bottom: center.bottom
    }
  }

  Rectangle {
    color: root.backgroundColor
    opacity: backgroundOpacity

    anchors {
      top: center.top
      left: center.right
      right: parent.right
      bottom: center.bottom
    }
  }
}
