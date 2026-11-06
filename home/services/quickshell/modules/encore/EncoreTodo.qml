import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services

EncoreCard {
    id: root
    implicitHeight: 240
    radius: 13
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 10
        RowLayout {
            EncoreText { text: "Little victories"; font.bold: true; font.pixelSize: 19; Layout.fillWidth: true }
            EncoreText { text: Todo.list.filter(t => !t.done).length + " LEFT"; font.pixelSize: 9; color: EncoreStyle.muted }
        }
        ListView {
            Layout.fillHeight: true; Layout.fillWidth: true; clip: true; spacing: 4
            model: Todo.list
            delegate: RowLayout {
                id: taskRow
                required property var modelData
                required property int index
                width: ListView.view.width
                spacing: 6
                CheckBox {
                    id: task
                    Layout.fillWidth: true
                    checked: taskRow.modelData.done
                    onToggled: checked ? Todo.markDone(taskRow.index) : Todo.markUnfinished(taskRow.index)
                    contentItem: EncoreText { leftPadding: 30; text: taskRow.modelData.content; font.pixelSize: 12; font.strikeout: task.checked; opacity: task.checked ? 0.55 : 1; wrapMode: Text.Wrap }
                    indicator: Rectangle { x: 0; anchors.verticalCenter: parent.verticalCenter; width: 18; height: 18; radius: 5; color: task.checked ? EncoreStyle.pink : EncoreStyle.surface; border.width: 2; border.color: EncoreStyle.outline; EncoreText { anchors.centerIn: parent; text: task.checked ? "✓" : ""; color: EncoreStyle.ink } }
                }
                EncoreButton {
                    symbol: "close"
                    implicitWidth: 26; implicitHeight: 26; padding: 2
                    hint: "Delete this task"
                    Accessible.name: "Delete " + taskRow.modelData.content
                    onClicked: Todo.deleteItem(taskRow.index)
                }
            }
            EncoreText { anchors.centerIn: parent; visible: Todo.list.length === 0; text: "Small steps count, too."; color: EncoreStyle.muted; font.pixelSize: 12 }
        }
        TextField {
            Layout.fillWidth: true; placeholderText: "One little thing…"; color: EncoreStyle.text; placeholderTextColor: EncoreStyle.muted
            font.family: EncoreStyle.font; font.pixelSize: 12
            background: Rectangle { color: EncoreStyle.surface; radius: 9; border.width: 1; border.color: EncoreStyle.outline }
            onAccepted: { if (text.trim()) { Todo.addTask(text.trim()); clear() } }
        }
    }
}
