import QtQuick

Rectangle {
    implicitWidth: 72
    implicitHeight: 5
    radius: height / 2
    clip: true
    color: "transparent"
    Accessible.name: "Pride colors"
    readonly property var colors: ["#513b51", "#956443", "#75cee9", "#efa8cb", "#fff5fc", "#e97389", "#efa76e", "#f3da88", "#8fc5a1", "#8badeb", "#ba8be3"]
    Row {
        anchors.fill: parent
        Repeater {
            model: parent.parent.colors
            Rectangle {
                required property color modelData
                width: (parent.width / 11)
                height: parent.height
                color: modelData
            }
        }
    }
}
