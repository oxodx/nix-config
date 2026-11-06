import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.panels.lock
import qs.modules.ii.lock as SharedLock

Rectangle {
    id: root
    required property LockContext context
    // Always cover the lock surface, including while an image loads or fails.
    color: "#21152c"
    readonly property string wallpaper: Config.options.background.wallpaperPath
    readonly property bool video: /\.(mp4|webm|mkv|avi|mov)$/i.test(wallpaper)
    readonly property string imagePath: video ? Config.options.background.thumbnailPath : wallpaper
    Image {
        anchors.fill: parent
        source: root.imagePath || Quickshell.shellPath("assets/images/default_wallpaper.png")
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        opacity: status === Image.Ready ? 1 : 0
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#8030213f" }
            GradientStop { position: 1; color: "#e621152c" }
        }
    }
    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        y: Math.max(40, parent.height * 0.2)
        width: Math.min(460, parent.width - 48)
        spacing: 12
        EncoreText {
            Layout.alignment: Qt.AlignHCenter
            text: DateTime.time
            font.pixelSize: Math.min(96, root.width / 7)
            font.bold: true
            font.letterSpacing: -3
            color: "#fbf5ff"
        }
        EncoreText {
            Layout.alignment: Qt.AlignHCenter
            text: DateTime.longDate
            font.pixelSize: 20
            color: "#e1c9f5"
        }
        EncorePrideStripe { Layout.alignment: Qt.AlignHCenter; Layout.topMargin: 10; implicitWidth: 96; implicitHeight: 6 }
        EncoreText {
            Layout.alignment: Qt.AlignHCenter
            text: "A LITTLE SPACE TO BE YOURSELF."
            font.pixelSize: 11
            font.letterSpacing: 2
            color: "#e1c9f5"
        }
    }
    SharedLock.LockSurface {
        anchors.fill: parent
        context: root.context
    }
}
