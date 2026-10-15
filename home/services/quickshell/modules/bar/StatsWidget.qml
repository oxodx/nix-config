pragma ComponentBehavior: Bound
import qs.theme
import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

RowLayout {
  spacing: 12
  Repeater {
    model: [ { icon: "memory", value: SystemStats.cpu }, { icon: "storage", value: SystemStats.memory } ]
    RowLayout {
      required property var modelData
      spacing: 4
      MaterialIcon { text: modelData.icon; font.pointSize: 12; color: Appearance.colors.m3primary }
      StyledText {
        Layout.preferredWidth: 34
        text: Math.round(modelData.value * 100) + "%"
        font.pointSize: 9
        font.weight: Font.Medium
        color: Appearance.colors.m3tertiary
      }
    }
  }
}
