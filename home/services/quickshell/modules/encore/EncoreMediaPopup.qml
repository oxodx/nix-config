import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland
import qs
import qs.services
import qs.modules.common

EncorePopup {
    id: root
    opened: GlobalStates.mediaControlsOpen && !GlobalStates.screenLocked
    leftAligned: true; bottomAligned: true
    cardWidth: 390; cardHeight: 370
    readonly property var player: MprisController.activePlayer
    property real position: player?.position ?? 0
    onDismissed: GlobalStates.mediaControlsOpen = false
    function time(seconds) {
        const value = Math.max(0,Math.floor(seconds || 0))
        return Math.floor(value/60) + ":" + String(value%60).padStart(2,"0")
    }
    Connections { target: root.player; function onPositionChanged() { root.position = root.player?.position ?? 0 } }
    Connections { target: GlobalStates; function onScreenLockedChanged() { if (GlobalStates.screenLocked) GlobalStates.mediaControlsOpen = false } }
    Timer { interval: 250; running: root.opened && (root.player?.isPlaying ?? false); repeat: true; onTriggered: root.position = root.player.position }
    ColumnLayout {
        anchors.fill: parent; spacing: 12
        RowLayout {
            Layout.fillWidth: true; Layout.maximumHeight: implicitHeight
            EncoreText { text: "ON YOUR TURNTABLE"; font.bold: true; font.pixelSize: 12; font.letterSpacing: 1; Layout.fillWidth: true }
            EncoreButton { symbol: "close"; implicitWidth: 30; implicitHeight: 30; padding: 3; hint: "Close music controls"; onClicked: root.dismissed() }
        }
        EncoreMedia { Layout.fillWidth: true; Layout.preferredHeight: 144; Layout.maximumHeight: 144 }
        EncoreSlider {
            Layout.fillWidth: true
            from: 0; to: Math.max(1,root.player?.length ?? 1)
            value: root.position
            enabled: root.player?.canSeek ?? false
            onMoved: if (root.player?.canSeek) root.player.position = value
            Accessible.name: "Song position"
        }
        RowLayout {
            Layout.fillWidth: true; Layout.maximumHeight: implicitHeight
            EncoreText { text: root.time(root.position); font.pixelSize: 11; color: EncoreStyle.muted }
            Item { Layout.fillWidth: true }
            EncoreText { text: root.time(root.player?.length); font.pixelSize: 11; color: EncoreStyle.muted }
        }
        Flickable {
            Layout.fillWidth: true; Layout.fillHeight: true
            contentWidth: players.implicitWidth; contentHeight: height; clip: true
            Row {
                id: players; spacing: 8
                Repeater {
                    model: MprisController.players
                    EncoreButton {
                        required property var modelData
                        text: modelData.identity || "Music player"
                        selected: root.player === modelData
                        implicitHeight: 30; padding: 5
                        onClicked: MprisController.setActivePlayer(modelData)
                    }
                }
            }
        }
    }
    IpcHandler {
        target: "mediaControls"
        function toggle(): void { GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen }
        function open(): void { GlobalStates.mediaControlsOpen = true }
        function close(): void { GlobalStates.mediaControlsOpen = false }
    }
    GlobalShortcut { name: "mediaControlsToggle"; description: "Toggle Encore music controls"; onPressed: GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen }
    GlobalShortcut { name: "mediaControlsOpen"; description: "Open Encore music controls"; onPressed: GlobalStates.mediaControlsOpen = true }
    GlobalShortcut { name: "mediaControlsClose"; description: "Close Encore music controls"; onPressed: GlobalStates.mediaControlsOpen = false }
}
