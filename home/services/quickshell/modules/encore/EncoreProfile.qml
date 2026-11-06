import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets

EncoreCard {
    id: root
    implicitHeight: 180; radius: 13
    readonly property real dayProgress: (DateTime.clock.date.getHours() * 60 + DateTime.clock.date.getMinutes()) / 1440
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 15; spacing: 8
        RowLayout {
            Layout.fillWidth: true
            Rectangle {
                implicitWidth: 52; implicitHeight: 52; radius: 14; color: EncoreStyle.surface; clip: true
                Image { anchors.fill: parent; source: Config.options.encore.profileImagePath; fillMode: Image.PreserveAspectCrop; asynchronous: true }
                MaterialSymbol { anchors.centerIn: parent; visible: !Config.options.encore.profileImagePath; text: "favorite"; color: EncoreStyle.pink; iconSize: 30 }
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: EncoreDesktopState.chooseImage("profile") }
            }
            ColumnLayout {
                Layout.fillWidth: true; spacing: 3
                EncoreText { text: DateTime.clock.date.getHours() < 12 ? "GOOD MORNING" : DateTime.clock.date.getHours() < 18 ? "GOOD AFTERNOON" : "GOOD EVENING"; font.pixelSize: 9; font.bold: true; color: EncoreStyle.muted; Layout.fillWidth: true }
                EncoreText { text: SystemInfo.username; font.pixelSize: 22; font.bold: true; Layout.fillWidth: true }
                EncoreText { text: "room for every shade ♡"; font.pixelSize: 10; color: EncoreStyle.muted }
            }
        }
        RowLayout {
            Layout.fillWidth: true; spacing: 5
            Repeater {
                model: [{label: "UPTIME", value: DateTime.uptime}, {label: "SHELL", value: (Quickshell.env("SHELL") || "shell").split("/").pop()}, {label: "DESKTOP", value: "Hyprland"}]
                Rectangle {
                    required property var modelData
                    Layout.fillWidth: true; implicitHeight: 40; radius: 8; color: EncoreStyle.surface
                    ColumnLayout { anchors.centerIn: parent; spacing: 1; EncoreText { text: parent.parent.modelData.label; font.pixelSize: 8; color: EncoreStyle.muted; Layout.alignment: Qt.AlignHCenter } EncoreText { text: parent.parent.modelData.value; font.bold: true; font.pixelSize: 11; Layout.alignment: Qt.AlignHCenter } }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            EncoreText { text: "TODAY"; font.pixelSize: 9; font.bold: true; color: EncoreStyle.muted }
            Rectangle { Layout.fillWidth: true; implicitHeight: 7; radius: 4; color: EncoreStyle.surface; Rectangle { width: root.dayProgress * parent.width; height: parent.height; radius: 4; color: EncoreStyle.pink } }
            EncoreText { text: Math.round(root.dayProgress * 100) + "%"; font.bold: true; font.pixelSize: 11 }
        }
    }
}
