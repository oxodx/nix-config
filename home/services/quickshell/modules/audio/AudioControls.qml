import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import qs.modules.bar
import qs.components

BarWidgetInner {
  id: root
  required property var bar
  implicitWidth: row.implicitWidth

  RowLayout {
    id: row
    anchors {
      fill: parent
      topMargin: 5
      bottomMargin: 5
    }
    spacing: 8

    Loader {
      Layout.fillHeight: true
      Layout.preferredWidth: height
      active: Pipewire.defaultAudioSink != null

      sourceComponent: AudioControl {
        bar: root.bar
        node: Pipewire.defaultAudioSink
        icon: node.audio.muted ? "volume_off" : "volume_up"
      }
    }

    Loader {
      Layout.fillHeight: true
      Layout.preferredWidth: height
      active: Pipewire.defaultAudioSource != null

      sourceComponent: AudioControl {
        bar: root.bar
        node: Pipewire.defaultAudioSource
        icon: node.audio.muted ? "mic_off" : "mic"
      }
    }
  }

  Variants {
    model: {
      if (!(Pipewire.defaultAudioSource?.audio?.muted ?? false))
        return [];
      return [...new Set(ToplevelManager.toplevels.values.filter(t => t.fullscreen).map(t => t.screens[0]))];
    }

    PanelWindow {
      required property ShellScreen modelData
      screen: modelData

      anchors.left: true
      anchors.bottom: true
      margins.left: 100
      margins.bottom: 100
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Overlay
      mask: Region {}
      color: "transparent"
      implicitWidth: 64
      implicitHeight: 64

      Rectangle {
        anchors.fill: parent
        color: "#40000000"
        radius: 15

        MaterialIcon {
          text: "mic_off"
          anchors.centerIn: parent
          font.pointSize: 36
          opacity: 0.3
        }
      }
    }
  }
}
