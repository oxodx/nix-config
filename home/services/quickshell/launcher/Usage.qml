pragma Singleton
import QtQuick
import QtCore
import Quickshell

Singleton {
  id: root
  readonly property var counts: JSON.parse(settings.counts)
  Settings {
    id: settings
    category: "launcher-history"
    property string counts: "{}"
  }
  function score(entry): int {
    return root.counts[entry.id || entry.name] || 0;
  }
  function record(entry): void {
    const next = Object.assign({}, root.counts);
    const key = entry.id || entry.name;
    next[key] = (next[key] || 0) + 1;
    settings.counts = JSON.stringify(next);
  }
}
