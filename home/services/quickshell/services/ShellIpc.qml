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
}
