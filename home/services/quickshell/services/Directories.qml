pragma Singleton

import QtQuick
import Quickshell

// Absolute paths to files that ship alongside the shell's QML.
Singleton {
  id: root

  readonly property string shellDir: Quickshell.shellDir

  function script(name: string): string {
    return root.shellDir + "/scripts/" + name;
  }
}
