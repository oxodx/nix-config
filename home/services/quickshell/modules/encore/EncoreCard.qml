import QtQuick

Rectangle {
    id: root
    property color fill: EncoreStyle.paper
    property int depth: 5
    color: fill
    radius: EncoreStyle.radius
    border.width: 2
    border.color: EncoreStyle.outline

    Rectangle {
        z: -1
        x: 0
        y: root.depth
        width: parent.width
        height: parent.height
        radius: parent.radius
        color: EncoreStyle.ink
        visible: root.depth > 0
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: Math.max(0, root.radius - 4)
        color: "transparent"
        border.width: 1
        border.color: EncoreStyle.cream
        opacity: 0.6
    }
}
