import QtQuick
import Quickshell
import qs.services

Item {
  id: root

  readonly property var mt: Theme.of(QsWindow.window)

  property var screenObj: null
  property real uiScale: 1

  readonly property string screenName: root.screenObj ? root.screenObj.name : ""
  readonly property real p: EditMode.progressFor(root.screenName)
  readonly property bool shown: EditMode.editing(root.screenName)

  visible: root.shown && root.p > 0.001
  readonly property real fade: Math.max(0, Math.min(1, root.p * 1.6))

  readonly property var target: EditMode.cardRect(root.width, root.height, root.uiScale)
  readonly property real sc: 1 + (root.target.s - 1) * Math.max(0, root.p)
  readonly property real cardX: root.target.x * root.p
  readonly property real cardY: root.target.y * root.p
  readonly property real cardW: root.width * root.sc
  readonly property real cardH: root.height * root.sc

  Rectangle {
    anchors.fill: parent
    gradient: Gradient {
      GradientStop { position: 0.0; color: Qt.darker(mt.colBorder, 2.1) }
      GradientStop { position: 1.0; color: Qt.darker(mt.colBorder, 2.9) }
    }
  }

  Loader {
    anchors.fill: parent
    active: root.shown
    opacity: root.fade

    sourceComponent: Canvas {
      id: cv

      onPaint: {
        const ctx = getContext("2d")
        ctx.reset()
        const w = width
        const h = height
        if (w < 32 || h < 32)
          return

        const step = 64 * root.uiScale
        const r = 7 * root.uiScale
        let row = 0
        for (let y = step / 2; y < h + step; y += step * 0.75) {
          const off = (row % 2) * step / 2
          for (let x = off; x < w + step; x += step) {
            ctx.globalAlpha = 0.07 + ((row * 7 + Math.round(x / step) * 3) % 5) * 0.012
            ctx.fillStyle = ((row + Math.round(x / step)) % 2 === 0) ? mt.accentMint : mt.accentCyan
            ctx.beginPath()
            ctx.moveTo(x, y - r)
            ctx.lineTo(x + r, y)
            ctx.lineTo(x, y + r)
            ctx.lineTo(x - r, y)
            ctx.closePath()
            ctx.fill()
          }
          row++
        }
      }

      onWidthChanged: requestPaint()
      onHeightChanged: requestPaint()
      Component.onCompleted: requestPaint()
    }
  }

  Rectangle {
    opacity: root.fade
    readonly property real t: EditMode.frameWidth * root.uiScale * Math.min(1, Math.max(0, root.p))
    x: root.cardX - t + 9 * root.uiScale
    y: root.cardY - t + 11 * root.uiScale
    width: root.cardW + t * 2
    height: root.cardH + t * 2
    radius: EditMode.cardRadius * root.uiScale + t
    color: Qt.darker(mt.colBorder, 3.6)
    antialiasing: true
  }
}
