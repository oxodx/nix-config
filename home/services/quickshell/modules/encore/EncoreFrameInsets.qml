import QtQuick
import Quickshell
import Quickshell.Wayland
import qs
import qs.modules.common

// Reserve actual compositor work area, rather than painting a frame over apps.
Variants {
    model: Quickshell.screens
    Scope {
        required property var modelData
        id: insets
        PanelWindow {
            screen: insets.modelData
            visible: !GlobalStates.screenLocked
            anchors { top: true; left: true; right: true }
            implicitHeight: Math.max(24, Config.options.encore.frameRounding)
            exclusiveZone: implicitHeight
            color: "transparent"
            mask: Region {}
            WlrLayershell.namespace: "quickshell:encore:frame-top"
        }
        PanelWindow {
            screen: insets.modelData
            visible: !GlobalStates.screenLocked
            anchors { bottom: true; left: true; right: true }
            implicitHeight: Math.max(24, Config.options.encore.frameRounding)
            exclusiveZone: implicitHeight
            color: "transparent"
            mask: Region {}
            WlrLayershell.namespace: "quickshell:encore:frame-bottom"
        }
        PanelWindow {
            screen: insets.modelData
            visible: !GlobalStates.barOpen && !GlobalStates.screenLocked
            anchors { left: true; top: true; bottom: true }
            implicitWidth: Math.max(24, Config.options.encore.frameRounding)
            exclusiveZone: implicitWidth
            color: "transparent"; mask: Region {}
            WlrLayershell.namespace: "quickshell:encore:frame-left"
        }
        PanelWindow {
            screen: insets.modelData
            visible: !GlobalStates.barOpen && !GlobalStates.screenLocked
            anchors { right: true; top: true; bottom: true }
            implicitWidth: Math.max(24, Config.options.encore.frameRounding)
            exclusiveZone: implicitWidth
            color: "transparent"; mask: Region {}
            WlrLayershell.namespace: "quickshell:encore:frame-right"
        }
    }
}
