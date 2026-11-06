import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs
import qs.services
import qs.modules.common

Variants {
    model: Quickshell.screens
    Scope {
        id: rails
        required property var modelData
        readonly property var monitor: Hyprland.monitorFor(modelData)
        readonly property int workspaceCount: Math.min(modelData.height < 800 ? 5 : 8, Math.max(1, Config.options.bar.workspaces.shown))
        PanelWindow {
            id: left
            screen: rails.modelData
            visible: GlobalStates.barOpen && !GlobalStates.screenLocked
            anchors { top: true; bottom: true; left: true }
            implicitWidth: 66
            exclusiveZone: 66
            color: "transparent"
            WlrLayershell.namespace: "quickshell:encore:bar"
            Component.onCompleted: GlobalFocusGrab.addPersistent(left)
            Component.onDestruction: GlobalFocusGrab.removePersistent(left)
            EncoreCard {
                anchors.fill: parent; anchors.margins: 10; anchors.topMargin: 34; anchors.bottomMargin: 28
                fill: "#291039"; radius: 23
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 7; spacing: 9
                    EncoreButton { symbol: "star"; implicitWidth: 32; implicitHeight: 32; padding: 3; fill: EncoreStyle.lavender; hint: "Encore launcher"; onClicked: { GlobalStates.searchOpen = !GlobalStates.searchOpen; GlobalStates.sidebarRightOpen = false } }
                    EncorePrideStripe { Layout.fillWidth: true; implicitHeight: 5; Layout.topMargin: 4; Layout.bottomMargin: 8 }
                    Repeater {
                        model: rails.workspaceCount
                        EncoreButton {
                            required property int index
                            readonly property int workspaceId: Math.floor(((rails.monitor?.activeWorkspace?.id ?? 1) - 1) / rails.workspaceCount) * rails.workspaceCount + index + 1
                            implicitWidth: 30; implicitHeight: 30; padding: 2
                            text: String(workspaceId).padStart(2, "0")
                            selected: rails.monitor?.activeWorkspace?.id === workspaceId
                            fill: "#512b6d"; foreground: selected ? EncoreStyle.ink : "#edddfa"
                            hint: "Workspace " + workspaceId
                            onClicked: Hyprland.dispatch("workspace " + workspaceId)
                        }
                    }
                    Item { Layout.fillHeight: true }
                    EncoreText { Layout.fillWidth: true; text: DateTime.time.replace(":", "\n"); horizontalAlignment: Text.AlignHCenter; font.pixelSize: 14; font.bold: true; color: "#edddfa" }
                    EncoreButton { symbol: Network.materialSymbol; implicitWidth: 30; implicitHeight: 30; padding: 2; hint: "Quick controls"; fill: EncoreStyle.lavender; onClicked: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen }
                    EncoreText { visible: Battery.available; Layout.fillWidth: true; text: Math.round(Battery.percentage * 100) + "%"; horizontalAlignment: Text.AlignHCenter; color: "#edddfa"; font.pixelSize: 10 }
                }
                WheelHandler { onWheel: event => Hyprland.dispatch(event.angleDelta.y < 0 ? "workspace r+1" : "workspace r-1") }
            }
        }
        PanelWindow {
            id: right
            screen: rails.modelData
            visible: GlobalStates.barOpen && !GlobalStates.screenLocked
            anchors { top: true; bottom: true; right: true }
            implicitWidth: 66; exclusiveZone: 66; color: "transparent"
            WlrLayershell.namespace: "quickshell:encore:tools"
            Component.onCompleted: GlobalFocusGrab.addPersistent(right)
            Component.onDestruction: GlobalFocusGrab.removePersistent(right)
            EncoreCard {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: 46; height: Math.min(actions.implicitHeight + 24, parent.height - 80)
                fill: "#291039"; radius: 23
                ColumnLayout {
                    id: actions
                    anchors.centerIn: parent; spacing: 12
                    EncoreButton { symbol: "search"; implicitWidth: 30; implicitHeight: 30; padding: 2; hint: "Search"; onClicked: { GlobalStates.searchOpen = !GlobalStates.searchOpen; GlobalStates.sidebarRightOpen = false } }
                    EncoreButton { symbol: "tune"; implicitWidth: 30; implicitHeight: 30; padding: 2; fill: EncoreStyle.lavender; hint: "Control room"; onClicked: { GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen; GlobalStates.searchOpen = false } }
                    EncoreButton { symbol: "content_paste"; implicitWidth: 30; implicitHeight: 30; padding: 2; hint: "Clipboard"; onClicked: { Cliphist.refresh(); GlobalStates.searchOpen = true; LauncherSearch.query = Config.options.search.prefix.clipboard } }
                    EncoreButton { symbol: Notifications.silent ? "notifications_off" : "notifications"; implicitWidth: 30; implicitHeight: 30; padding: 2; fill: EncoreStyle.pink; hint: "Notifications"; onClicked: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen }
                    EncoreButton { symbol: "settings"; implicitWidth: 30; implicitHeight: 30; padding: 2; hint: "Settings"; onClicked: Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("settings.qml")]) }
                    EncoreButton { symbol: "lock"; implicitWidth: 30; implicitHeight: 30; padding: 2; hint: "Lock"; onClicked: Quickshell.execDetached(["loginctl", "lock-session"]) }
                }
            }
        }
    }
}
