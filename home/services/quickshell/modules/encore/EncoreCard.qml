import QtQuick

Rectangle {
    id: root
    property color fill: EncoreStyle.paper
    property int depth: 5
    property bool soft: false
    color: fill
    radius: EncoreStyle.radius
    border.width: soft ? 1 : 2
    border.color: soft ? EncoreStyle.softOutline : EncoreStyle.outline

    Rectangle {
        z: -1
        x: 1
        y: root.depth + 1
        width: parent.width
        height: parent.height
        radius: parent.radius
        color: EncoreStyle.shadow
        opacity: EncoreStyle.dark ? 0.72 : 0.9
        visible: root.depth > 0
    }
    Rectangle {
        z: -1
        x: -2
        y: root.depth + 4
        width: parent.width + 4
        height: parent.height
        radius: parent.radius + 2
        color: EncoreStyle.shadow
        opacity: root.depth > 0 ? 0.16 : 0
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: Math.max(0, root.radius - 4)
        color: "transparent"
        border.width: 1
        border.color: EncoreStyle.highlight
    }
    Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 5 }
        height: Math.min(18, parent.height * 0.42)
        radius: Math.max(0, root.radius - 5)
        color: EncoreStyle.highlight
        opacity: 0.36
    }
}
