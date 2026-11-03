pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  readonly property var defaults: ({
    "wallpaper.enabled": true,
    "wallpaper.parallax": false,
    "wallpaper.parallaxAmount": 8,
    "wallpaper.parallaxWorkspaces": 5,
    "wallpaper.mpvpaper": true,
    "wallpaper.videoPause": "fullscreen",
    "wallpaper.videoResume": "pause",
    "theme.preset": "blend",
    "ui.slant": false,
    "ui.buttonShadow": true,
    "ui.radiusScale": 1,
    "bar.height": 40,
    "bar.showWorkspaces": true,
    "bar.showMedia": true,
    "bar.showClock": true,
    "bar.showTray": true,
  })

  property var values: ({})

  property bool loaded: false
  property bool touched: false

  function get(key) {
    const v = root.values
    return (key in v) ? v[key] : root.defaults[key]
  }

  function flag(key) {
    return !!root.get(key)
  }

  readonly property int changedCount: Object.keys(root.values).length

  function set(key, value) {
    if (!(key in root.defaults)) return
    root.touched = true
    if (root.loaded && root.get(key) === value) return
    const next = Object.assign({}, root.values)
    if (value === root.defaults[key]) delete next[key]
    else next[key] = value
    root.values = next
    saver.save(JSON.stringify(next))
  }

  function toggle(key) {
    root.set(key, !root.flag(key))
  }

  function applyPreset(incoming, keeps) {
    root.touched = true
    const next = {}
    for (const k in root.values) {
      if (keeps(k)) next[k] = root.values[k]
    }
    for (const k in incoming) {
      if (keeps(k) || !(k in root.defaults)) continue
      if (typeof incoming[k] === typeof root.defaults[k] && incoming[k] !== root.defaults[k])
        next[k] = incoming[k]
    }
    root.values = next
    saver.save(JSON.stringify(next))
  }

  function reset() {
    root.touched = true
    root.values = ({})
    saver.save("{}")
  }

  readonly property string script: Directories.script("state-settings.sh")

  function restore(text) {
    try {
      const j = JSON.parse(text)
      const next = {}
      for (const k in j) {
        if (k in root.defaults && typeof j[k] === typeof root.defaults[k] && j[k] !== root.defaults[k])
          next[k] = j[k]
      }
      root.values = next
    } catch (e) {
      console.warn("SettingsService: couldn't read settings.json (" + e + ") — using the defaults")
    }
  }

  Process {
    running: true
    command: ["sh", root.script, "load"]
    stdout: StdioCollector {
      onStreamFinished: {
        if (!root.touched && text.trim() !== "")
          root.restore(text)
        root.loaded = true
      }
    }
    onExited: root.loaded = true
  }

  Process {
    id: saver

    property string pending: ""

    function save(json) {
      if (saver.running) {
        saver.pending = json
        return
      }
      saver.pending = ""
      saver.exec(["sh", root.script, "save", json])
    }

    onExited: {
      if (saver.pending !== "") {
        const json = saver.pending
        saver.pending = ""
        saver.exec(["sh", root.script, "save", json])
      }
    }
  }

  IpcHandler {
    target: "options"

    function get(key: string): string {
      return key + " = " + JSON.stringify(root.get(key))
    }

    function set(key: string, value: string): void {
      if (!(key in root.defaults)) return
      const d = root.defaults[key]
      if (typeof d === "boolean")
        root.set(key, value === "true" || value === "1" || value === "on")
      else if (typeof d === "number") {
        const n = Number(value)
        if (isFinite(n)) root.set(key, n)
      } else
        root.set(key, value)
    }

    function reset(): void {
      root.reset()
    }
  }
}
