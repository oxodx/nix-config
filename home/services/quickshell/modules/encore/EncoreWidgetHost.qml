import QtQuick
import qs
import qs.modules.common

Item {
    id: root
    objectName: widgetId
    required property string widgetId
    property string screenName: "default"
    required property real initialX
    required property real initialY
    property real initialWidth: 280
    property real initialHeight: 200
    property real tilt: 0
    property bool fits: true
    readonly property real minimumWidth: ["image", "note", "lyrics"].includes(widgetId) ? 160 : 230
    readonly property real minimumHeight: ({weather:200, calendar:220, palette:170, profile:160, clock:160, todo:180, media:144, lyrics:220, image:130, note:130})[widgetId] || 130
    default property alias body: content.data
    readonly property var record: EncoreDesktopState.findLayout(screenName, widgetId)
    visible: Config.options.encore.desktopWidgets && !GlobalStates.screenLocked && !EncoreDesktopState.hidden(widgetId) && (fits || record !== null || GlobalStates.encoreEditMode)
    rotation: Config.options.encore.cardTilt ? tilt : 0
    z: drag.pressed || resize.pressed ? 50 : 1
    function restore() {
        if (drag.pressed || resize.pressed || !parent) return
        width = Math.max(minimumWidth, Math.min(parent.width - 150, record ? record.w * parent.width : initialWidth))
        height = Math.max(minimumHeight, Math.min(parent.height - 90, record ? record.h * parent.height : initialHeight))
        x = Math.max(70, Math.min(parent.width - width - 70, record ? record.x * parent.width : initialX))
        y = Math.max(45, Math.min(parent.height - height - 40, record ? record.y * parent.height : initialY))
    }
    function save() {
        EncoreDesktopState.saveLayout(screenName, widgetId, x / parent.width, y / parent.height, width / parent.width, height / parent.height)
    }
    onRecordChanged: restore()
    onInitialXChanged: restore()
    onInitialYChanged: restore()
    Component.onCompleted: restore()
    Connections { target: root.parent; function onWidthChanged() { root.restore() } function onHeightChanged() { root.restore() } }
    HoverHandler { id: hover }
    Item {
        id: content; anchors.fill: parent
        property bool lifted: hover.hovered && Config.options.encore.motion && !GlobalStates.encoreEditMode && root.visible
        transform: Translate {
            y: content.lifted ? -4 : 0
            Behavior on y { NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 0.6 } }
        }
        scale: lifted ? 1.012 : 1
        Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    }
    Rectangle {
        anchors.fill: parent; anchors.margins: -3
        visible: GlobalStates.encoreEditMode
        color: "transparent"; radius: 16; border.width: 2; border.color: EncoreStyle.pink
    }
    Rectangle {
        anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
        height: 27; radius: 8; color: EncoreStyle.lavender
        visible: GlobalStates.encoreEditMode
        EncoreText { anchors.centerIn: parent; text: "⠿  " + root.widgetId; color: EncoreStyle.ink; font.bold: true; font.pixelSize: 11 }
        MouseArea {
            id: drag; anchors.fill: parent; anchors.rightMargin: 30
            cursorShape: Qt.SizeAllCursor
            drag.target: root
            drag.minimumX: 70; drag.maximumX: root.parent.width - root.width - 70
            drag.minimumY: 45; drag.maximumY: root.parent.height - root.height - 40
            onReleased: root.save()
        }
        EncoreButton { anchors.right: parent.right; symbol: "close"; implicitWidth: 26; implicitHeight: 26; padding: 2; hint: "Hide " + root.widgetId; onClicked: EncoreDesktopState.toggle(root.widgetId) }
    }
    Rectangle {
        anchors.right: parent.right; anchors.bottom: parent.bottom
        width: 24; height: 24; radius: 6; color: EncoreStyle.pink
        visible: GlobalStates.encoreEditMode
        EncoreText { anchors.centerIn: parent; text: "◢"; color: EncoreStyle.ink }
        MouseArea {
            id: resize; anchors.fill: parent; cursorShape: Qt.SizeFDiagCursor
            property point start; property real startWidth; property real startHeight
            onPressed: mouse => { start = mapToItem(root.parent, mouse.x, mouse.y); startWidth = root.width; startHeight = root.height }
            onPositionChanged: mouse => {
                if (!pressed) return
                const pos = mapToItem(root.parent, mouse.x, mouse.y)
                root.width = Math.max(root.minimumWidth, Math.min(root.parent.width - root.x - 70, startWidth + pos.x - start.x))
                root.height = Math.max(root.minimumHeight, Math.min(root.parent.height - root.y - 40, startHeight + pos.y - start.y))
            }
            onReleased: root.save()
        }
    }
}
