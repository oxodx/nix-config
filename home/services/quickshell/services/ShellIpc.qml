pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
  signal screenshot

  function luaString(value): string {
    return "\"" + String(value).replace(/\\/g, "\\\\").replace(/"/g, "\\\"").replace(/\n/g, "\\n").replace(/\r/g, "\\r") + "\"";
  }

  function dispatchHyprland(legacyCommand, luaDispatcher): void {
    Hyprland.dispatch(Hyprland.usingLua ? luaDispatcher : legacyCommand);
  }

  function focusWorkspace(workspace): void {
    const selector = String(workspace);
    dispatchHyprland(`workspace ${selector}`, `hl.dsp.focus({ workspace = ${luaString(selector)} })`);
  }

  function focusMonitor(monitor): void {
    const selector = String(monitor);
    dispatchHyprland(`focusmonitor ${selector}`, `hl.dsp.focus({ monitor = ${luaString(selector)} })`);
  }

  function setDpms(enabled: bool): void {
    const action = enabled ? "on" : "off";
    dispatchHyprland(`dpms ${action}`, `hl.dsp.dpms({ action = "${action}" })`);
  }

  IpcHandler {
    target: "screenshot"
    function takeScreenshot() {
      screenshot();
    }
  }

  // A value from the command line: "true" / "false", a number, or text.
  function parseSetting(value: string): var {
    if (value === "true") return true;
    if (value === "false") return false;
    const n = Number(value);
    return value.trim() !== "" && !isNaN(n) ? n : value;
  }

  IpcHandler {
    target: "settings"

    // qs ipc call settings set bar.height 44
    // qs ipc call settings set ui.slant true
    function set(key: string, value: string): void {
      if (!(key in SettingsService.defaults))
        return;
      const parsed = parseSetting(value);
      if (typeof parsed === typeof SettingsService.defaults[key])
        SettingsService.set(key, parsed);
    }

    // qs ipc call settings toggle ui.slant
    function toggle(key: string): void {
      if (typeof SettingsService.defaults[key] === "boolean")
        SettingsService.toggle(key);
    }
  }

  IpcHandler {
    target: "theme"

    // qs ipc call theme set plum
    function set(name: string): void {
      if (ThemePresets.names.indexOf(name) >= 0)
        SettingsService.set("theme.preset", name);
    }

    // qs ipc call theme cycle
    function cycle(): void {
      SettingsService.set("theme.preset", ThemePresets.nextName(SettingsService.get("theme.preset") ?? "blend"));
    }
  }
}
