import Quickshell
import Quickshell.Wayland

PanelWindow {
  required property string name

  WlrLayershell.namespace: `oxod-shell-${name}`
  color: "transparent"
}
