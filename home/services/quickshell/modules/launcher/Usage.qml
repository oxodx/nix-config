pragma Singleton
import QtQuick
import QtCore
import Quickshell

Singleton {
  id: root
  readonly property var counts: {
    try {
      const parsed = JSON.parse(settings.counts);
      return parsed && typeof parsed === "object" && !Array.isArray(parsed) ? parsed : {};
    } catch (error) {
      return {};
    }
  }
  Settings {
    id: settings
    category: "launcher-history"
    property string counts: "{}"
  }
  function record(entry): void {
    const next = Object.assign({}, root.counts);
    const key = entry.id || entry.name;
    next[key] = (next[key] || 0) + 1;
    settings.counts = JSON.stringify(next);
  }
}
