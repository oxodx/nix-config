import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services

EncoreCard {
    id: root
    implicitHeight: 240
    radius: 13
    property int dragFrom: -1
    property int dragTo: -1
    property real dragY: 0
    property var draggedItem: null
    property string dragSnapshot: ""
    function updateDrop(y) {
        dragY = Math.max(0,Math.min(tasks.height,y))
        const contentY = tasks.contentY + dragY
        let index = tasks.indexAt(1,contentY)
        if (index < 0) index = tasks.indexAt(1,contentY + 5)
        if (index < 0) index = tasks.indexAt(1,contentY - 5)
        if (index >= 0) dragTo = index
        else if (contentY >= tasks.contentHeight) dragTo = Todo.list.length - 1
    }
    function endDrag(commit) {
        const from = dragFrom, to = dragTo, unchanged = JSON.stringify(Todo.list) === dragSnapshot
        dragFrom = -1; dragTo = -1; draggedItem = null
        if (commit && unchanged) Todo.moveItem(from,to)
    }
    Timer {
        interval: 40; repeat: true; running: root.dragFrom >= 0
        onTriggered: {
            if (root.dragY < 24) tasks.contentY = Math.max(0,tasks.contentY - 7)
            else if (root.dragY > tasks.height - 24) tasks.contentY = Math.min(Math.max(0,tasks.contentHeight-tasks.height),tasks.contentY+7)
            root.updateDrop(root.dragY)
        }
    }
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 10
        RowLayout {
            EncoreText { text: "Little victories"; font.bold: true; font.pixelSize: 19; Layout.fillWidth: true }
            EncoreText { text: Todo.list.filter(t => !t.done).length + " LEFT"; font.pixelSize: 9; color: EncoreStyle.muted }
        }
        ListView {
            id: tasks
            objectName: "encoreTodoTasks"
            interactive: root.dragFrom < 0
            Layout.fillHeight: true; Layout.fillWidth: true; clip: true; spacing: 4
            model: Todo.list
            delegate: RowLayout {
                id: taskRow
                required property var modelData
                required property int index
                width: ListView.view.width
                spacing: 6
                opacity: root.dragFrom === index ? 0.3 : 1
                Item {
                    Layout.preferredWidth: 18; Layout.preferredHeight: 28
                    EncoreText { anchors.centerIn: parent; text: "⠿"; color: EncoreStyle.muted; font.pixelSize: 18 }
                    MouseArea {
                        anchors.fill: parent; cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                        objectName: "encoreTodoHandle" + taskRow.index
                        Accessible.name: "Drag to prioritize " + taskRow.modelData.content
                        onPressed: mouse => {
                            root.dragFrom = taskRow.index; root.dragTo = taskRow.index; root.draggedItem = taskRow.modelData; root.dragSnapshot = JSON.stringify(Todo.list)
                            root.updateDrop(mapToItem(tasks,mouse.x,mouse.y).y)
                        }
                        onPositionChanged: mouse => { if (pressed) root.updateDrop(mapToItem(tasks,mouse.x,mouse.y).y) }
                        onReleased: root.endDrag(true)
                        onCanceled: root.endDrag(false)
                    }
                }
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
            Rectangle {
                parent: tasks
                x: 0; width: tasks.width; height: 2; color: EncoreStyle.pink; z: 20
                visible: root.dragFrom >= 0 && root.dragTo >= 0
                y: {
                    const target = tasks.itemAtIndex(root.dragTo)
                    return target ? target.y - tasks.contentY + (root.dragTo > root.dragFrom ? target.height : 0) : 0
                }
            }
            EncoreCard {
                parent: tasks
                x: 2; y: Math.max(0,Math.min(tasks.height-height,root.dragY-height/2)); width: tasks.width-4; height: 30; z: 21
                visible: root.dragFrom >= 0
                fill: EncoreStyle.surface; depth: 2; radius: 8; opacity: 0.95
                EncoreText { anchors.fill: parent; anchors.margins: 6; text: "⠿  " + (root.draggedItem?.content || ""); font.pixelSize: 12; font.bold: true }
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
