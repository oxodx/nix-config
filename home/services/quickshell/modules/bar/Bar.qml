import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.utils

Scope {
  id: bar
  property bool showBarBackground: Config.options.bar.showBackground

  Variants {
    model: {
      const screens = Quickshell.screens;
      const list = Config.options.bar.screenList;
      if (!list || list.length === 0)
        return screens;
      return screens.filter(screen => list.includes(screen.name));
    }

    PanelWindow {
      id: barWindow

      required property ShellScreen modelData

      WlrLayershell.namespace: "quickshell:bar"
      screen: modelData

      // System data
      property int cpuUsage: 0
      property int memUsage: 0
      property var lastCpuIdle: 0
      property var lastCpuTotal: 0

      Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
          onRead: data => {
            if (!data)
              return;
            var p = data.trim().split(/\s+/);
            var idle = parseInt(p[4]) + parseInt(p[5]);
            var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
            if (lastCpuTotal > 0) {
              cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));
            }
            lastCpuTotal = total;
            lastCpuIdle = idle;
          }
        }
        Component.onCompleted: running = true
      }

      // Memory process
      Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
          onRead: data => {
            if (!data)
              return;
            var parts = data.trim().split(/\s+/);
            var total = parseInt(parts[1]) || 1;
            var used = parseInt(parts[2]) || 0;
            memUsage = Math.round(100 * used / total);
          }
        }
        Component.onCompleted: running = true
      }

      // Update your timer to run both processes
      Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
          cpuProc.running = true;
          memProc.running = true;
        }
      }

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 32
      color: Colors.background

      RowLayout {
        anchors.fill: parent
        anchors.margins: 8

        Workspaces {}

        Item {
          Layout.fillWidth: true
        }

        // CPU
        Text {
          text: "CPU: " + cpuUsage + "%"
          color: Colors.primary
          font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 14
            bold: true
          }
        }

        Rectangle {
          width: 1
          height: 16
          color: Colors.surfaceVariant
        }

        // Memory
        Text {
          text: "Mem: " + memUsage + "%"
          color: Colors.primary
          font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 14
            bold: true
          }
        }

        Rectangle {
          width: 1
          height: 16
          color: Colors.surfaceVariant
        }

        // Clock
        Text {
          id: clock
          color: Colors.primary
          font {
            family: "JetBrainsMono Nerd Font"
            pixelSize: 16
            bold: true
          }
          text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
          Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
          }
        }
      }
    }
  }
}
