import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import qs.bar

BarWidgetInner {
  id: root
  required property var bar
  implicitWidth: row.implicitWidth + 10

  RowLayout {
    id: row
    anchors {
      fill: parent
      margins: 5
    }
    spacing: 5

    Loader {
      Layout.fillHeight: true
      Layout.preferredWidth: height
      active: Pipewire.defaultAudioSink != null

      sourceComponent: AudioControl {
        bar: root.bar
        node: Pipewire.defaultAudioSink
        image: `image://icon/${node.audio.muted ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic"}`
      }
    }

    Loader {
      Layout.fillHeight: true
      Layout.preferredWidth: height
      active: Pipewire.defaultAudioSource != null

      sourceComponent: AudioControl {
        bar: root.bar
        node: Pipewire.defaultAudioSource
        image: `image://icon/${node.audio.muted ? "microphone-sensitivity-muted-symbolic" : "microphone-sensitivity-high-symbolic"}`
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

        IconImage {
          source: Quickshell.iconPath("microphone-sensitivity-muted-symbolic")
          anchors.fill: parent
          opacity: 0.3
        }
      }
    }
  }

}
