import QtQuick
import Quickshell
import Quickshell.Wayland
import qs

Variants {
    model: Quickshell.screens
    PanelWindow {
        required property var modelData
        screen: modelData
        anchors { top: true; bottom: true; left: true; right: true }
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: GlobalStates.encoreEditMode ? WlrLayer.Overlay : WlrLayer.Background
        WlrLayershell.keyboardFocus: GlobalStates.encoreEditMode ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand
        WlrLayershell.namespace: "quickshell:encore:desktop"
        color: "transparent"
        EncoreDesktopCanvas { anchors.fill: parent; screenName: modelData.name }
    }
}
