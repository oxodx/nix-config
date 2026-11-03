import qs.theme
import QtQuick

// The hover and press state layer for a bar widget: a tint over a small skewed shape.
// It sits behind the widget's content, the way Material state layers do.
SkewedPanel {
  id: root

  property bool hovered: false
  property bool pressed: false

  slantLeft: true
  slantRight: true
  slant: 6
  fillColor: Qt.alpha(Appearance.colors.m3onSurface, root.pressed ? 0.16 : root.hovered ? 0.08 : 0)
  outlineColor: Qt.alpha(Appearance.colors.cream, root.hovered ? 0.35 : 0)

  Behavior on fillColor { ColorAnimation { duration: 160; easing.type: Easing.OutCubic } }
  Behavior on outlineColor { ColorAnimation { duration: 160; easing.type: Easing.OutCubic } }
}
