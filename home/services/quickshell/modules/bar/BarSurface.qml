import qs.theme
import qs.components
import QtQuick

// One bar island. It floats inside the bar with a small gap above and below, and has the
// legacy skewed silhouette with the lower corners cut. Children are placed inside it.
Item {
  id: root

  default property alias contentData: island.contentData

  property bool cutLeft: false
  property bool cutRight: false
  property real slant: 28
  property real inset: 0
  property color fillColor: Appearance.colors.bar

  SkewedSurface {
    id: island
    anchors.fill: parent
    anchors.topMargin: root.inset
    anchors.bottomMargin: root.inset
    slantLeft: root.cutLeft
    leftAtBottom: true
    slantRight: root.cutRight
    slant: root.slant
    insetContent: false
    fillColor: root.fillColor
    shadowOffset: 3
    lift: 0
  }
}
