import qs.theme
import qs.services
import QtQuick

// A switch bound to a true/false setting.
Item {
  id: root

  required property string settingKey
  readonly property bool on: SettingsService.flag(root.settingKey)

  implicitWidth: 44
  implicitHeight: 24

  Rectangle {
    anchors.fill: parent
    radius: height / 2
    color: root.on ? Appearance.colors.m3primary : Appearance.colors.widgetActive
    border.width: 1
    border.color: Appearance.colors.widgetOutlineSeparate
    Behavior on color { ColorAnimation { duration: 150 } }

    Rectangle {
      width: 18
      height: 18
      radius: 9
      y: 2
      x: root.on ? parent.width - width - 3 : 3
      color: root.on ? Appearance.colors.m3onPrimary : Appearance.colors.m3onSurfaceVariant
      Behavior on x { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }
    }
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: SettingsService.toggle(root.settingKey)
  }
}
