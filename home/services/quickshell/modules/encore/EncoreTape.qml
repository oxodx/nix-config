import QtQuick
Rectangle {
    implicitWidth: 70
    implicitHeight: 20
    color: "#b8d2b4ed"
    rotation: -16
    border.width: 1
    border.color: "#72f5d5fc"
    Repeater {
        model: 6
        Rectangle { required property int index; x: index * 13; width: 5; height: parent.height; color: "#60f5d5fc" }
    }
}
