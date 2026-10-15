import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs
import qs.bar
import qs.bar.dashboard as Dashboard

BarWidgetInner {
  id: root
  required property var bar
  property bool dashboardOpen: false

  implicitHeight: 30
  implicitWidth: layout.implicitWidth + 12

  SystemClock {
    id: clock
    precision: tooltip.visible ? SystemClock.Seconds : SystemClock.Minutes
  }

  BarButton {
    id: button
    anchors.fill: parent
    fillWindowWidth: true
    acceptedButtons: Qt.LeftButton
    showPressed: root.dashboardOpen
    onPressed: root.dashboardOpen = !root.dashboardOpen

    ColumnLayout {
      id: layout
      spacing: -1
      anchors.centerIn: parent

      Text {
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "hh:mm")
        font.pixelSize: 12
        font.weight: Font.DemiBold
        color: Appearance.colors.m3tertiary
      }

      Text {
        visible: false
        Layout.alignment: Qt.AlignHCenter
        text: Qt.formatDateTime(clock.date, "ddd, MMM d")
        font.pixelSize: 10
        color: "#a8ffffff"
      }
    }
  }

  property TooltipItem tooltip: TooltipItem {
    id: tooltip
    tooltip: bar.tooltip
    owner: root
    show: button.containsMouse && !root.dashboardOpen

    Loader {
      active: tooltip.visible
      sourceComponent: Label {
        text: Qt.formatDateTime(clock.date, "hh:mm:ss\ndddd, MMMM d, yyyy")
      }
    }
  }

  property TooltipItem dashboard: TooltipItem {
    tooltip: root.bar.tooltip
    owner: root
    isMenu: true
    customBackground: true
    animateSize: false
    show: root.dashboardOpen
    onClose: root.dashboardOpen = false

    contentItem {
      implicitWidth: 760
      implicitHeight: 660
    }

    Dashboard.Dashboard {
      anchors.fill: parent
      onRequestClose: root.dashboardOpen = false
    }
  }
}
