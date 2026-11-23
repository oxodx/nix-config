import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs.services
import qs.modules.common

EncoreCard {
    id: root
    required property bool bluetooth
    property var network: Network
    property var adapter: Bluetooth.defaultAdapter
    property var devices: BluetoothStatus.friendlyDeviceList
    readonly property bool powered: bluetooth ? (adapter?.enabled ?? false) : network.wifiEnabled
    readonly property bool scanning: bluetooth ? (adapter?.discovering ?? false) : network.wifiScanning
    property var discoveryAdapter: null
    property bool ready: false
    implicitHeight: content.implicitHeight + 28
    fill: EncoreStyle.surface

    function scan() {
        if (bluetooth) {
            if (!adapter?.enabled) return;
            if (!adapter.discovering) {
                adapter.discovering = true;
                discoveryAdapter = adapter;
            }
        } else if (network.wifiEnabled && !network.wifiScanning) {
            network.rescanWifi();
        }
    }

    Component.onCompleted: {
        ready = true;
        scan();
    }
    onPoweredChanged: if (ready) scan()
    onAdapterChanged: {
        if (discoveryAdapter && discoveryAdapter !== adapter) {
            discoveryAdapter.discovering = false;
            discoveryAdapter = null;
        }
        if (ready) scan();
    }
    Component.onDestruction: {
        if (discoveryAdapter) discoveryAdapter.discovering = false;
    }

    ColumnLayout {
        id: content
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
        spacing: 10
        RowLayout {
            Layout.fillWidth: true
            EncoreText {
                text: root.bluetooth ? "Bluetooth devices" : "Wi-Fi networks"
                font.bold: true
                Layout.fillWidth: true
            }
            EncoreButton {
                objectName: "connectionPower"
                symbol: root.powered ? "toggle_on" : "toggle_off"
                selected: root.powered
                enabled: !root.bluetooth || root.adapter !== null
                hint: root.powered ? "Turn off" : "Turn on"
                implicitHeight: 34
                onClicked: {
                    if (root.bluetooth) {
                        if (root.adapter) root.adapter.enabled = !root.adapter.enabled;
                    } else root.network.toggleWifi();
                }
            }
            EncoreButton {
                objectName: "connectionRefresh"
                symbol: "refresh"
                hint: "Scan again"
                implicitHeight: 34
                enabled: root.powered && !root.scanning
                onClicked: root.scan()
            }
        }
        EncoreText {
            Layout.fillWidth: true
            visible: !root.powered || root.scanning || deviceRepeater.count === 0
            font.pixelSize: 12
            color: EncoreStyle.muted
            text: root.bluetooth && !root.adapter ? "No Bluetooth adapter found"
                : !root.powered ? "Turn on " + (root.bluetooth ? "Bluetooth" : "Wi-Fi") + " to find devices"
                : root.scanning ? "Searching…"
                : root.bluetooth ? "No devices found" : "No networks found"
        }
        Repeater {
            id: deviceRepeater
            model: !root.powered ? [] : root.bluetooth ? root.devices : root.network.friendlyWifiNetworks
            delegate: ColumnLayout {
                id: entry
                required property var modelData
                readonly property bool busy: root.bluetooth ? (modelData.pairing ?? false)
                    : root.network.wifiConnecting && root.network.wifiConnectTarget === modelData
                Layout.fillWidth: true
                spacing: 6
                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        EncoreText {
                            Layout.fillWidth: true
                            text: root.bluetooth ? entry.modelData.name || "Unknown device" : entry.modelData.ssid || "Hidden network"
                            font.bold: true
                            font.pixelSize: 12
                        }
                        EncoreText {
                            Layout.fillWidth: true
                            font.pixelSize: 10
                            color: EncoreStyle.muted
                            text: root.bluetooth
                                ? entry.busy ? "Pairing…" : entry.modelData.connected ? "Connected" : entry.modelData.paired ? "Paired" : "Not paired"
                                : entry.busy ? "Connecting…" : entry.modelData.active ? "Connected" : entry.modelData.strength + "% · " + (entry.modelData.isSecure ? "Secured" : "Open")
                        }
                    }
                    EncoreButton {
                        objectName: "connectionAction"
                        implicitHeight: 34
                        text: root.bluetooth
                            ? entry.modelData.connected ? "Disconnect" : entry.modelData.paired ? "Connect" : "Pair"
                            : entry.modelData.active ? "Disconnect" : "Connect"
                        enabled: !entry.busy
                        onClicked: {
                            if (root.bluetooth) {
                                if (entry.modelData.connected) entry.modelData.disconnect();
                                else if (!entry.modelData.paired) entry.modelData.pair();
                                else entry.modelData.connect();
                            } else if (entry.modelData.active) root.network.disconnectWifiNetwork();
                            else root.network.connectToWifiNetwork(entry.modelData);
                        }
                    }
                    EncoreButton {
                        visible: root.bluetooth && (entry.modelData.paired ?? false)
                        symbol: "delete"
                        hint: "Forget device"
                        implicitHeight: 34
                        enabled: !entry.busy
                        onClicked: entry.modelData.forget()
                    }
                }
                RowLayout {
                    visible: !root.bluetooth && (entry.modelData.askingPassword ?? false)
                    Layout.fillWidth: true
                    TextField {
                        id: password
                        objectName: "wifiPassword"
                        Layout.fillWidth: true
                        placeholderText: "Wi-Fi password"
                        echoMode: TextInput.Password
                        color: EncoreStyle.text
                        Accessible.name: "Wi-Fi password"
                        onAccepted: root.network.changePassword(entry.modelData, text)
                    }
                    EncoreButton {
                        text: "Join"
                        enabled: password.text.length > 0
                        onClicked: root.network.changePassword(entry.modelData, password.text)
                    }
                }
            }
        }
        EncoreButton {
            Layout.fillWidth: true
            text: "More settings"
            symbol: "settings"
            hint: root.bluetooth ? "Pairing codes and Bluetooth settings" : "Advanced network settings"
            onClicked: Quickshell.execDetached(["bash", "-c", root.bluetooth ? Config.options.apps.bluetooth : Config.options.apps.network])
        }
    }
}
