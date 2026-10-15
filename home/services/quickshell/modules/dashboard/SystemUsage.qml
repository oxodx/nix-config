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
  slant: 14
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

    Repeater {
      model: [
        {
          label: "Processor",
          icon: "memory",
          value: SystemStats.cpu
        },
        {
          label: "Memory",
          icon: "storage",
          value: SystemStats.memory
        }
      ]

      ColumnLayout {
        required property var modelData
        Layout.fillWidth: true
        spacing: 10

        RowLayout {
          MaterialIcon {
            text: modelData.icon
            color: Appearance.colors.m3primary
          }

          StyledText {
            Layout.fillWidth: true
            text: modelData.label
          }

          StyledText {
            text: Math.round(modelData.value * 100) + "%"
            font.family: Appearance.font.family.mono
          }
        }

        SkewedSurface {
          Layout.fillWidth: true
          implicitHeight: 8
          slantLeft: true
          slantRight: true
          slant: 4
          shadowColor: "transparent"
          fillColor: Appearance.colors.widgetActive

          SkewedSurface {
            width: Math.max(8, parent.width * modelData.value)
            height: parent.height
            slantLeft: true
            slantRight: true
            slant: 4
            shadowColor: "transparent"
            fillColor: Appearance.colors.m3primary
            Behavior on width {
              NumberAnimation {
                duration: 350
                easing.type: Easing.OutCubic
              }
            }
          }
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
