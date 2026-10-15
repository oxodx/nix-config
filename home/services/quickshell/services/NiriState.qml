pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property string focusedOutput: ""
  property var workspaces: []
  property var workspaceOutputs: ({})

  function focusWorkspace(output: string, index: int): void {
    pendingWorkspace = index;
    focusMonitor.exec([niri, "msg", "action", "focus-monitor", output]);
  }

  function handleEvent(line: string): void {
    if (!line)
      return;

    let event;
    try {
      event = JSON.parse(line);
    } catch (error) {
      console.warn(`Failed to parse Niri event: ${error}`);
      return;
    }

    const changed = event.WorkspacesChanged;
    if (changed) {
      const outputs = {};
      for (const workspace of changed.workspaces) {
        outputs[workspace.id] = workspace.output;
        if (workspace.is_focused)
          root.focusedOutput = workspace.output;
      }
      root.workspaces = changed.workspaces;
      root.workspaceOutputs = outputs;
      return;
    }

    const activated = event.WorkspaceActivated;
    if (activated) {
      const output = root.workspaceOutputs[activated.id];
      root.workspaces = root.workspaces.map(workspace => {
        const copy = Object.assign({}, workspace);
        if (output && workspace.output == output)
          copy.is_active = workspace.id == activated.id;
        if (activated.focused)
          copy.is_focused = workspace.id == activated.id;
        return copy;
      });

      if (activated.focused && output)
        root.focusedOutput = output;
    }
  }

  readonly property string niri: "/run/current-system/sw/bin/niri"
  property int pendingWorkspace: 1

  Process {
    id: eventStream
    running: true
    command: [root.niri, "msg", "--json", "event-stream"]

    stdout: SplitParser {
      onRead: data => root.handleEvent(data)
    }

    onExited: restartTimer.start()
  }

  Process {
    id: focusMonitor
    onExited: (exitCode, exitStatus) => {
      if (exitCode == 0)
        workspaceCommand.exec([root.niri, "msg", "action", "focus-workspace", `${root.pendingWorkspace}`]);
    }
  }

  Process {
    id: workspaceCommand
  }

  Timer {
    id: restartTimer
    interval: 1000
    onTriggered: eventStream.running = true
  }
}
