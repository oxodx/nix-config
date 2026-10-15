import qs.theme
import QtQuick
import qs.services
import qs.components

Loader {
  asynchronous: true
  active: true

  anchors {
    right: parent.right
    bottom: parent.bottom
    margins: Appearance.padding.large
  }

  sourceComponent: Item {
    implicitWidth: timeText.implicitWidth + Appearance.padding.large * 3
    implicitHeight: timeText.implicitHeight + Appearance.padding.large * 2

    SkewedSurface {
      anchors.fill: parent
      slantLeft: true
      slantRight: true
      slant: 18
      fillColor: Appearance.colors.panelTranslucent
      outlineColor: Appearance.colors.widgetOutlineSeparate
      shadowOffset: 4
    }

    StyledText {
      id: timeText

      anchors.centerIn: parent
      text: Time.format("hh:mm:ss")
      font.pointSize: Appearance.font.size.extraLarge
      font.bold: true
    }
  }
}
