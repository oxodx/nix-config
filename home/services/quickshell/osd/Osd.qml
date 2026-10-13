import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.components

PanelWindow {
  id: root
  required property ShellScreen screen

  property bool showing: false
  readonly property bool focusedScreen: screen.name === NiriState.focusedOutput || NiriState.focusedOutput === ""

  visible: showing && focusedScreen
  implicitWidth: 310
  implicitHeight: 66
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  anchors.bottom: true
  margins.bottom: 64

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "shell:osd"
  mask: Region {}

  Connections {
    target: Controller
    function onRequested() {
      if (!root.focusedScreen)
        return;
      root.showing = true;
      hideTimer.restart();
    }
  }

  Timer {
    id: hideTimer
    interval: 1400
    onTriggered: root.showing = false
  }

  StyledRect {
    anchors.fill: parent
    opacity: root.showing ? 1 : 0
    scale: root.showing ? 1 : 0.94
    color: "#ed171a22"
    radius: 14
    border.width: 1
    border.color: "#38ffffff"

    Behavior on opacity { NumberAnimation { duration: 140 } }
    Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }

    Row {
      anchors {
        fill: parent
        leftMargin: 16
        rightMargin: 22
      }
      spacing: 14

      StyledText {
        width: 25
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 15
        color: Controller.muted ? "#ff747b" : "#f4f6fb"
        text: Controller.kind === "brightness" ? "☀" : Controller.kind === "microphone" ? (Controller.muted ? "×" : "●") : (Controller.muted || Controller.value === 0 ? "×" : "♪")
      }

      Item {
        width: 180
        height: parent.height

        StyledRect {
          anchors.verticalCenter: parent.verticalCenter
          width: parent.width
          height: 8
          radius: 4
          color: "#30ffffff"

          StyledRect {
            width: parent.width * Controller.value
            height: parent.height
            radius: parent.radius
            color: Controller.muted ? "#ff747b" : "#88c0ff"

            Behavior on width {
              NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
            }
          }
        }
      }

      StyledText {
        width: 38
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: "#f4f6fb"
        font.pointSize: 9
        font.weight: Font.DemiBold
        text: Controller.muted ? "OFF" : `${Math.round(Controller.value * 100)}%`
      }
    }
  }

}
