import QtQuick
import QtQuick.Effects
import qs
import qs.components

BarButton {
  id: root

  property url image
  property string icon: ""
  property bool scaleIcon: true
  property bool asynchronous: false
  property real iconBrightness: 0

  Image {
    visible: root.icon === ""
    anchors.centerIn: parent
    width: root.scaleIcon ? parent.width : Math.max(1, Math.min(parent.width, parent.height) * 0.72)
    height: root.scaleIcon ? parent.height : Math.max(1, Math.min(parent.width, parent.height) * 0.72)
    source: root.image
    asynchronous: root.asynchronous
    fillMode: Image.PreserveAspectFit
    sourceSize.width: Math.max(24, Math.round(width))
    sourceSize.height: Math.max(24, Math.round(height))
    layer.enabled: true
    layer.effect: MultiEffect {
      brightness: root.iconBrightness
      colorization: 1
      colorizationColor: Appearance.colors.m3primary
    }
  }

  MaterialIcon {
    anchors.centerIn: parent
    visible: root.icon !== ""
    text: root.icon
    font.pointSize: Math.max(12, Math.min(root.width, root.height) * 0.52)
    color: Appearance.colors.m3primary
  }
}
