import QtQuick
import qs
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
    implicitWidth: timeText.implicitWidth + Appearance.padding.large * 2
    implicitHeight: timeText.implicitHeight + Appearance.padding.large * 2

    StyledText {
      id: timeText

      anchors.centerIn: parent
      text: Time.format("hh:mm:ss")
      font.pointSize: Appearance.font.size.extraLarge
      font.bold: true
    }
  }
}
