import QtQuick

EncoreCard {
    fill: EncoreStyle.dark ? "#24122f" : "#321642"
    radius: 24
    border.color: EncoreStyle.dark ? "#aa83ca" : "#c39ae5"
    depth: 5
    Rectangle {
        x: 6; y: 22; width: 2; height: parent.height - 44; radius: 1
        color: EncoreStyle.lavender; opacity: 0.22
    }
    Column {
        anchors { right: parent.right; rightMargin: 5; verticalCenter: parent.verticalCenter }
        spacing: 6
        Repeater {
            model: 3
            Rectangle { width: 2; height: 2; radius: 1; color: EncoreStyle.pink; opacity: 0.3 }
        }
    }
}
