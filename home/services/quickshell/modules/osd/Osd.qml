import qs.theme
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.components

PanelWindow {
  id: root
  required property ShellScreen screen

  property bool showing: false
  readonly property var focusedMonitor: Hyprland.focusedMonitor
  readonly property bool focusedScreen: focusedMonitor === null || screen.name === focusedMonitor.name

  property real presence: showing ? 1 : 0
  Behavior on presence {
    NumberAnimation {
      duration: root.showing ? 160 : 240
      easing.type: Easing.OutCubic
    }
  }

  visible: (showing || presence > 0) && focusedScreen
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
    opacity: root.presence
    scale: 0.94 + 0.06 * root.presence

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

      Pill {
        Layout.preferredWidth: 42
        Layout.preferredHeight: 42
        Layout.alignment: Qt.AlignVCenter
        cornerRadius: 21
        fillColor: Qt.alpha(OsdService.muted ? Appearance.colors.alert : Appearance.colors.m3tertiary, 0.18)
        outlineColor: Appearance.colors.ink
        borderWidth: 2
        shadowDy: 0

        MaterialIcon {
          anchors.centerIn: parent
          text: OsdService.kind === "brightness" ? "brightness_6" : OsdService.kind === "microphone" ? (OsdService.muted ? "mic_off" : "mic") : (OsdService.muted || OsdService.value === 0 ? "volume_off" : "volume_up")
          fill: 1
          font.pointSize: Appearance.font.size.extraLarge
          color: OsdService.muted ? Appearance.colors.alert : Appearance.colors.m3tertiary
        }
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
            color: OsdService.muted ? Appearance.colors.alert : Appearance.colors.m3onSurface
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
