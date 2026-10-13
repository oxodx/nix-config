import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.components
import qs.lock as Lock

PanelWindow {
  id: root

  default property alias barItems: containment.data

  anchors {
    left: true
    right: true
    top: true
  }

  property real baseHeight: 56
  property real topMargin: 0
  implicitHeight: baseHeight
  exclusiveZone: baseHeight

  mask: Region {
    height: root.exclusiveZone
    width: root.width
  }

  color: "transparent"

  WlrLayershell.namespace: "shell:bar"
  focusable: tooltip.activeItem != null

  readonly property Tooltip tooltip: tooltip
  Tooltip {
    id: tooltip
    bar: root
  }

  readonly property real tooltipXOffset: 0

  function boundedY(targetY: real, height: real): real {
    return Math.max(barRect.anchors.topMargin + height, Math.min(barRect.height + barRect.anchors.topMargin - height, targetY));
  }

  readonly property bool isFullscreenWorkspace: false
  property real compactState: isFullscreenWorkspace ? 0 : 1
  Behavior on compactState {
    NumberAnimation {
      duration: 600
      easing.type: Easing.BezierSpline
      easing.bezierCurve: [0.0, 0.75, 0.15, 1.0, 1.0, 1.0]
    }
  }

  StyledRect {
    id: barRect

    y: root.topMargin - Lock.Controller.lockSlide * (barRect.height + root.topMargin)
    height: parent.height

    anchors {
      left: parent.left
      right: parent.right
      margins: 0
    }

    color: Appearance.colors.bar
    radius: 0
    border.color: Appearance.colors.barOutline
    border.width: 0

    Item {
      id: containment

      anchors {
        fill: parent
        leftMargin: 10
        rightMargin: 10
        topMargin: 4
        bottomMargin: 4
      }
    }
  }
}
