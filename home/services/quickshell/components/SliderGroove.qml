import QtQuick

Item {
  id: root
  property color trackColor: "transparent"
  property color fillColor: "transparent"
  property color outlineColor: "transparent"
  property color peakColor: "transparent"
  property color warningColor: "#60ffa800"
  property color warningMarkerColor: "#60eeffff"
  property real fillWidth: 0
  property real peakWidth: 0
  property real warningStart: -1
  property real cornerRadius: 0
  implicitWidth: 200
  implicitHeight: 7

  Rectangle {
    anchors.fill: parent
    color: root.trackColor
    radius: root.cornerRadius
  }

  Rectangle {
    visible: root.warningStart >= 0
    x: Math.max(0, root.warningStart)
    width: Math.max(0, root.width - x)
    height: root.height
    topRightRadius: root.cornerRadius
    bottomRightRadius: root.cornerRadius
    color: root.warningColor
  }

  Rectangle {
    visible: root.warningStart >= 0
    x: root.warningStart
    y: root.height
    width: 1
    height: root.height
    color: root.warningMarkerColor
  }

  Rectangle {
    width: Math.max(0, Math.min(root.width, root.fillWidth))
    height: root.height
    radius: root.cornerRadius
    color: root.fillColor
  }

  Rectangle {
    width: Math.max(0, Math.min(root.width, root.peakWidth))
    height: root.height
    radius: root.cornerRadius
    color: root.peakColor
  }

  Rectangle {
    anchors.fill: parent
    color: "transparent"
    border.color: root.outlineColor
    border.width: root.outlineColor.a > 0 ? 1 : 0
    radius: root.cornerRadius
  }
}
