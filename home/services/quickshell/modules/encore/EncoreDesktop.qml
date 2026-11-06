import QtQuick
import Quickshell
import Quickshell.Wayland

Variants {
    model: Quickshell.screens
    PanelWindow {
        required property var modelData
        screen: modelData
        anchors { top: true; bottom: true; left: true; right: true }
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
        WlrLayershell.namespace: "quickshell:encore:desktop"
        color: "#170820"
        EncoreDesktopCanvas { anchors.fill: parent }
    }
}
