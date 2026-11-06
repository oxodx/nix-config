import QtQuick
import QtQuick.Layouts
import qs.services

EncoreCard {
    id: root
    property date month: new Date(DateTime.clock.date.getFullYear(), DateTime.clock.date.getMonth(), 1)
    readonly property int offset: (new Date(month.getFullYear(), month.getMonth(), 1).getDay() + 6) % 7
    readonly property int days: new Date(month.getFullYear(), month.getMonth() + 1, 0).getDate()
    implicitHeight: 280
    radius: 13
    function move(delta) { month = new Date(month.getFullYear(), month.getMonth() + delta, 1) }
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 16; spacing: 9
        RowLayout {
            Layout.fillWidth: true
            EncoreText { Layout.fillWidth: true; text: Qt.locale().toString(root.month, "MMMM yyyy"); font.bold: true; font.pixelSize: 19 }
            EncoreButton { symbol: "chevron_left"; implicitHeight: 28; implicitWidth: 28; padding: 2; hint: "Previous month"; onClicked: root.move(-1) }
            EncoreButton { symbol: "chevron_right"; implicitHeight: 28; implicitWidth: 28; padding: 2; hint: "Next month"; onClicked: root.move(1) }
        }
        GridLayout {
            Layout.fillWidth: true; Layout.fillHeight: true
            columns: 7; columnSpacing: 3; rowSpacing: 3
            Repeater { model: ["M", "T", "W", "T", "F", "S", "S"]; EncoreText { required property string modelData; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter; text: modelData; font.bold: true; font.pixelSize: 10; color: EncoreStyle.muted } }
            Repeater {
                model: 42
                Rectangle {
                    required property int index
                    readonly property int day: index - root.offset + 1
                    readonly property bool today: day === DateTime.clock.date.getDate() && root.month.getMonth() === DateTime.clock.date.getMonth() && root.month.getFullYear() === DateTime.clock.date.getFullYear()
                    Layout.fillWidth: true; Layout.fillHeight: true
                    radius: 5
                    color: today ? EncoreStyle.pink : (index % 7 > 4 ? EncoreStyle.surface : "transparent")
                    EncoreText { anchors.centerIn: parent; text: parent.day > 0 && parent.day <= root.days ? parent.day : ""; font.pixelSize: 11; font.bold: parent.today; color: parent.today ? EncoreStyle.ink : EncoreStyle.text }
                }
            }
        }
    }
}
