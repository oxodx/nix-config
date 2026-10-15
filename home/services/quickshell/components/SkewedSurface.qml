import qs.theme
import QtQuick

Item {
  id: root

  default property alias contentData: content.data

  property bool slantLeft: false
  property bool slantRight: false
  property real slant: 18
  property color fillColor: "#e61c1b24"
  property color outlineColor: Appearance.colors.widgetOutlineSeparate
  property color shadowColor: Appearance.colors.neutralShadow
  property real shadowOffset: 4

  SkewedPanel {
    anchors.fill: parent
    anchors.topMargin: root.shadowOffset
    slantLeft: root.slantLeft
    slantRight: root.slantRight
    slant: root.slant
    fillColor: root.shadowColor
  }

  SkewedPanel {
    anchors.fill: parent
    slantLeft: root.slantLeft
    slantRight: root.slantRight
    slant: root.slant
    fillColor: root.fillColor
    outlineColor: root.outlineColor
  }

  Item {
    id: content
    anchors.fill: parent
  }
}
