pragma ComponentBehavior: Bound
import qs.theme
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components

SkewedSurface {
  id: root
  implicitHeight: 290
  slantLeft: true
  slantRight: true
  skew: Appearance.skew
  fillColor: Appearance.colors.widget
  property date month: new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)
  readonly property int offset: (month.getDay() + 6) % 7

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

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
        implicitWidth: 38
        implicitHeight: 36
        icon: "chevron_left"
        label: ""
        onTriggered: root.moveMonth(-1)
      }

      Pill {
        Layout.fillWidth: true
        Layout.preferredHeight: 36
        cornerRadius: Appearance.rounding.normal
        fillColor: Appearance.colors.widgetActive
        shadowDy: 3

        StyledText {
          anchors.centerIn: parent
          text: Qt.formatDateTime(root.month, "MMMM yyyy")
          font.weight: Font.Bold
        }

        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: root.month = new Date(clock.date.getFullYear(), clock.date.getMonth(), 1)
        }
      }

      DashboardAction {
        implicitWidth: 38
        implicitHeight: 36
        icon: "chevron_right"
        label: ""
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
        model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
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
        Pill {
          id: cell
          required property int index
          readonly property date day: new Date(root.month.getFullYear(), root.month.getMonth(), index - root.offset + 1)
          readonly property bool today: day.toDateString() === clock.date.toDateString()
          Layout.fillWidth: true
          Layout.fillHeight: true
          cornerRadius: Appearance.rounding.small
          fillColor: today ? Appearance.colors.m3primary : "transparent"
          outlineColor: Appearance.colors.ink
          borderWidth: today ? 2 : 0
          shadowDy: today ? 2 : 0

          StyledText {
            anchors.centerIn: parent
            color: cell.today ? Appearance.colors.m3onPrimary : Appearance.colors.m3onSurface
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
