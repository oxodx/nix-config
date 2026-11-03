import QtQuick
import QtQuick.Shapes
import qs.theme

// A skewed panel with the SekaiPop finish: a gradient fill, an ink outline, an optional
// thin cream ring just inside it, and an optional soft gloss over the top.
// With Appearance.slantScale at 0 it becomes a flat rounded rectangle instead.
Shape {
  id: root

  property bool slantLeft: false
  property bool slantRight: false
  property real slant: 16
  // With slantLeft, the cut is normally at the top. Setting this cuts the bottom-left
  // corner instead, which is the legacy bar silhouette.
  property bool leftAtBottom: false
  property real radius: Appearance.rounding.normal
  property color fillColor: "transparent"
  property color fillBottomColor: "transparent"
  property color outlineColor: "transparent"
  property real outlineWidth: 1
  property color ringColor: "transparent"
  property real ringInset: 0
  property real gloss: 0

  preferredRendererType: Shape.CurveRenderer

  // A slope (cut per pixel of height) overrides `slant` when set, so nested panels stay parallel.
  property real skew: 0
  readonly property real cutPx: root.skew > 0 ? root.skew * root.height : root.slant
  readonly property real effSlant: root.cutPx * Appearance.slantScale
  readonly property bool flat: Math.abs(root.effSlant) < 0.5
  readonly property real k: root.height > 0 ? root.effSlant / root.height : 0
  readonly property bool hasFillGradient: root.fillBottomColor.a > 0

  // Edges at height y, pushed inward by d. The horizontal shift is corrected for the slant
  // so the inset stays the same distance from the edge.
  function edgeL(y, d) {
    const h = root.height;
    const base = root.leftAtBottom ? root.effSlant * (y / h)
                                   : (root.slantLeft ? root.effSlant * (1 - y / h) : 0);
    return (root.slantLeft ? base : 0) + (root.slantLeft ? d * Math.sqrt(1 + root.k * root.k) : d);
  }
  function edgeR(y, d) {
    const base = root.slantRight ? root.width - root.effSlant * (y / root.height) : root.width;
    return base - (root.slantRight ? d * Math.sqrt(1 + root.k * root.k) : d);
  }

  // The outline of the panel, inset by d.
  function outlinePath(d): string {
    const h = root.height, w = root.width;
    if (root.flat) {
      const x0 = d, y0 = d, x1 = w - d, y1 = h - d;
      const r = Math.max(0, Math.min(root.radius - d, (x1 - x0) / 2, (y1 - y0) / 2));
      return `M ${x0 + r} ${y0} H ${x1 - r} A ${r} ${r} 0 0 1 ${x1} ${y0 + r} `
           + `V ${y1 - r} A ${r} ${r} 0 0 1 ${x1 - r} ${y1} H ${x0 + r} `
           + `A ${r} ${r} 0 0 1 ${x0} ${y1 - r} V ${y0 + r} A ${r} ${r} 0 0 1 ${x0 + r} ${y0} Z`;
    }
    return `M ${root.edgeL(d, d)} ${d} L ${root.edgeR(d, d)} ${d} `
         + `L ${root.edgeR(h - d, d)} ${h - d} L ${root.edgeL(h - d, d)} ${h - d} Z`;
  }

  // A horizontal band of the panel between y0 and y1, inset by d.
  function bandPath(y0, y1, d): string {
    return `M ${root.edgeL(y0, d)} ${y0} L ${root.edgeR(y0, d)} ${y0} `
         + `L ${root.edgeR(y1, d)} ${y1} L ${root.edgeL(y1, d)} ${y1} Z`;
  }

  readonly property real outlineInset: root.outlineWidth / 2
  readonly property real glossBottom: root.ringInset + (root.height - 2 * root.ringInset) * 0.55

  ShapePath {
    fillColor: root.fillColor
    strokeColor: root.outlineColor
    strokeWidth: root.outlineWidth
    joinStyle: ShapePath.RoundJoin
    fillGradient: LinearGradient {
      x1: 0; y1: 0
      x2: 0; y2: root.height
      GradientStop { position: 0.0; color: root.fillColor }
      GradientStop { position: 1.0; color: root.hasFillGradient ? root.fillBottomColor : root.fillColor }
    }
    PathSvg { path: root.outlinePath(root.outlineInset) }
  }

  ShapePath {
    strokeColor: "transparent"
    fillColor: "transparent"
    fillGradient: LinearGradient {
      x1: 0; y1: root.ringInset
      x2: 0; y2: root.glossBottom
      GradientStop { position: 0.0; color: Qt.rgba(1, 0.97, 0.92, root.gloss * 0.30) }
      GradientStop { position: 1.0; color: Qt.rgba(1, 0.97, 0.92, 0) }
    }
    PathSvg { path: root.flat ? "" : root.bandPath(root.ringInset, root.glossBottom, root.ringInset) }
  }

  ShapePath {
    fillColor: "transparent"
    strokeColor: root.ringColor
    strokeWidth: 1
    joinStyle: ShapePath.RoundJoin
    PathSvg { path: root.ringInset > 0 ? root.outlinePath(root.ringInset) : "" }
  }
}
