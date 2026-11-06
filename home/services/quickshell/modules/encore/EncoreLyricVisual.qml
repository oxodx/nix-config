import QtQuick

Item {
    id: root
    property string lineText: "♫"
    property string previousText: ""
    property string nextText: ""
    property string trackText: ""
    property var timedLines: []
    property int lineIndex: -1
    property bool playing: false
    property bool synced: false
    property real lineProgress: 0
    property real linePop: 1
    property real floatOffset: 0
    property real starTurn: 0
    readonly property int lyricSize: width >= 460 ? 29 : 24
    readonly property int rowHeight: 68
    readonly property var rows: timedLines.length ? timedLines : [{text: previousText}, {text: lineText}, {text: nextText}]
    readonly property int activeIndex: timedLines.length ? lineIndex : 1
    readonly property int focusedIndex: Math.max(0, activeIndex)
    readonly property string displayedLine: rows[focusedIndex]?.text || lineText

    function followLine() {
        const destination = focusedIndex * rowHeight - Math.max(0, (view.height - rowHeight) / 2)
        scroll.stop()
        // Seeking across a whole verse should not whizz through every line.
        if (Math.abs(view.contentY - destination) > rowHeight * 4)
            view.contentY = destination
        else {
            scroll.to = destination
            scroll.restart()
        }
        if (synced) {
            pop.restart()
            twirl.restart()
        }
    }
    onFocusedIndexChanged: followLine()
    onRowsChanged: Qt.callLater(followLine)
    Component.onCompleted: Qt.callLater(followLine)
    NumberAnimation {
        id: scroll
        target: view; property: "contentY"
        duration: 620; easing.type: Easing.OutBack; easing.overshoot: 0.65
    }
    SequentialAnimation {
        id: pop
        NumberAnimation { target: root; property: "linePop"; from: 0.94; to: 1.055; duration: 190; easing.type: Easing.OutCubic }
        NumberAnimation { target: root; property: "linePop"; to: 1; duration: 330; easing.type: Easing.OutBack; easing.overshoot: 0.8 }
    }
    NumberAnimation { id: twirl; target: root; property: "starTurn"; from: -35; to: 0; duration: 650; easing.type: Easing.OutBack }
    SequentialAnimation on floatOffset {
        running: root.playing && root.visible; loops: Animation.Infinite
        NumberAnimation { from: -1.5; to: 1.5; duration: 1600; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1.5; to: -1.5; duration: 1600; easing.type: Easing.InOutSine }
    }
    transform: Translate { y: root.floatOffset }

    EncoreText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: -7
        text: "✧  " + (root.synced ? "NOW SINGING" : "SIDE B / LITTLE LOVE SONGS") + "  ♡"
        font.pixelSize: 9; font.bold: true; font.letterSpacing: 2
        color: "#e4b2fa"; style: Text.Outline; styleColor: "#371143"
    }
    ListView {
        id: view
        objectName: "lyricScroll"
        anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 15; bottom: ornament.top; bottomMargin: 7 }
        clip: true
        onHeightChanged: Qt.callLater(root.followLine)
        interactive: false
        boundsBehavior: Flickable.StopAtBounds
        model: root.rows
        header: Item { width: view.width; height: Math.max(0, (view.height - root.rowHeight) / 2) }
        footer: Item { width: view.width; height: Math.max(0, (view.height - root.rowHeight) / 2) }
        delegate: Item {
            id: row
            required property var modelData
            required property int index
            readonly property bool current: index === root.activeIndex
            readonly property real distance: Math.abs(index - root.focusedIndex)
            width: view.width
            height: root.rowHeight
            scale: current ? root.linePop : 0.74
            opacity: current ? 1 : distance === 1 ? 0.5 : 0.12
            z: current ? 2 : 0
            Behavior on scale { enabled: !row.current; NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
            EncoreText {
                x: 2; y: 4; width: parent.width; height: parent.height
                text: row.modelData.text; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.Wrap; maximumLineCount: 2
                font.pixelSize: root.lyricSize; font.bold: true
                color: "#491b61"; style: Text.Outline; styleColor: "#250b35"
            }
            EncoreText {
                anchors.fill: parent
                text: row.modelData.text; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.Wrap; maximumLineCount: 2
                font.pixelSize: root.lyricSize; font.bold: true
                color: row.current ? "#fff0fc" : "#ddb4eb"; style: Text.Outline; styleColor: "#703d91"
            }
            Item {
                height: parent.height
                width: row.current && root.synced ? Math.max(0, Math.min(1, root.lineProgress)) * parent.width : 0
                clip: true
                EncoreText {
                    width: row.width; height: row.height
                    text: row.modelData.text; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.Wrap; maximumLineCount: 2
                    font.pixelSize: root.lyricSize; font.bold: true
                    color: "#f4b0de"; style: Text.Outline; styleColor: "#703d91"
                }
            }
        }
    }
    EncoreText { x: 5; y: view.y + view.height / 2 - 14; text: "✧"; font.pixelSize: 19; color: EncoreStyle.lavender; opacity: 0.8; rotation: root.starTurn; scale: root.linePop }
    EncoreText { anchors.right: parent.right; anchors.rightMargin: 5; y: view.y + view.height / 2 - 10; text: "♡"; font.pixelSize: 18; color: EncoreStyle.pink; opacity: 0.8; rotation: -root.starTurn; scale: root.linePop }
    Item {
        id: ornament
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: caption.top; anchors.bottomMargin: 7
        width: 100; height: 12
        Rectangle { anchors.verticalCenter: parent.verticalCenter; width: 38; height: 2; radius: 1; color: "#bd8add" }
        Rectangle { anchors.verticalCenter: parent.verticalCenter; anchors.right: parent.right; width: 38; height: 2; radius: 1; color: "#bd8add" }
        EncoreText {
            anchors.centerIn: parent
            text: "✦"; color: EncoreStyle.pink; font.pixelSize: 16
            rotation: root.starTurn
            SequentialAnimation on scale {
                running: root.playing && root.visible; loops: Animation.Infinite
                NumberAnimation { from: 0.85; to: 1.2; duration: 650; easing.type: Easing.InOutSine }
                NumberAnimation { from: 1.2; to: 0.85; duration: 650; easing.type: Easing.InOutSine }
            }
        }
    }
    EncoreText {
        id: caption
        anchors.bottom: parent.bottom
        width: parent.width; horizontalAlignment: Text.AlignHCenter
        text: root.trackText; font.pixelSize: 10; font.bold: true; font.letterSpacing: 1
        color: "#ead6fa"; style: Text.Outline; styleColor: "#451f58"
    }
}
