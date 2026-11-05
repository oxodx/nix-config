import qs.theme
import QtQuick

// A keycap card: a skewed face with an outline, a thin ring, and a hard shadow dropped straight
// down. Pressing sinks the face onto the shadow, and hovering lifts it slightly.
//   skew          a slope shared with nested panels, so their edges stay parallel
//   insetContent  keeps the content clear of the diagonal cut at each side (the full cut, since
//                 the edge is furthest in at the top of the shape)
Item {
  id: root

  default property alias contentData: content.data

  property bool slantLeft: false
  property bool slantRight: false
  property bool leftAtBottom: false
  property real slant: 18
  property real skew: 0
  property bool insetContent: true
  property real radius: Appearance.rounding.normal
  property color fillColor: Appearance.colors.panel
  // Fades from the fill colour to a slightly deeper shade. Off gives a flat fill.
  property bool gradient: false
  property real gloss: 0
  property color outlineColor: Appearance.colors.widgetOutlineSeparate
  property real outlineWidth: 2
  property color ringColor: Qt.alpha(Appearance.colors.m3onSurface, 0.3)
  property real ringGap: 2.5
  property color shadowColor: Appearance.colors.keycapShadow
  property real shadowOffset: 4
  property bool pressed: false
  property bool hovered: false
  property real lift: 2

  // Pressed buttons shrink slightly, as shadcn buttons do.
  scale: root.pressed ? 0.98 : 1
  Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

  readonly property real cutPx: root.skew > 0 ? root.skew * root.height : root.slant
  // Content keeps clear of the outline and the ring on every side, not only the cut ones.
  readonly property real frameInset: root.outlineColor.a > 0 ? root.outlineWidth + (root.ringColor.a > 0 ? root.ringGap + 1 : 0) : 0
  // A transparent shadow means no shadow, so the face keeps the full height.
  readonly property real shadowPx: root.shadowColor.a > 0 ? root.shadowOffset : 0
  readonly property color fillBottom: root.gradient ? Qt.darker(root.fillColor, 1.25) : "transparent"

  SkewedPanel {
    visible: root.shadowPx > 0
    anchors.fill: parent
    anchors.topMargin: root.shadowPx
    radius: root.radius
    slantLeft: root.slantLeft
    slantRight: root.slantRight
    leftAtBottom: root.leftAtBottom
    slant: root.slant
    skew: root.skew
    fillColor: root.shadowColor
  }

  Item {
    id: cap
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: Math.max(0, root.height - root.shadowPx)
    y: root.pressed ? root.shadowPx : (root.hovered ? -root.lift : 0)

    Behavior on y {
      NumberAnimation {
        duration: root.pressed ? 70 : 240
        easing.type: root.pressed ? Easing.OutQuad : Easing.OutBack
        easing.overshoot: root.pressed ? 0 : 1.4
      }
    }

    SkewedPanel {
      anchors.fill: parent
      radius: root.radius
      slantLeft: root.slantLeft
      slantRight: root.slantRight
      leftAtBottom: root.leftAtBottom
      slant: root.slant
      skew: root.skew
      fillColor: root.fillColor
      fillBottomColor: root.fillBottom
      outlineColor: root.outlineColor
      outlineWidth: root.outlineWidth
      ringColor: root.outlineColor.a > 0 ? root.ringColor : "transparent"
      ringInset: root.outlineWidth + root.ringGap
      gloss: root.gloss
    }

    Item {
      id: content
      anchors.fill: parent
      anchors.topMargin: root.frameInset
      anchors.bottomMargin: root.frameInset
      anchors.leftMargin: root.insetContent && root.slantLeft ? Math.max(root.frameInset, root.cutPx * Appearance.slantScale) : root.frameInset
      anchors.rightMargin: root.insetContent && root.slantRight ? Math.max(root.frameInset, root.cutPx * Appearance.slantScale) : root.frameInset
    }
  }
}
