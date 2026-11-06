import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs
import qs.services

PanelWindow {
    id: root
    screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
    visible: Notifications.popupList.length > 0 && !Notifications.popupInhibited && !GlobalStates.screenLocked
    anchors {
        top: true
        right: true
    }
    margins {
        top: EncoreStyle.barHeight + 12
        right: 16
    }
    implicitWidth: 360
    implicitHeight: Math.min(stack.implicitHeight + 8, (screen?.height ?? 1000) - 130)
    exclusiveZone: 0
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:encore:notifications"
    Flickable {
        anchors.fill: parent
        contentHeight: stack.implicitHeight + 8
        clip: true
        Column {
            id: stack
            width: parent.width - 6
            spacing: 12
            Repeater {
                model: Notifications.popupList
                EncoreNotification {
                    required property var modelData
                    notification: modelData
                    width: stack.width
                    Component.onCompleted: enter.start()
                    NumberAnimation on opacity {
                        id: enter
                        from: 0
                        to: 1
                        duration: 180
                        running: false
                    }
                }
            }
        }
    }
}
