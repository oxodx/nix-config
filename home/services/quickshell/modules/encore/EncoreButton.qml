import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules.common.widgets

Button {
    id: root
    property string symbol: ""
    property color fill: EncoreStyle.paper
    property color foreground: selected || fill.hslLightness > 0.55 ? EncoreStyle.ink : EncoreStyle.text
    property bool selected: false
    property string hint: ""
    hoverEnabled: true
    implicitWidth: Math.max(42, contentItem.implicitWidth + 24)
    implicitHeight: 42
    padding: 10
    opacity: enabled ? 1 : 0.45
    scale: hovered && !down ? 1.025 : 1
    Accessible.name: text || hint || symbol
    ToolTip.visible: hovered && hint.length > 0
    ToolTip.text: hint
    ToolTip.delay: 500

    Behavior on scale {
        NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
    }

    background: EncoreCard {
        radius: 13
        depth: root.down ? 0 : 3
        fill: root.selected ? EncoreStyle.lavender
                            : (root.hovered ? (EncoreStyle.dark ? Qt.lighter(root.fill, 1.16)
                                                                  : Qt.darker(root.fill, 1.045))
                                            : root.fill)
        border.color: root.visualFocus ? EncoreStyle.pink : (root.fill.hslLightness > 0.55 ? EncoreStyle.ink :
                                                                                             EncoreStyle.outline)
        y: root.down ? 3 : 0
        Behavior on y {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
        Behavior on fill { ColorAnimation { duration: 140 } }
        Behavior on border.color { ColorAnimation { duration: 140 } }
    }
    contentItem: RowLayout {
        spacing: 7
        MaterialSymbol {
            visible: root.symbol !== ""
            text: root.symbol
            iconSize: 20
            color: root.foreground
            Layout.alignment: Qt.AlignCenter
        }
        EncoreText {
            visible: root.text !== ""
            text: root.text
            color: root.foreground
            font.bold: true
            Layout.alignment: Qt.AlignCenter
        }
    }
}
