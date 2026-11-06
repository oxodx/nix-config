import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

EncoreButton {
    id: root
    property string detail: ""
    implicitHeight: 92
    padding: 12
    scale: Config.options.encore.motion && hovered ? 1.025 : 1
    Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack; easing.overshoot: 0.6 } }
    contentItem: ColumnLayout {
        spacing: 4
        RowLayout {
            Layout.fillWidth: true
            MaterialSymbol { text: root.symbol; iconSize: 22; color: root.foreground }
            Item { Layout.fillWidth: true }
            Rectangle { width: 6; height: 6; radius: 3; color: root.selected ? EncoreStyle.ink : EncoreStyle.muted; opacity: root.selected ? 1 : 0.4 }
        }
        EncoreText { text: root.text; Layout.fillWidth: true; font.bold: true; font.pixelSize: 13; color: root.foreground }
        EncoreText { text: root.detail; Layout.fillWidth: true; font.pixelSize: 10; color: root.foreground; opacity: 0.75 }
    }
}
