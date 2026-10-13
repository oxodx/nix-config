import QtQuick
import Quickshell.Services.UPower

Item {
  id: root
  required property UPowerDevice device

  readonly property bool isCharging: root.device.state == UPowerDeviceState.Charging
  readonly property bool isPluggedIn: isCharging || root.device.state == UPowerDeviceState.PendingCharge
  readonly property real percentage: Math.max(0, Math.min(1, root.device.percentage))
  readonly property bool isLow: percentage <= 0.20
  readonly property color levelColor: isPluggedIn ? "#72dc86" : isLow ? "#ff6b72" : "#f4f6fb"

  implicitWidth: 30
  implicitHeight: 20

  Rectangle {
    id: body
    anchors {
      verticalCenter: parent.verticalCenter
      left: parent.left
      leftMargin: 2
    }
    width: Math.max(16, root.width - 8)
    height: Math.max(10, Math.min(16, root.height - 10))
    radius: 3
    color: "transparent"
    border.width: 2
    border.color: "#e8ebf2"

    Rectangle {
      anchors {
        left: parent.left
        top: parent.top
        bottom: parent.bottom
        margins: 3
      }
      width: Math.max(0, (parent.width - 6) * root.percentage)
      radius: Math.min(2, height / 2)
      color: root.levelColor
    }
  }

  Rectangle {
    anchors {
      left: body.right
      leftMargin: 1
      verticalCenter: body.verticalCenter
    }
    width: 3
    height: Math.max(6, body.height * 0.45)
    radius: 1
    color: "#e8ebf2"
  }

  Text {
    anchors.centerIn: body
    visible: root.isCharging
    text: "↯"
    color: "#11131a"
    font.pixelSize: Math.max(9, body.height - 3)
    font.bold: true
  }
}
