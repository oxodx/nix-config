pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property real cpu: 0
  property real memory: 0
  property real previousTotal: 0
  property real previousIdle: 0
  FileView {
    id: cpuFile
    path: "/proc/stat"
    onLoaded: {
      const values = text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
      const total = values.slice(0, 8).reduce((a, b) => a + b, 0);
      const idle = values[3] + values[4];
      if (root.previousTotal > 0 && total > root.previousTotal)
        root.cpu = Math.max(0, Math.min(1, 1 - (idle - root.previousIdle) / (total - root.previousTotal)));
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
      if (total && available) root.memory = 1 - Number(available[1]) / Number(total[1]);
    }
  }
  Timer {
    interval: 2000; running: true; repeat: true; triggeredOnStart: true
    onTriggered: { cpuFile.reload(); memoryFile.reload(); }
  }
}
