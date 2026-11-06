import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs
import qs.services
import qs.modules.common

EncorePopup {
    id: root
    opened: GlobalStates.overviewOpen && !GlobalStates.screenLocked
    cardWidth: 1000; cardHeight: 680
    onDismissed: GlobalStates.overviewOpen = false
    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        RowLayout {
            Layout.fillWidth: true
            EncoreText { text: "Make a little room."; font.pixelSize: 28; font.bold: true; Layout.fillWidth: true }
            EncoreButton { symbol: "close"; hint: "Close overview"; onClicked: GlobalStates.overviewOpen = false }
        }
        Flickable {
            Layout.fillWidth: true; Layout.fillHeight: true
            contentHeight: grid.implicitHeight + 8; clip: true
            ScrollBar.vertical: ScrollBar {}
            GridLayout {
                id: grid
                width: parent.width - 8
                columns: root.width < 800 ? 2 : 3
                columnSpacing: 14; rowSpacing: 18
                Repeater {
                    model: Math.max(10, Config.options.bar.workspaces.shown)
                    EncoreCard {
                        id: workspace
                        required property int index
                        readonly property int workspaceId: index + 1
                        readonly property var windows: Hyprland.workspaces.values.find(w => w.id === workspaceId)?.toplevels.values ?? []
                        Layout.fillWidth: true; implicitHeight: 172
                        fill: Hyprland.focusedMonitor?.activeWorkspace?.id === workspaceId ? EncoreStyle.surface : EncoreStyle.paper
                        ColumnLayout {
                            anchors.fill: parent; anchors.margins: 12; spacing: 6
                            EncoreButton {
                                text: "Workspace " + workspace.workspaceId
                                Layout.fillWidth: true; implicitHeight: 30
                                onClicked: { Hyprland.dispatch("workspace " + workspace.workspaceId); GlobalStates.overviewOpen = false }
                            }
                            ListView {
                                Layout.fillWidth: true; Layout.fillHeight: true; clip: true
                                model: workspace.windows
                                delegate: EncoreButton {
                                    required property var modelData
                                    width: ListView.view.width; implicitHeight: 28
                                    text: modelData.title || modelData.appId
                                    onClicked: { modelData.activate(); GlobalStates.overviewOpen = false }
                                }
                            }
                            EncoreText { visible: workspace.windows.length === 0; text: "A fresh page."; color: EncoreStyle.muted; font.pixelSize: 11 }
                        }
                    }
                }
            }
        }
    }
}
