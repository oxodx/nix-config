pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Networking
import qs
import qs.bar

ClickableIcon {
  id: root
  required property var bar
  readonly property var adapter: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
  readonly property var eth: Networking.devices.values.find(d => d.type === DeviceType.Wired) ?? null
  readonly property bool connected: adapter?.connected ?? false
  readonly property var activeNetwork: adapter?.networks.values.find(network => network.connected) ?? null
  readonly property string wifiIcon: {
    if (root.adapter) {
      if (!Networking.wifiEnabled)
        return "image://icon/network-wireless-disabled-symbolic";
      if (!root.adapter.connected)
        return "image://icon/network-wireless-offline-symbolic";
      const strength = root.activeNetwork?.signalStrength ?? 0;
      const level = strength > 0.75 ? "excellent" : strength > 0.5 ? "good" : strength > 0.25 ? "ok" : "weak";
      return `image://icon/network-wireless-signal-${level}-symbolic`;
    }

    return "image://icon/network-wireless-offline-symbolic";
  }

  readonly property string ethIcon: {
    if (root.eth) {
      if (!root.eth.network)
        return "image://icon/network-wired-disconnected-symbolic";
      else if (!root.eth.network.connected)
        return "image://icon/network-wired-disconnected-symbolic";
      else
        return "image://icon/network-wired-symbolic";
    }

    return "image://icon/network-wired-disconnected-symbolic";
  }

  property bool showMenu: false

  onPressed: event => {
    event.accepted = true;
    if (event.button === Qt.RightButton) {
      showMenu = !showMenu;
    }
  }

  onClicked: event => {
    if (event.button === Qt.LeftButton) {
      Networking.wifiEnabled = !Networking.wifiEnabled;
    }
  }

  showPressed: showMenu || (pressedButtons & ~Qt.RightButton)

  implicitHeight: width
  fillWindowWidth: true
  acceptedButtons: Qt.LeftButton | Qt.RightButton
  image: {
    if (root.eth?.network && root.eth.network.connected) {
      return "image://icon/network-wired-symbolic";
    } else if (Networking.wifiEnabled) {
      return root.wifiIcon;
    } else if (root.eth?.network) {
      return "image://icon/network-wired-disconnected-symbolic";
    } else {
      return "image://icon/network-wired-disconnected-symbolic";
    }
  }

  property var tooltip: TooltipItem {
    tooltip: bar.tooltip
    owner: root
    show: root.containsMouse

    Label {
      text: "Network"
    }
  }

  property var rightclickMenu: TooltipItem {
    id: rightclickMenu
    tooltip: bar.tooltip
    owner: root

    isMenu: true
    show: root.showMenu
    onClose: root.showMenu = false

    Loader {
      width: 400
      active: root.showMenu || rightclickMenu.visible

      sourceComponent: Column {
        spacing: 5

        move: Transition {
          SmoothedAnimation {
            property: "y"
            velocity: 350
          }
        }

        Loader {
          width: parent.width
          active: root.eth != null
          visible: active
          sourceComponent: ColumnLayout {
            RowLayout {
              Layout.fillWidth: true

              ClickableIcon {
                image: root.ethIcon
                implicitHeight: 40
                implicitWidth: height
                onClicked: {
                  const n = root.eth.network;
                  if (n.connected)
                    n.disconnect();
                  else
                    n.connect();
                }
              }

              Label {
                text: `Ethernet (${root.eth?.name ?? ""})`
              }
            }

            Rectangle {
              Layout.fillWidth: true
              implicitHeight: 1
              color: Appearance.colors.separator
              visible: root.adapter != null
            }
          }
        }

        Loader {
          width: parent.width
          active: root.adapter != null
          visible: active
          sourceComponent: ColumnLayout {
            RowLayout {
              Layout.fillWidth: true
              ClickableIcon {
                image: root.wifiIcon
                implicitHeight: 40
                implicitWidth: height
                onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
              }

              Label {
                text: `Wifi (${root.adapter.name})`
              }

              Item {
                Layout.fillWidth: true
              }

              ActivityButton {
                image: "root:/icons/binoculars.svg"
                implicitHeight: 24
                implicitWidth: height
                onClicked: root.adapter.scannerEnabled = !root.adapter.scannerEnabled
                showAction: root.adapter.scannerEnabled
                Layout.rightMargin: 4
              }
            }

            Rectangle {
              Layout.fillWidth: parent
              implicitHeight: 1
              visible: root.adapter.networks.values.length > 0

              color: Appearance.colors.separator
            }

            Repeater {
              model: ScriptModel {
                values: [...root.adapter.networks.values].sort((a, b) => {
                  if (a.connected && !b.connected)
                    return -1;
                  if (b.connected && !a.connected)
                    return 1;
                  if (a.bonded && !b.bonded)
                    return -1;
                  if (b.bonded && !a.bonded)
                    return 1;
                  return b.name - a.name;
                })
              }

              delegate: NetworkDelegate {
                required property var modelData
                Layout.fillWidth: parent
                device: root.adapter
                network: modelData
                width: parent.width
                onConnectionAttempted: root.adapter.scannerEnabled = false
              }
            }
          }
        }
      }
    }
  }
}
