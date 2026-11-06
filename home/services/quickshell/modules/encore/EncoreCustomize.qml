import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.modules.common

EncorePopup {
    id: root
    opened: GlobalStates.encoreCustomizeOpen && !GlobalStates.screenLocked
    cardWidth: 470; cardHeight: 800
    onDismissed: GlobalStates.encoreCustomizeOpen = false
    ColumnLayout {
        anchors.fill: parent; spacing: 14
        RowLayout {
            Layout.fillWidth: true
            EncoreText { text: "Make it yours."; font.pixelSize: 28; font.bold: true; Layout.fillWidth: true }
            EncoreButton { symbol: "close"; hint: "Close customization"; onClicked: GlobalStates.encoreCustomizeOpen = false }
        }
        Flickable {
            id: scroll
            Layout.fillWidth: true; Layout.fillHeight: true
            contentHeight: options.implicitHeight + 10; clip: true
            ScrollBar.vertical: ScrollBar {}
            ColumnLayout {
                id: options; width: scroll.width - 8; spacing: 12
                EncoreButton {
                    text: GlobalStates.encoreEditMode ? "Return to moving cards" : "Move & resize cards"
                    symbol: "drag_pan"; Layout.fillWidth: true; fill: EncoreStyle.lavender
                    onClicked: { GlobalStates.encoreEditMode = true; GlobalStates.encoreCustomizeOpen = false }
                }
                EncoreText { text: "YOUR CARDS"; font.bold: true; font.pixelSize: 10; font.letterSpacing: 2 }
                Flow {
                    Layout.fillWidth: true; spacing: 8
                    Repeater {
                        model: EncoreDesktopState.widgets
                        EncoreButton { required property var modelData; text: modelData.name; implicitHeight: 32; selected: !EncoreDesktopState.hidden(modelData.id); onClicked: EncoreDesktopState.toggle(modelData.id) }
                    }
                }
                EncoreText { text: "WALLPAPER DIMMING"; font.bold: true; font.pixelSize: 10; font.letterSpacing: 2; Layout.topMargin: 10 }
                EncoreSlider { Layout.fillWidth: true; from: 0; to: 0.5; stepSize: 0.01; value: Config.options.encore.wallpaperDim; onMoved: Config.options.encore.wallpaperDim = value; Accessible.name: "Wallpaper dimming" }
                EncoreText { text: "FRAME ROUNDING"; font.bold: true; font.pixelSize: 10; font.letterSpacing: 2 }
                EncoreSlider { Layout.fillWidth: true; from: 12; to: 60; stepSize: 1; value: Config.options.encore.frameRounding; onMoved: Config.options.encore.frameRounding = Math.round(value); Accessible.name: "Frame rounding" }
                EncoreButton { text: "Crooked cards"; symbol: "rotate_right"; selected: Config.options.encore.cardTilt; Layout.fillWidth: true; onClicked: Config.options.encore.cardTilt = !Config.options.encore.cardTilt }
                EncoreButton { text: "Gentle desktop motion"; symbol: "auto_awesome"; selected: Config.options.encore.motion; Layout.fillWidth: true; onClicked: Config.options.encore.motion = !Config.options.encore.motion }
                EncoreButton { text: "Light / dark cards"; symbol: "contrast"; Layout.fillWidth: true; onClicked: Config.options.encore.darkMode = !Config.options.encore.darkMode }
                EncoreText { text: "PICTURES & ACCENTS"; font.bold: true; font.pixelSize: 10; font.letterSpacing: 2; Layout.topMargin: 10 }
                EncoreButton { text: "Choose desktop picture"; symbol: "image"; Layout.fillWidth: true; onClicked: EncoreDesktopState.chooseImage() }
                EncoreButton { text: "Choose profile picture"; symbol: "account_circle"; Layout.fillWidth: true; onClicked: EncoreDesktopState.chooseImage("profile") }
                RowLayout {
                    EncoreButton { text: "Purple"; onClicked: { Config.options.encore.paletteMode = "purple"; EncoreDesktopState.accent("#bf8de9") } }
                    EncoreButton { text: "Wallpaper"; onClicked: EncoreDesktopState.sample("wallpaper") }
                    EncoreButton { text: "Shuffle"; onClicked: EncoreDesktopState.shuffle() }
                }
                EncoreButton { text: "Reset card positions & visibility"; symbol: "restart_alt"; Layout.fillWidth: true; onClicked: EncoreDesktopState.resetLayout() }
                EncoreText { text: "Drag a card's pink title strip; resize from its lower-right corner. Hidden cards keep their data and can be restored here."; Layout.fillWidth: true; wrapMode: Text.Wrap; color: EncoreStyle.muted; font.pixelSize: 12 }
            }
        }
    }
}
