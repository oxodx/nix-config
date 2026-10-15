import qs.theme
import QtQuick

Item {
  id: root

  property real from: 0.0
  property real to: 1.0
  property real value: 0.0
  property color fillColor: Appearance.colors.m3tertiary
  property color trackColor: Qt.alpha(Appearance.colors.m3tertiary, 0.22)
  property real thickness: 3
  property real cornerRadius: 0

  readonly property real progress: root.to === root.from ? 0 : Math.max(0, Math.min(1, (root.value - root.from) / (root.to - root.from)))

  implicitHeight: thickness
  implicitWidth: 200

  StyledRect {
    id: grooveFill

    anchors {
      left: groove.left
      top: groove.top
      bottom: groove.bottom
    }

    radius: root.cornerRadius
    color: root.fillColor
    width: root.width * root.progress
  }

  StyledRect {
    id: groove

    anchors {
      left: parent.left
      right: parent.right
      verticalCenter: parent.verticalCenter
    }

    height: root.thickness
    color: root.trackColor
    radius: root.cornerRadius
  }
}
