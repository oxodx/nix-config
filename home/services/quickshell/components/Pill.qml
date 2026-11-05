import QtQuick
import qs.theme

// A SekaiPop pill: an outline, an optional light ring between the outline and the fill, and
// a flat fill, sitting on a hard shadow dropped straight down. Pressing drops the cap onto the
// shadow, and it springs back on release. Children are placed on top of the fill.
Item {
  id: root

  default property alias content: body.data

  property color fillColor: Appearance.colors.widget
  property color outlineColor: Appearance.colors.widgetOutlineSeparate
  property real borderWidth: 1
  property color ringColor: Appearance.colors.m3surfaceContainerHigh
  property real ringWidth: 0
  property color shadowColor: Appearance.colors.keycapShadow
  property real shadowDy: 3
  property bool pressed: false

  // The raised cap is the box without its shadow, so the shadow has room below it.
  readonly property real capWidth: root.width
  readonly property real capHeight: Math.max(0, root.height - root.shadowDy)
  property real cornerRadius: root.capHeight / 2

  // The shadow never moves. The cap covers it when pressed and reveals it when raised.
  Rectangle {
    visible: root.shadowDy > 0 && root.shadowColor.a > 0
    x: 0
    y: root.shadowDy
    width: root.capWidth
    height: root.capHeight
    radius: root.cornerRadius
    color: root.shadowColor
    antialiasing: true
  }

  Item {
    id: surface
    width: root.capWidth
    height: root.capHeight
    y: root.pressed ? root.shadowDy : 0

    Behavior on y {
      NumberAnimation {
        duration: root.pressed ? 80 : 260
        easing.type: root.pressed ? Easing.OutQuad : Easing.OutBack
        easing.overshoot: root.pressed ? 0 : 2.2
      }
    }

    Rectangle {
      id: face
      anchors.fill: parent
      radius: root.cornerRadius
      color: root.ringWidth > 0 ? root.ringColor : root.fillColor
      border.width: root.borderWidth
      border.color: root.outlineColor
      antialiasing: true
    }

    Rectangle {
      visible: root.ringWidth > 0
      anchors.fill: parent
      anchors.margins: root.borderWidth + root.ringWidth
      radius: Math.max(0, root.cornerRadius - root.borderWidth - root.ringWidth)
      color: root.fillColor
      antialiasing: true
    }

    Item {
      id: body
      anchors.fill: parent
      anchors.margins: root.borderWidth + root.ringWidth
    }
  }
}
