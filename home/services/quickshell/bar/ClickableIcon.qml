import QtQuick

BarButton {
  id: root

  property url image
  property bool scaleIcon: true
  property bool asynchronous: false

  Image {
    anchors.centerIn: parent
    width: root.scaleIcon ? parent.width : Math.max(1, Math.min(parent.width, parent.height) * 0.72)
    height: root.scaleIcon ? parent.height : Math.max(1, Math.min(parent.width, parent.height) * 0.72)
    source: root.image
    asynchronous: root.asynchronous
    fillMode: Image.PreserveAspectFit
    sourceSize.width: Math.max(24, Math.round(width))
    sourceSize.height: Math.max(24, Math.round(height))
  }
}
