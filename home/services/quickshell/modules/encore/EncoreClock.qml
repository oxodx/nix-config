import QtQuick
import QtQuick.Layouts
import qs.services

EncoreCard {
    implicitHeight: 184; radius: 13
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 9
        EncoreText { text: DateTime.longDate; font.bold: true; font.pixelSize: 15; Layout.fillWidth: true }
        RowLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 6
            Repeater {
                model: DateTime.time.split("")
                Item {
                    required property string modelData
                    required property int index
                    Layout.fillWidth: modelData !== ":"
                    Layout.preferredWidth: modelData === ":" ? 10 : 40
                    Layout.fillHeight: true
                    EncoreCard { anchors.fill: parent; visible: parent.modelData !== ":"; radius: 11; fill: parent.index < 2 ? EncoreStyle.surface : EncoreStyle.pink; rotation: parent.index % 2 ? 3 : -3 }
                    EncoreText { anchors.centerIn: parent; text: parent.modelData; font.pixelSize: 38; font.bold: true; color: parent.modelData !== ":" && parent.index > 2 ? EncoreStyle.ink : EncoreStyle.text }
                }
            }
        }
        EncorePrideStripe { Layout.fillWidth: true; implicitHeight: 5; Layout.topMargin: 7 }
        EncoreText { text: "A VERY GOOD TIME TO BE YOU."; font.pixelSize: 8; color: EncoreStyle.muted; font.letterSpacing: 1 }
    }
}
