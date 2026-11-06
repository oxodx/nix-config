import QtQuick
import QtQuick.Controls

Slider {
    id: root
    implicitHeight: 32
    leftPadding: 8
    rightPadding: 8
    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: root.availableWidth
        height: 10
        radius: 5
        color: EncoreStyle.paper
        border.width: 1
        border.color: EncoreStyle.outline
        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: EncoreStyle.lavender
            border.width: 1
            border.color: EncoreStyle.ink
        }
    }
    handle: EncoreCard {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        implicitWidth: 20
        implicitHeight: 26
        radius: 7
        depth: root.pressed ? 0 : 2
        fill: root.pressed ? EncoreStyle.yellow : EncoreStyle.cream
        border.color: root.visualFocus ? EncoreStyle.pink : EncoreStyle.ink
        Rectangle {
            anchors.centerIn: parent
            width: 2
            height: 10
            radius: 1
            color: EncoreStyle.ink
        }
    }
}
