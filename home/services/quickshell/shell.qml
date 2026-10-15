//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
import qs.services
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import qs.modules.bar
import qs.modules.background
import qs.modules.notifications as Notifs
import qs.modules.osd as Osd

ShellRoot {
  id: root

  settings.watchFiles: true

  Background {}

  Component.onCompleted: {
    LockService.init();
    LauncherService.init();
  }

  LazyLoader {
    id: screenshot
    loading: true

    ScreenshotService {}
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
    }
  }
}
