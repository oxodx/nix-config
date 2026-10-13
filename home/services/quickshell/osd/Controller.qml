pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
  id: root

  property string kind: "volume"
  property real value: 0
  property bool muted: false
  property int serial: 0
  signal requested

  function show(type: string, amount: real, isMuted: bool): void {
    kind = type;
    value = Math.max(0, Math.min(1, amount));
    muted = isMuted;
    serial++;
    requested();
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio ?? null
    function onVolumeChanged() {
      const audio = Pipewire.defaultAudioSink?.audio;
      if (audio)
        root.show("volume", audio.volume, audio.muted);
    }
    function onMutedChanged() {
      const audio = Pipewire.defaultAudioSink?.audio;
      if (audio)
        root.show("volume", audio.volume, audio.muted);
    }
  }

  Connections {
    target: Pipewire.defaultAudioSource?.audio ?? null
    function onMutedChanged() {
      const audio = Pipewire.defaultAudioSource?.audio;
      if (audio)
        root.show("microphone", audio.volume, audio.muted);
    }
  }

  Process {
    id: brightnessProcess
    property bool increase: true
    command: ["brightnessctl", "-m", "set", increase ? "+10%" : "10%-"]
    stdout: StdioCollector { id: brightnessOutput }
    onExited: code => {
      if (code !== 0)
        return;
      const match = brightnessOutput.text.match(/([0-9]+)%/);
      if (match)
        root.show("brightness", Number(match[1]) / 100, false);
    }
  }

  function changeBrightness(increase: bool): void {
    if (brightnessProcess.running)
      return;
    brightnessProcess.increase = increase;
    brightnessProcess.running = true;
  }

  IpcHandler {
    target: "osd"
    function brightnessUp(): void { root.changeBrightness(true); }
    function brightnessDown(): void { root.changeBrightness(false); }
  }
}
