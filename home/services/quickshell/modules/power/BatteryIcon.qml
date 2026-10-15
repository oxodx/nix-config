import qs.theme
import QtQuick
import Quickshell.Services.UPower
import qs.components

Item {
  id: root
  required property UPowerDevice device
  readonly property bool isCharging: device.state === UPowerDeviceState.Charging
  readonly property real percentage: Math.max(0, Math.min(1, device.percentage))
  implicitWidth: 30
  implicitHeight: 20

  MaterialIcon {
    anchors.centerIn: parent
    font.pointSize: 17
    fill: 1
    color: root.percentage <= 0.2 ? Appearance.colors.m3error : Appearance.colors.m3primary
    text: {
      if (root.isCharging)
        return "battery_charging_full";
      if (root.percentage >= 0.95)
        return "battery_full";
      if (root.percentage <= 0.05)
        return "battery_alert";
      return "battery_" + Math.min(6, Math.floor(root.percentage * 7)) + "_bar";
    }
  }
}
