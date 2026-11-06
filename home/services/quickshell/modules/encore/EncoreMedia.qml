import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common.widgets

EncoreCard {
    id: root
    readonly property var player: MprisController.activePlayer
    implicitHeight: 144
    fill: EncoreStyle.surface
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 10
        RowLayout {
            Layout.fillWidth: true
            Rectangle {
                implicitWidth: 48
                implicitHeight: 48
                radius: 12
                color: EncoreStyle.pink
                clip: true
                Image {
                    anchors.fill: parent
                    source: root.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                }
                MaterialSymbol {
                    anchors.centerIn: parent
                    visible: !root.player?.trackArtUrl
                    text: "music_note"
                    iconSize: 25
                    color: EncoreStyle.ink
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 3
                EncoreText {
                    text: "ON THE RECORD"
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 2
                    color: EncoreStyle.muted
                }
                EncoreText {
                    Layout.fillWidth: true
                    text: root.player?.trackTitle || "Nothing playing yet"
                    font.bold: true
                }
                EncoreText {
                    Layout.fillWidth: true
                    text: root.player?.trackArtist || "Your next favorite is one play away"
                    font.pixelSize: 12
                    color: EncoreStyle.muted
                }
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12
            EncoreButton {
                symbol: "skip_previous"
                implicitHeight: 34
                enabled: root.player?.canGoPrevious ?? false
                hint: "Previous track"
                onClicked: root.player.previous()
            }
            EncoreButton {
                symbol: root.player?.isPlaying ? "pause" : "play_arrow"
                implicitWidth: 70
                implicitHeight: 34
                fill: EncoreStyle.lavender
                enabled: root.player?.canTogglePlaying ?? false
                hint: "Play / pause"
                onClicked: root.player.togglePlaying()
            }
            EncoreButton {
                symbol: "skip_next"
                implicitHeight: 34
                enabled: root.player?.canGoNext ?? false
                hint: "Next track"
                onClicked: root.player.next()
            }
        }
    }
}
