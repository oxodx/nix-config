import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs

BarWidgetInner {
  id: root
  required property var bar

  implicitHeight: layout.implicitHeight
  implicitWidth: layout.implicitWidth + 16

  SystemClock {
    id: clock
    precision: tooltip.visible ? SystemClock.Seconds : SystemClock.Minutes
  }

  BarButton {
    id: button
    anchors.fill: parent
    fillWindowWidth: true
    acceptedButtons: Qt.NoButton

    ColumnLayout {
      id: layout
      spacing: -1
      anchors.centerIn: parent

      Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "hh:mm")
        font.pixelSize: 13
        font.weight: Font.DemiBold
        color: "white"
      }

      Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "ddd, MMM d")
        font.pixelSize: 9
        color: "#a8ffffff"
      }
    }
  }

  property TooltipItem tooltip: TooltipItem {
    id: tooltip
    tooltip: bar.tooltip
    owner: root
    show: button.containsMouse

    Loader {
      active: tooltip.visible
      sourceComponent: Label {
        text: Qt.formatDateTime(clock.date, "hh:mm:ss\ndddd, MMMM d, yyyy")
      }
    }
  }
}
