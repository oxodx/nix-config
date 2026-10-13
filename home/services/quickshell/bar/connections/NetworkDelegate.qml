import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Networking
import qs
import qs.bar

WrapperMouseArea {
  id: root
  required property NetworkDevice device
  required property WifiNetwork network
  property bool menuOpen: false
  property bool passwordRequired: false
  readonly property bool showBg: root.passwordRequired
  hoverEnabled: true

  signal connectionAttempted

  function tryConnect() {
    const connecting = root.network.connected || root.network.state == ConnectionState.Connecting;
    if (connecting)
      root.device.disconnect();
    else {
      root.connectionAttempted();
      if (pwField.text != "")
        root.network.connectWithPsk(pwField.text);
      else
        root.network.connect();
    }
  }

  onClicked: menuOpen = !menuOpen

  Connections {
    target: root.network
    function onConnectionFailed(reason) {
      console.log(reason, reason == ConnectionFailReason.NoSecrets);
      pwField.text = "";
      root.passwordRequired = reason == ConnectionFailReason.NoSecrets;
    }

    function onStateChanged() {
      if (root.network.state == ConnectionState.Connected) {
        root.passwordRequired = false;
        pwField.text = "";
      }
    }
  }

  WrapperRectangle {
    color: root.showBg ? Appearance.colors.widget : "transparent"
    border.width: 1
    border.color: root.showBg ? Appearance.colors.widgetOutline : "transparent"
    radius: 4

    ColumnLayout {
      RowLayout {
        ClickableIcon {
          image: `root:/icons/wifi-${Math.round(root.network.signalStrength * 3)}`
          implicitHeight: 40
          implicitWidth: height
        }

        Label {
          text: root.network.name
        }

        Item {
          Layout.fillWidth: true
        }

        ActivityButton {
          image: root.network.connected ? "root:/icons/plugs-connected.svg" : "root:/icons/plugs.svg"
          implicitHeight: 24
          implicitWidth: height
          showAction: root.network.stateChanging
          onClicked: tryConnect()
        }

        ClickableIcon {
          image: "root:/icons/trash.svg"
          implicitHeight: 24
          implicitWidth: height
          visible: root.network.known
          onClicked: root.network.forget()
          Layout.rightMargin: 2
        }
      }

      TextField {
        id: pwField
        visible: root.passwordRequired
        Layout.fillWidth: true
        Layout.margins: 4
        placeholderText: "Password"
        echoMode: TextInput.Password
        enabled: !(root.network.stateChanging || root.network.connected)
        onAccepted: tryConnect()

        background: Rectangle {
          color: pwField.enabled ? "transparent" : Appearance.colors.widgetActive
          border.color: Appearance.colors.widgetOutline
          radius: 4
        }
      }
    }
  }
}
