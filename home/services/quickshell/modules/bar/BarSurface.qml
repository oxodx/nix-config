import qs.theme
import QtQuick
import QtQuick.Shapes

// Inward-cut lower corners, matching the legacy SKWD bar silhouette.
Shape {
  id: root
  property bool cutLeft: false
  property bool cutRight: false
  property real slant: 28
  property color fillColor: Qt.alpha(Appearance.colors.m3surfaceContainerLow, 0.94)
  preferredRendererType: Shape.CurveRenderer
  ShapePath {
    fillColor: root.fillColor
    strokeColor: "transparent"
    startX: 0; startY: 0
    PathLine { x: root.width; y: 0 }
    PathLine { x: root.width - (root.cutRight ? root.slant : 0); y: root.height }
    PathLine { x: root.cutLeft ? root.slant : 0; y: root.height }
    PathLine { x: 0; y: 0 }
  }
}
