import QtQuick

Item {
    id: root
    property string lineText: "♫"
    property string previousText: ""
    property string nextText: ""
    property string trackText: ""
    property bool playing: false
    property bool synced: false
    property real lineProgress: 0
    property string displayedLine: lineText
    readonly property int lyricSize: width >= 460 ? 29 : 24

    onLineTextChanged: change.restart()
    SequentialAnimation {
        id: change
        NumberAnimation { target: active; property: "opacity"; to: 0; duration: 90 }
        ScriptAction { script: root.displayedLine = root.lineText }
        ParallelAnimation {
            NumberAnimation { target: active; property: "opacity"; from: 0; to: 1; duration: 220 }
            NumberAnimation { target: active; property: "y"; from: 12; to: 0; duration: 440; easing.type: Easing.OutCubic }
            NumberAnimation { target: active; property: "scale"; from: 0.91; to: 1; duration: 520; easing.type: Easing.OutBack; easing.overshoot: 1.35 }
            NumberAnimation { target: active; property: "rotation"; from: 2; to: 0; duration: 440; easing.type: Easing.OutCubic }
        }
    }
    EncoreText {
        anchors.horizontalCenter: parent.horizontalCenter
        y: -7
        text: "✧  " + (root.synced ? "NOW SINGING" : "SIDE B / LITTLE LOVE SONGS") + "  ♡"
        font.pixelSize: 9; font.bold: true; font.letterSpacing: 2
        color: "#e4b2fa"; style: Text.Outline; styleColor: "#371143"
    }
    EncoreText {
        anchors.top: parent.top; anchors.topMargin: 13
        width: parent.width; horizontalAlignment: Text.AlignHCenter
        text: root.previousText; font.pixelSize: 13; font.bold: true
        color: "#ddb4eb"; opacity: 0.7; style: Text.Outline; styleColor: "#451f58"
    }
    Item {
        anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 34 }
        height: Math.max(58, root.height - 90)
        Item {
            id: active
            width: parent.width; height: parent.height
            EncoreText {
                x: 2; y: 4; width: parent.width; height: parent.height
                text: root.displayedLine; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.Wrap
                font.pixelSize: root.lyricSize; font.bold: true
                color: "#491b61"; style: Text.Outline; styleColor: "#250b35"
            }
            EncoreText {
                id: words
                anchors.fill: parent
                text: root.displayedLine; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.Wrap
                font.pixelSize: root.lyricSize; font.bold: true
                color: "#fff0fc"; style: Text.Outline; styleColor: "#703d91"
            }
            // A line-level sweep, not fabricated word timestamps. LRC supplies
            // line starts; the progress uses the next real line timestamp.
            Item {
                height: parent.height
                width: root.synced ? Math.max(0, Math.min(1, root.lineProgress)) * parent.width : 0
                clip: true
                EncoreText {
                    width: active.width; height: active.height
                    text: root.displayedLine; horizontalAlignment: Text.AlignHCenter; wrapMode: Text.Wrap
                    font.pixelSize: root.lyricSize; font.bold: true
                    color: "#f4b0de"; style: Text.Outline; styleColor: "#703d91"
                }
            }
        }
    }
    EncoreText {
        anchors.bottom: ornament.top; anchors.bottomMargin: 5
        width: parent.width; horizontalAlignment: Text.AlignHCenter
        text: root.nextText; font.pixelSize: 12; font.bold: true
        color: "#e7c6ef"; opacity: 0.6; style: Text.Outline; styleColor: "#451f58"
    }
    Item {
        id: ornament
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: caption.top; anchors.bottomMargin: 7
        width: 100; height: 12
        Rectangle { anchors.verticalCenter: parent.verticalCenter; width: 38; height: 2; radius: 1; color: "#bd8add" }
        Rectangle { anchors.verticalCenter: parent.verticalCenter; anchors.right: parent.right; width: 38; height: 2; radius: 1; color: "#bd8add" }
        EncoreText {
            id: diamond
            anchors.centerIn: parent
            text: "✦"; color: EncoreStyle.pink; font.pixelSize: 16
            SequentialAnimation on scale {
                running: root.playing && root.visible; loops: Animation.Infinite
                NumberAnimation { from: 0.85; to: 1.15; duration: 750; easing.type: Easing.InOutSine }
                NumberAnimation { from: 1.15; to: 0.85; duration: 750; easing.type: Easing.InOutSine }
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
