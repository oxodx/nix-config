import QtQuick
import QtQuick.Effects
import qs.theme

Item {
  id: root

  property alias source: image.source
  property alias fillMode: image.fillMode
  property alias asynchronous: image.asynchronous
  property alias cache: image.cache
  property bool slantLeft: true
  property bool slantRight: true
  property real slant: 18
  property real skew: 0
  property color outlineColor: "transparent"

  Image {
    id: image
    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    sourceSize.width: width * 2
    sourceSize.height: height * 2
    layer.enabled: true
    layer.effect: MultiEffect {
      maskEnabled: true
      maskSource: mask
    }
  }

  SkewedPanel {
    id: mask
    width: root.width
    height: root.height
    slantLeft: root.slantLeft
    slantRight: root.slantRight
    slant: root.slant
    skew: root.skew
    fillColor: Appearance.colors.m3onSurface
    visible: false
    layer.enabled: true
  }

  SkewedPanel {
    anchors.fill: parent
    slantLeft: root.slantLeft
    slantRight: root.slantRight
    slant: root.slant
    skew: root.skew
    outlineColor: root.outlineColor
  }
}
