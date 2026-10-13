import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import qs.bar
import qs.background
import qs.lock as Lock
import qs.launcher as Launcher
import qs.notifications as Notifs
import qs.osd as Osd
import qs.screenshot as Screenshot

ShellRoot {
  id: root

  Component.onCompleted: [Lock.Controller.init(), Launcher.Controller.init()]

  LazyLoader {
    id: screenshot
    loading: true

    Screenshot.Controller {}
  }

  Connections {
    target: ShellIpc

    function onScreenshot() {
      screenshot.item.shooting = true;
    }
  }

  IpcHandler {
    target: "audio"

    function toggleMic(): void {
      const source = Pipewire.defaultAudioSource;
      if (source?.audio)
        source.audio.muted = !source.audio.muted;
    }

    function volUp(): void {
      const sink = Pipewire.defaultAudioSink;
      if (sink?.audio)
        sink.audio.volume = Math.min(1.5, sink.audio.volume + 0.05);
    }

    function volDown(): void {
      const sink = Pipewire.defaultAudioSink;
      if (sink?.audio)
        sink.audio.volume = Math.max(0, sink.audio.volume - 0.05);
    }
  }

  Variants {
    model: Quickshell.screens

    Scope {
      property var modelData

      Bar {
        id: bar
        screen: modelData
      }

      Notifs.NotificationOverlay {
        screen: modelData
        bar: bar
      }

      Osd.Osd {
        screen: modelData
      }

      PanelWindow {
        id: window

        screen: modelData

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.namespace: "shell:background"

        anchors {
          top: true
          bottom: true
          left: true
          right: true
        }

        BackgroundImage {
          anchors.fill: parent
          screen: window.screen
        }
      }
    }
  }
}
