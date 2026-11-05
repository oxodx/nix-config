pragma ComponentBehavior: Bound

import qs.theme
import qs.components
import QtQuick
import QtQuick.Layouts

// The time as SekaiPop's clock does it: each digit in its own outlined tile, a colon, and an
// AM/PM switch with the current half lit.
RowLayout {
  id: root

  property date time: new Date()

  readonly property int hour12: root.time.getHours() % 12 === 0 ? 12 : root.time.getHours() % 12
  readonly property string hh: String(root.hour12).padStart(2, "0")
  readonly property string mm: String(root.time.getMinutes()).padStart(2, "0")
  readonly property bool pm: root.time.getHours() >= 12

  spacing: 6

  Repeater {
    model: root.hh.split("")

    Pill {
      id: hourTile
      required property string modelData

      Layout.preferredWidth: 46
      Layout.preferredHeight: 60
      cornerRadius: Appearance.rounding.normal
      fillColor: Appearance.colors.m3surfaceContainerHigh
      outlineColor: Appearance.colors.ink
      borderWidth: 2
      ringWidth: 2
      ringColor: Qt.alpha(Appearance.colors.m3onSurface, 0.25)
      shadowDy: 4

      StyledText {
        anchors.centerIn: parent
        text: hourTile.modelData
        font.pointSize: Appearance.font.size.extraLarge
        font.weight: Font.Bold
        color: Appearance.colors.m3onSurface
      }
    }
  }

  StyledText {
    text: ":"
    font.pointSize: Appearance.font.size.extraLarge
    font.weight: Font.Bold
    color: Appearance.colors.m3tertiary
  }

  Repeater {
    model: root.mm.split("")

    Pill {
      id: minuteTile
      required property string modelData

      Layout.preferredWidth: 46
      Layout.preferredHeight: 60
      cornerRadius: Appearance.rounding.normal
      fillColor: Appearance.colors.m3surfaceContainerHigh
      outlineColor: Appearance.colors.ink
      borderWidth: 2
      ringWidth: 2
      ringColor: Qt.alpha(Appearance.colors.m3onSurface, 0.25)
      shadowDy: 4

      StyledText {
        anchors.centerIn: parent
        text: minuteTile.modelData
        font.pointSize: Appearance.font.size.extraLarge
        font.weight: Font.Bold
        color: Appearance.colors.m3onSurface
      }
    }
  }

  Pill {
    Layout.preferredWidth: 46
    Layout.preferredHeight: 60
    cornerRadius: Appearance.rounding.normal
    fillColor: Appearance.colors.widgetActive
    outlineColor: Appearance.colors.ink
    borderWidth: 2
    shadowDy: 4

    ColumnLayout {
      anchors.centerIn: parent
      spacing: 0

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: "AM"
        font.pointSize: Appearance.font.size.smaller
        font.weight: root.pm ? Font.Normal : Font.DemiBold
        color: root.pm ? Appearance.colors.m3onSurfaceVariant : Appearance.colors.m3primary
      }
      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: "PM"
        font.pointSize: Appearance.font.size.smaller
        font.weight: root.pm ? Font.DemiBold : Font.Normal
        color: root.pm ? Appearance.colors.m3primary : Appearance.colors.m3onSurfaceVariant
      }
    }
  }
}
