import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

EncoreCard {
    id: root
    implicitHeight: 178; radius: 13
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 14; spacing: 9
        RowLayout { EncoreText { text: "Palette"; font.pixelSize: 19; font.bold: true; Layout.fillWidth: true } EncoreText { text: Config.options.encore.paletteMode; font.pixelSize: 10; color: EncoreStyle.muted } }
        RowLayout {
            Layout.fillWidth: true; spacing: 5
            EncoreButton { text: "Wall"; implicitHeight: 27; Layout.fillWidth: true; padding: 3; onClicked: EncoreDesktopState.sample("wallpaper") }
            EncoreButton { text: "Music"; enabled: !!MprisController.activePlayer?.trackArtUrl; implicitHeight: 27; Layout.fillWidth: true; padding: 3; onClicked: EncoreDesktopState.sample("music") }
            EncoreButton { text: "Random"; implicitHeight: 27; Layout.fillWidth: true; padding: 3; onClicked: EncoreDesktopState.shuffle() }
        }
        RowLayout {
            Layout.fillWidth: true
            Repeater {
                model: EncoreDesktopState.sampledColors.length ? EncoreDesktopState.sampledColors.slice(0,5) : ["#34104d", "#643686", "#a979cf", "#e6abe4", "#acd6f0"]
                EncoreButton { required property color modelData; Layout.fillWidth: true; implicitWidth: 30; implicitHeight: 34; fill: modelData; padding: 0; hint: "Use this accent"; onClicked: EncoreDesktopState.accent(modelData) }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            EncoreButton { text: "Shuffle"; implicitHeight: 28; padding: 5; onClicked: EncoreDesktopState.shuffle() }
            EncoreButton { text: "♡"; implicitHeight: 28; padding: 5; fill: EncoreStyle.pink; hint: "Restore purple"; onClicked: { Config.options.encore.paletteMode = "purple"; EncoreDesktopState.accent("#bf8de9") } }
            EncoreButton { text: "Undo"; implicitHeight: 28; padding: 5; onClicked: EncoreDesktopState.undoAccent() }
        }
    }
}
