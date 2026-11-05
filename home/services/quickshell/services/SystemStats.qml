pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// CPU and memory for the dashboard. Each new sample is blended into the last one, so the bars and
// the numbers move gradually. A read that fails keeps the last good value instead of dropping to 0.
Singleton {
  id: root

  property real cpu: 0
  property real memory: 0

  // How much of each new sample is used. Lower is smoother and slower.
  readonly property real smoothing: 0.35

  property real previousTotal: 0
  property real previousIdle: 0
  property bool cpuReady: false
  property bool memoryReady: false

  function blend(current: real, sample: real, ready: bool): real {
    const clamped = Math.max(0, Math.min(1, sample));
    return ready ? current + (clamped - current) * root.smoothing : clamped;
  }

  FileView {
    id: cpuFile
    path: "/proc/stat"
    onLoaded: {
      const line = text().split("\n")[0] ?? "";
      const values = line.trim().split(/\s+/).slice(1).map(Number);
      if (values.length < 5 || values.some(value => !isFinite(value)))
        return;
      const total = values.slice(0, 8).reduce((a, b) => a + b, 0);
      const idle = values[3] + values[4];
      if (root.previousTotal > 0 && total > root.previousTotal) {
        const sample = 1 - (idle - root.previousIdle) / (total - root.previousTotal);
        root.cpu = root.blend(root.cpu, sample, root.cpuReady);
        root.cpuReady = true;
      }
      root.previousTotal = total;
      root.previousIdle = idle;
    }
  }

  FileView {
    id: memoryFile
    path: "/proc/meminfo"
    onLoaded: {
      const total = text().match(/MemTotal:\s+(\d+)/);
      const available = text().match(/MemAvailable:\s+(\d+)/);
      if (total && available && Number(total[1]) > 0) {
        const sample = 1 - Number(available[1]) / Number(total[1]);
        root.memory = root.blend(root.memory, sample, root.memoryReady);
        root.memoryReady = true;
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      cpuFile.reload();
      memoryFile.reload();
    }
  }
}
