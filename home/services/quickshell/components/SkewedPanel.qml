import QtQuick
import QtQuick.Shapes

Shape {
  id: root

  property bool slantLeft: false
  property bool slantRight: false
  property real slant: 16
  property color fillColor: "transparent"
  property color outlineColor: "transparent"
  property real outlineWidth: 1

  preferredRendererType: Shape.CurveRenderer

  ShapePath {
    fillColor: root.fillColor
    strokeColor: root.outlineColor
    strokeWidth: root.outlineWidth
    joinStyle: ShapePath.RoundJoin

    startX: root.slantLeft ? root.slant : 0
    startY: 0
    PathLine {
      x: root.width
      y: 0
    }
    PathLine {
      x: root.slantRight ? root.width - root.slant : root.width
      y: root.height
    }
    PathLine {
      x: 0
      y: root.height
    }
    PathLine {
      x: root.slantLeft ? root.slant : 0
      y: 0
    }
  }
}
