import QtQuick
import Quickshell
import qs.services
import qs.theme

Item {
  id: root

  readonly property QtObject mt: QtObject {
    readonly property color colBorder: Appearance.colors.m3outline
    readonly property color accentCyan: Appearance.colors.m3primaryFixedDim
    readonly property color accentMint: Appearance.colors.m3tertiaryFixedDim
    readonly property color pRingWhite: Appearance.colors.m3onSurface
  }

  property var screenObj: null
  property real uiScale: 1

  readonly property string screenName: root.screenObj ? root.screenObj.name : ""
  readonly property real p: EditMode.progressFor(root.screenName)

  visible: EditMode.editing(root.screenName) && root.p > 0.001
  opacity: Math.max(0, Math.min(1, root.p * 2))

  readonly property var target: EditMode.cardRect(root.width, root.height, root.uiScale)
  readonly property real sc: 1 + (root.target.s - 1) * Math.max(0, root.p)
  readonly property real cardX: root.target.x * root.p
  readonly property real cardY: root.target.y * root.p
  readonly property real cardW: root.width * root.sc
  readonly property real cardH: root.height * root.sc

  readonly property real frame: EditMode.frameWidth * root.uiScale * Math.min(1, Math.max(0, root.p))
  readonly property real line: Math.min(3 * root.uiScale, root.frame / 4)
  readonly property real cardR: EditMode.cardRadius * root.uiScale

  Rectangle {
    readonly property real to: root.frame - root.line
    x: root.cardX - to
    y: root.cardY - to
    width: root.cardW + to * 2
    height: root.cardH + to * 2
    radius: root.cardR + to
    color: "transparent"
    border.width: Math.max(0, to - root.line)
    border.color: mt.pRingWhite
    antialiasing: true
  }

  Rectangle {
    readonly property real to: root.line
    x: root.cardX - to
    y: root.cardY - to
    width: root.cardW + to * 2
    height: root.cardH + to * 2
    radius: root.cardR + to
    color: "transparent"
    border.width: to
    border.color: mt.colBorder
    antialiasing: true
  }

  Rectangle {
    readonly property real to: root.frame
    x: root.cardX - to
    y: root.cardY - to
    width: root.cardW + to * 2
    height: root.cardH + to * 2
    radius: root.cardR + to
    color: "transparent"
    border.width: root.line
    border.color: mt.colBorder
    antialiasing: true
  }
}
