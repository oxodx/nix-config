import qs.theme
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components

PanelWindow {
  id: root
  required property ShellScreen screen

  property bool showing: false
  readonly property bool focusedScreen: screen.name === NiriState.focusedOutput || NiriState.focusedOutput === ""

  visible: showing && focusedScreen
  implicitWidth: 340
  implicitHeight: 72
  color: "transparent"
  exclusionMode: ExclusionMode.Ignore

  anchors.bottom: true
  margins.bottom: 48

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "shell:osd"
  mask: Region {}

  Connections {
    target: OsdService
    function onRequested(): void {
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

  Item {
    anchors.fill: parent
    opacity: root.showing ? 1 : 0
    scale: root.showing ? 1 : 0.94

    Behavior on opacity {
      NumberAnimation {
        duration: 140
      }
    }
    Behavior on scale {
      NumberAnimation {
        duration: 180
        easing.type: Easing.OutCubic
      }
    }

    SkewedSurface {
      anchors.fill: parent
      slantLeft: true
      slantRight: true
      slant: 22
      fillColor: Appearance.colors.overlayPanel
      outlineColor: Appearance.colors.widgetOutlineSeparate
      shadowColor: Appearance.colors.elevatedShadow
      shadowOffset: 5
    }

    RowLayout {
      anchors {
        fill: parent
        leftMargin: 30
        rightMargin: 30
        topMargin: 10
        bottomMargin: 10
      }
      spacing: 13

      MaterialIcon {
        Layout.preferredWidth: 28
        Layout.alignment: Qt.AlignVCenter
        text: OsdService.kind === "brightness" ? "brightness_6" : OsdService.kind === "microphone" ? (OsdService.muted ? "mic_off" : "mic") : (OsdService.muted || OsdService.value === 0 ? "volume_off" : "volume_up")
        fill: 1
        font.pointSize: Appearance.font.size.extraLarge
        color: OsdService.muted ? Appearance.colors.alert : Appearance.colors.m3tertiary
      }

      ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 4

        RowLayout {
          Layout.fillWidth: true

          StyledText {
            Layout.fillWidth: true
            text: OsdService.kind === "brightness" ? "BRIGHTNESS" : OsdService.kind === "microphone" ? "MICROPHONE" : "VOLUME"
            color: Appearance.colors.m3onSurfaceVariant
            font.pointSize: Appearance.font.size.smaller
            font.weight: Font.DemiBold
          }

          StyledText {
            text: OsdService.muted ? "OFF" : `${Math.round(OsdService.value * 100)}%`
            color: OsdService.muted ? Appearance.colors.alert : "#f4f6fb"
            font.pointSize: Appearance.font.size.smaller
            font.weight: Font.Bold
          }
        }

        ProgressBar {
          Layout.fillWidth: true
          Layout.preferredHeight: 6
          value: OsdService.value
          thickness: 6
          cornerRadius: 0
          fillColor: OsdService.muted ? Appearance.colors.alert : Appearance.colors.m3tertiary
          trackColor: Appearance.colors.sliderGroove

          Behavior on value {
            NumberAnimation {
              duration: 120
              easing.type: Easing.OutCubic
            }
          }
        }
      }
    }
  }
}
