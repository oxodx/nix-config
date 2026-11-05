import qs.theme
import QtQuick

// The hover and press state layer for a bar widget: a flat rounded tint, drawn behind the
// widget's content. Hover is a light wash; press uses the lilac accent.
SkewedPanel {
  id: root

  property bool hovered: false
  property bool pressed: false

  radius: Appearance.rounding.small
  outlineWidth: 1
  fillColor: root.pressed ? Qt.alpha(Appearance.colors.m3primary, 0.28)
           : root.hovered ? Qt.alpha(Appearance.colors.m3primary, 0.14)
           : "transparent"
  outlineColor: root.hovered || root.pressed ? Qt.alpha(Appearance.colors.m3primary, 0.55) : "transparent"

  Behavior on fillColor { ColorAnimation { duration: 150; easing.type: Easing.OutCubic } }
}
