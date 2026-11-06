import QtQuick
import qs.modules.common

EncoreButton {
    id: root
    property int badge: 0
    property bool occupied: false
    implicitWidth: 30; implicitHeight: 30; padding: 2
    fill: "#422052"
    foreground: selected ? EncoreStyle.ink : "#edddfa"
    scale: Config.options.encore.motion && hovered ? 1.10 : 1
    rotation: Config.options.encore.motion && hovered ? -5 : 0
    Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack; easing.overshoot: 0.8 } }
    Behavior on rotation { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    Rectangle {
        anchors.right: parent.right; anchors.top: parent.top
        anchors.rightMargin: -3; anchors.topMargin: -3
        visible: root.badge > 0
        width: Math.max(13, number.implicitWidth + 5); height: 13; radius: 6
        color: EncoreStyle.pink; border.color: EncoreStyle.ink; border.width: 1
        EncoreText { id: number; anchors.centerIn: parent; text: root.badge > 9 ? "9+" : root.badge; color: EncoreStyle.ink; font.pixelSize: 8; font.bold: true }
    }
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom; anchors.bottomMargin: -4
        width: root.selected ? 12 : 4; height: 3; radius: 2
        visible: root.selected || root.occupied
        color: root.selected ? EncoreStyle.pink : EncoreStyle.lavender
        Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    }
}
