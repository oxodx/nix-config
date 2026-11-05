import QtQuick
import qs.theme

// A pill-shaped switch with a mint thumb that slides (and overshoots a
// little) under the chosen label: the clock widget's AM / PM switch, for any
// number of options.
//
//   SegmentSwitch {
//       width: 150; height: 28
//       options: [ { id: "hourly", label: "Hourly" }, { id: "days", label: "Days" } ]
//       current: "days"
//       onPicked: id => ...
//   }
Item {
    id: root

    // Theme keys this widget uses, taken from Appearance.
    // Our theme, in the names this widget expects.
    readonly property var mt: ({
        surfaceHover: Appearance.colors.widgetActive,
        line: Appearance.colors.widgetOutlineSeparate,
        borderWidth: 1,
        accentMint: Appearance.colors.m3primary,
        colBorder: Appearance.colors.m3onPrimary,
        inkSub: Appearance.colors.m3onSurfaceVariant,
        fontFamily: Appearance.font.family.sans,
        fontStyleBold: ""
    })

    property var options: []
    property string current: ""
    signal picked(string id)

    readonly property int count: Math.max(1, root.options.length)
    readonly property real slot: (root.width - 6) / root.count
    readonly property int index: {
        for (let i = 0; i < root.options.length; i++)
            if (root.options[i].id === root.current)
                return i
        return 0
    }

    implicitWidth: 150
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent
        radius: height / 2.4
        color: mt.surfaceHover
        border.width: mt.borderWidth
        border.color: mt.line
        antialiasing: true
    }

    Rectangle {
        y: 3
        height: root.height - 6
        width: root.slot
        x: 3 + root.index * root.slot
        radius: (root.height - 6) / 2.4
        color: mt.accentMint
        antialiasing: true

        Behavior on x {
            NumberAnimation { duration: 280; easing.type: Easing.OutBack; easing.overshoot: 1.8 }
        }
    }

    Repeater {
        model: root.options

        delegate: Item {
            required property var modelData
            required property int index
            x: 3 + index * root.slot
            width: root.slot
            height: root.height

            Text {
                anchors.centerIn: parent
                width: parent.width - 10
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
                text: modelData.label
                color: index === root.index ? mt.colBorder : mt.inkSub
                font.family: mt.fontFamily
                font.pixelSize: 12
                font.weight: Font.ExtraBold
                font.styleName: mt.fontStyleBold
                Behavior on color { ColorAnimation { duration: 140 } }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.picked(modelData.id)
            }
        }
    }
}
