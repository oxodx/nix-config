import QtQuick
import QtQuick.Controls
import Quickshell
import qs.modules.common

EncoreCard {
    id: root
    radius: 6
    implicitHeight: 184
    Image {
        anchors.fill: parent; anchors.margins: 7; anchors.bottomMargin: 26
        source: Config.options.encore.imagePath || Config.options.background.wallpaperPath || Quickshell.shellPath("assets/images/default_wallpaper.png")
        fillMode: Image.PreserveAspectCrop; asynchronous: true
    }
    EncoreText { anchors.bottom: parent.bottom; anchors.bottomMargin: 7; anchors.horizontalCenter: parent.horizontalCenter; text: Config.options.encore.imagePath ? "a little piece of me ♡" : "click to add a picture ♡"; font.pixelSize: 9 }
    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: EncoreDesktopState.chooseImage() }
    EncoreTape { anchors.horizontalCenter: parent.horizontalCenter; y: -9; rotation: -9 }
}
