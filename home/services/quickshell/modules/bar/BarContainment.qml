import qs.services
import qs.theme
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components

PanelWindow {
  id: root

  default property alias barItems: containment.data

  anchors {
    left: true
    right: true
    top: true
  }

  property real baseHeight: 40
  readonly property real barHeight: 40
  property real topMargin: 0
  implicitHeight: baseHeight
  exclusiveZone: baseHeight

  mask: Region {
    height: root.exclusiveZone
    width: root.width
  }

  color: "transparent"

  WlrLayershell.namespace: "shell:bar"
  // Popup windows handle their own input. Reconfiguring keyboard interactivity
  // every time a tooltip appears makes some compositors visibly reposition the
  // layer, so the bar itself must remain non-focusable.
  focusable: false

  readonly property Tooltip tooltip: tooltip
  Tooltip {
    id: tooltip
    bar: root
  }

  readonly property real tooltipXOffset: 0

  StyledRect {
    id: barRect

    y: Math.round(root.topMargin - LockService.lockSlide * (barRect.height + root.topMargin))
    height: root.barHeight

    anchors {
      left: parent.left
      right: parent.right
      leftMargin: 0
      rightMargin: 0
    }

    color: "transparent"
    radius: 0
    border.color: Appearance.colors.barOutline
    border.width: 0

    Item {
      id: containment

      anchors {
        fill: parent
        leftMargin: 0
        rightMargin: 0
      }
    }
  }
}
