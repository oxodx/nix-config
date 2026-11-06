import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs
import qs.services
import qs.modules.common

Rectangle {
    id: root
    color: "#170820"
    readonly property string wallpaper: Config.options.background.wallpaperPath
    readonly property bool video: /\.(mp4|webm|mkv|avi|mov)$/i.test(wallpaper)
    readonly property bool wide: width >= 1100
    readonly property real cardWidth: Math.min(280, width - 176)
    Image { anchors.fill: parent; anchors.margins: 12; source: (root.video ? Config.options.background.thumbnailPath : root.wallpaper) || Quickshell.shellPath("assets/images/default_wallpaper.png"); fillMode: Image.PreserveAspectCrop; asynchronous: true }
    Rectangle { anchors.fill: parent; anchors.margins: 12; color: EncoreStyle.dark ? "#72300d4c" : "#49350d50" }
    Rectangle { anchors.fill: parent; anchors.margins: 8; radius: 30; color: "transparent"; border.width: 5; border.color: "#a16dbe" }
    Rectangle { anchors.fill: parent; anchors.margins: 17; radius: 22; color: "transparent"; border.width: 2; border.color: "#b8e4b9ee" }
    // A loose constellation of stickers, kept behind application windows.
    Repeater {
        model: [ [0.32,0.12,"✦",-18], [0.63,0.19,"♡",12], [0.45,0.81,"✧",8], [0.74,0.72,"✦",-13], [0.27,0.64,"♡",14] ]
        EncoreText { required property var modelData; x: root.width * modelData[0]; y: root.height * modelData[1]; text: modelData[2]; rotation: modelData[3]; font.pixelSize: 35; color: "#b8db9ceb"; visible: Config.options.encore.desktopWidgets; style: Text.Outline; styleColor: "#63376c" }
    }
    ColumnLayout {
        visible: Config.options.encore.desktopWidgets && !GlobalStates.screenLocked
        x: 88; y: 58
        width: root.cardWidth
        spacing: 19
        EncoreCard {
            Layout.fillWidth: true; implicitHeight: 150; rotation: -1.5; radius: 13
            EncoreTape { x: 20; y: -9 }
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 18; spacing: 6
                EncoreText { text: "ENCORE / SIDE A"; font.pixelSize: 10; font.bold: true; font.letterSpacing: 2; color: EncoreStyle.muted }
                EncoreText { text: "Your space.\nYour rules."; font.pixelSize: 25; font.bold: true; Layout.fillWidth: true; wrapMode: Text.Wrap }
                RowLayout { EncorePrideStripe { implicitWidth: 98; implicitHeight: 7 } Item { Layout.fillWidth: true } EncoreText { text: "♥"; color: EncoreStyle.pink; font.pixelSize: 22 } }
            }
        }
        EncoreCalendar { Layout.fillWidth: true; rotation: 0.8; visible: root.height >= 700 }
        EncoreCard {
            Layout.fillWidth: true; implicitHeight: 126; rotation: -1; radius: 13; visible: root.height >= 870
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 9
                EncoreText { text: "Current obsession"; font.bold: true; font.pixelSize: 17 }
                RowLayout {
                    Layout.fillWidth: true
                    Repeater { model: ["#34104d", "#643686", "#a979cf", "#e6abe4", "#acd6f0"]; Rectangle { required property color modelData; Layout.fillWidth: true; implicitHeight: 34; radius: 7; color: modelData; border.width: 2; border.color: EncoreStyle.outline } }
                }
                EncoreText { text: "DEEP PURPLE / LOUD HEART"; font.pixelSize: 9; color: EncoreStyle.muted; font.letterSpacing: 1 }
            }
        }
    }
    ColumnLayout {
        visible: root.wide && Config.options.encore.desktopWidgets && !GlobalStates.screenLocked
        x: root.width - width - 88; y: 66
        width: root.cardWidth
        spacing: 20
        EncoreCard {
            Layout.fillWidth: true; implicitHeight: 170; rotation: 1.2; radius: 13
            EncoreTape { anchors.right: parent.right; anchors.rightMargin: 15; y: -9; rotation: 15 }
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 17; spacing: 2
                EncoreText { text: DateTime.longDate; font.bold: true; font.pixelSize: 13; Layout.fillWidth: true }
                EncoreText { text: DateTime.time; font.bold: true; font.pixelSize: 54; font.letterSpacing: -2; Layout.fillWidth: true }
                EncorePrideStripe { Layout.fillWidth: true; implicitHeight: 6; Layout.topMargin: 8 }
                EncoreText { text: "A VERY GOOD TIME TO BE YOU."; color: EncoreStyle.muted; font.pixelSize: 9; Layout.topMargin: 8 }
            }
        }
        EncoreTodo { Layout.fillWidth: true; rotation: -0.8; visible: root.height >= 700 }
        EncoreMedia { Layout.fillWidth: true; rotation: 1.5; visible: root.height >= 900 }
    }
    EncoreCard {
        visible: root.wide && root.height >= 700 && Config.options.encore.desktopWidgets && !GlobalStates.screenLocked
        x: root.width * 0.54; y: root.height - height - 65
        width: 185; height: 145; rotation: 5; radius: 10
        fill: EncoreStyle.dark ? "#56296a" : "#dbb1ed"
        EncoreTape { anchors.horizontalCenter: parent.horizontalCenter; y: -11; rotation: -10 }
        ColumnLayout {
            anchors.fill: parent; anchors.margins: 15; spacing: 6
            EncoreText { text: "note to self ♡"; font.bold: true; font.pixelSize: 12 }
            TextArea {
                Layout.fillWidth: true; Layout.fillHeight: true
                text: Config.options.encore.note
                onTextChanged: if (text !== Config.options.encore.note) Config.options.encore.note = text
                wrapMode: TextEdit.Wrap; color: EncoreStyle.text; font.family: EncoreStyle.font; font.pixelSize: 13
                background: Item {}
                selectByMouse: true
            }
        }
    }
    EncoreTape { x: 18; y: 18; rotation: -32; width: 85; height: 24 }
    EncoreTape { x: root.width - 100; y: 20; rotation: 32; width: 85; height: 24; color: "#bfdca4d6" }
}
