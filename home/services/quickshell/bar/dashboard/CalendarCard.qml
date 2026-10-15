pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.components

SkewedSurface {
  id: root
  implicitHeight: 290
  slantLeft: true
  slantRight: true
  slant: 14
  shadowColor: "transparent"
  fillColor: Appearance.colors.widget
  property date month: new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)
  readonly property int offset: (month.getDay() + 6) % 7
  SystemClock { id: clock; precision: SystemClock.Minutes }

  function moveMonth(delta) {
    month = new Date(month.getFullYear(), month.getMonth() + delta, 1);
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 8
    RowLayout {
      Layout.fillWidth: true
      DashboardAction {
        implicitWidth: 38; implicitHeight: 36
        icon: "chevron_left"; label: ""
        onTriggered: root.moveMonth(-1)
      }
      StyledText {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        text: Qt.formatDateTime(root.month, "MMMM yyyy")
        font.weight: Font.Bold
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: root.month = new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)
        }
      }
      DashboardAction {
        implicitWidth: 38; implicitHeight: 36
        icon: "chevron_right"; label: ""
        onTriggered: root.moveMonth(1)
      }
    }
    GridLayout {
      columns: 7
      columnSpacing: 3
      rowSpacing: 3
      Layout.fillWidth: true
      Layout.fillHeight: true
      Repeater {
        model: ["M", "T", "W", "T", "F", "S", "S"]
        StyledText {
          required property string modelData
          Layout.fillWidth: true
          horizontalAlignment: Text.AlignHCenter
          text: modelData
          color: Appearance.colors.m3tertiary
          font.pointSize: Appearance.font.size.small
        }
      }
      Repeater {
        model: 42
        SkewedSurface {
          id: cell
          required property int index
          readonly property date day: new Date(root.month.getFullYear(), root.month.getMonth(), index - root.offset + 1)
          readonly property bool today: day.toDateString() === clock.date.toDateString()
          Layout.fillWidth: true
          Layout.fillHeight: true
          slantLeft: true; slantRight: true; slant: 5
          shadowColor: "transparent"
          outlineColor: "transparent"
          fillColor: today ? Appearance.colors.m3primaryContainer : "transparent"
          StyledText {
            anchors.centerIn: parent
            text: cell.day.getDate()
            opacity: cell.day.getMonth() === root.month.getMonth() ? 1 : 0.3
            font.pointSize: Appearance.font.size.small
            font.weight: cell.today ? Font.Bold : Font.Normal
          }
        }
      }
    }
  }
}
