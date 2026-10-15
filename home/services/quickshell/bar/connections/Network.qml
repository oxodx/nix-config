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
        return "wifi_off";
      if (!root.adapter.connected)
        return "wifi_find";
      const strength = root.activeNetwork?.signalStrength ?? 0;
      return strength > 0.75 ? "wifi" : strength > 0.5 ? "wifi_2_bar" : "wifi_1_bar";
    }

    return "wifi_off";
  }

  readonly property string ethIcon: {
    if (root.eth) {
      if (!root.eth.network)
        return "lan";
      else if (!root.eth.network.connected)
        return "lan";
      else
        return "lan";
    }

    return "lan";
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
  icon: {
    if (root.eth?.network && root.eth.network.connected) {
      return "lan";
    } else if (Networking.wifiEnabled) {
      return root.wifiIcon;
    } else if (root.eth?.network) {
      return "wifi_off";
    } else {
      return "wifi_off";
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
                icon: root.ethIcon
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
                icon: root.wifiIcon
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
                icon: "search"
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
