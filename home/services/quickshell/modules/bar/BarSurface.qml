import qs.theme
import qs.components
import QtQuick

// One bar island, as a SekaiPop pill. It sits flush with the top of the bar and keeps a hard
// shadow at the bottom. Children are placed inside the pill.
Item {
  id: root

  default property alias contentData: pill.content

  property real inset: 0
  property color fillColor: Appearance.colors.bar

  Pill {
    id: pill
    anchors.fill: parent
    anchors.topMargin: root.inset
    fillColor: root.fillColor
    shadowDy: 3
  }
}
