pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string state: "unknown"
  property bool available: false
  property bool changing: false
  property string error: ""
  readonly property bool active: state === "active"
  readonly property bool busy: changing || state === "activating" || state === "deactivating"

  function refresh(): void {
    if (!status.running) status.running = true;
  }

  function toggle(): void {
    if (!available || busy) return;
    error = "";
    changing = true;
    control.command = ["/run/current-system/sw/bin/systemctl", "--no-ask-password", active ? "stop" : "start", "ollama.service"];
    control.running = true;
    timeout.restart();
  }

  Process {
    id: status
    command: ["/run/current-system/sw/bin/systemctl", "show", "ollama.service", "--property=ActiveState,LoadState"]
    stdout: StdioCollector {
      onStreamFinished: {
        const values = {};
        for (const line of text.trim().split("\n")) {
          const separator = line.indexOf("=");
          if (separator !== -1) values[line.slice(0, separator)] = line.slice(separator + 1);
        }
        root.available = values.LoadState === "loaded";
        root.state = values.ActiveState || "unknown";
      }
    }
  }

  Process {
    id: control
    stderr: StdioCollector { id: failure }
    onExited: code => {
      timeout.stop();
      root.changing = false;
      if (code !== 0) root.error = failure.text.trim() || "Could not change Ollama state";
      root.refresh();
    }
  }

  Timer {
    id: timeout
    interval: 30000
    onTriggered: {
      control.running = false;
      root.changing = false;
      root.error = "Ollama request timed out; check its status before retrying";
      root.refresh();
    }
  }
}
