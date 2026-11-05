pragma ComponentBehavior: Bound
import qs.theme
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

SkewedSurface {
  id: root
  implicitHeight: 290
  slantLeft: true
  slantRight: true
  skew: Appearance.skew
  fillColor: Appearance.colors.widget
  shadowColor: "transparent"

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 24
    spacing: 14

    StyledText {
      text: "SYSTEM / LIVE"
      color: Appearance.colors.m3tertiary
      font.weight: Font.Bold
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 10

      RowLayout {
        Layout.fillWidth: true
        MaterialIcon {
          text: "memory"
          color: Appearance.colors.m3primary
        }
        StyledText {
          Layout.fillWidth: true
          text: "Processor"
        }
        StyledText {
          text: Math.round(SystemStats.cpu * 100) + "%"
          font.family: Appearance.font.family.mono
        }
      }

      ProgressBar {
        Layout.fillWidth: true
        from: 0
        to: 1
        value: SystemStats.cpu
        thickness: 6
        cornerRadius: 3
        fillColor: Appearance.colors.m3primary
        trackColor: Appearance.colors.widgetActive
        Behavior on value {
          NumberAnimation { duration: 900; easing.type: Easing.OutCubic }
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 10

      RowLayout {
        Layout.fillWidth: true
        MaterialIcon {
          text: "storage"
          color: Appearance.colors.m3primary
        }
        StyledText {
          Layout.fillWidth: true
          text: "Memory"
        }
        StyledText {
          text: Math.round(SystemStats.memory * 100) + "%"
          font.family: Appearance.font.family.mono
        }
      }

      ProgressBar {
        Layout.fillWidth: true
        from: 0
        to: 1
        value: SystemStats.memory
        thickness: 6
        cornerRadius: 3
        fillColor: Appearance.colors.m3primary
        trackColor: Appearance.colors.widgetActive
        Behavior on value {
          NumberAnimation { duration: 900; easing.type: Easing.OutCubic }
        }
      }
    }

    Item {
      Layout.fillHeight: true
    }

    StyledText {
      text: "Updated every 2 seconds"
      opacity: 0.5
      font.pointSize: Appearance.font.size.small
    }
  }
}
