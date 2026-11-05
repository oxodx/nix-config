import qs.theme
import qs.services
import QtQuick
import QtQuick.Layouts
import qs.components

// A number with minus and plus buttons, kept within a range.
Rectangle {
  id: root

  required property string settingKey
  property real min: 0
  property real max: 100
  property real step: 1
  readonly property real value: Number(SettingsService.get(root.settingKey))

  implicitWidth: row.implicitWidth + 6
  implicitHeight: 32
  radius: Appearance.rounding.normal
  color: Appearance.colors.widget
  border.width: 1
  border.color: Appearance.colors.widgetOutlineSeparate

  function nudge(delta: real): void {
    const next = Math.max(root.min, Math.min(root.max, root.value + delta));
    SettingsService.set(root.settingKey, next);
  }

  RowLayout {
    id: row
    anchors.fill: parent
    anchors.margins: 3
    spacing: 4

    Repeater {
      model: [{ glyph: "−", delta: -root.step }, { glyph: "+", delta: root.step }]

      Rectangle {
        required property var modelData
        Layout.preferredWidth: 26
        Layout.preferredHeight: 26
        radius: Appearance.rounding.small
        color: stepHover.containsMouse ? Qt.alpha(Appearance.colors.m3primary, 0.2) : "transparent"
        border.width: stepHover.containsMouse ? 1 : 0
        border.color: Qt.alpha(Appearance.colors.m3primary, 0.6)
        Behavior on color { ColorAnimation { duration: 120 } }

        StyledText {
          anchors.centerIn: parent
          text: modelData.glyph
          font.weight: Font.DemiBold
          color: Appearance.colors.m3onSurface
        }

        MouseArea {
          id: stepHover
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: root.nudge(modelData.delta)
        }
      }
    }

    StyledText {
      Layout.preferredWidth: 44
      horizontalAlignment: Text.AlignHCenter
      text: root.value
      font.weight: Font.DemiBold
      color: Appearance.colors.m3onSurface
    }
  }
}
