#!/usr/bin/env python3
"""Run Encore's actual connection panels offscreen with fake radios and networks."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

SOURCE = Path(__file__).resolve().parents[1]

with tempfile.TemporaryDirectory(prefix="encore-connections-") as directory:
    root = Path(directory)
    encore = root / "modules/encore"
    encore.mkdir(parents=True)
    for name in ["EncoreConnections", "EncoreControlTile", "EncoreButton", "EncoreCard", "EncoreText", "EncoreStyle"]:
        shutil.copy(SOURCE / f"{name}.qml", encore)
    (encore / "qmldir").write_text("singleton EncoreStyle 1.0 EncoreStyle.qml\n" + "".join(f"{name} 1.0 {name}.qml\n" for name in ["EncoreConnections", "EncoreControlTile", "EncoreButton", "EncoreCard", "EncoreText"]))
    common = root / "modules/common"
    widgets = common / "widgets"
    widgets.mkdir(parents=True)
    (common / "qmldir").write_text("singleton Config 1.0 Config.qml\nsingleton Appearance 1.0 Appearance.qml\n")
    (common / "Config.qml").write_text('pragma Singleton\nimport QtQuick\nQtObject { property var options: ({encore: {darkMode: false, accentColor: "#bf8de9", motion: false}, apps: {bluetooth: "", network: ""}}) }')
    (common / "Appearance.qml").write_text('pragma Singleton\nimport QtQuick\nQtObject { property var font: ({family: {main: "sans-serif"}}) }')
    (widgets / "MaterialSymbol.qml").write_text('import QtQuick\nText { property real iconSize: 20; font.pixelSize: iconSize }')
    services = root / "services"
    services.mkdir()
    (services / "qmldir").write_text("singleton Network 1.0 Network.qml\nsingleton BluetoothStatus 1.0 BluetoothStatus.qml\n")
    (services / "Network.qml").write_text('pragma Singleton\nimport QtQuick\nQtObject {}')
    (services / "BluetoothStatus.qml").write_text('pragma Singleton\nimport QtQuick\nQtObject { property var friendlyDeviceList: [] }')
    (root / "shell.qml").write_text('''import QtQuick
import Quickshell
import "modules/encore"
Item {
 id: test
 width: 400; height: 1000
 property int failures: 0
 property int wifiScans: 0
 property int wifiActions: 0
 property int pairs: 0
 property int connects: 0
 property int disconnects: 0
 property int forgets: 0
 function check(value, message) { if (!value) { failures++; console.error("FAIL: " + message); } }
 function find(item, name) {
   if (item.objectName === name) return item;
   for (let child of item.children) { const result = find(child, name); if (result) return result; }
   return null;
 }
 QtObject {
   id: ap
   property string ssid: "Test Wi-Fi"
   property bool active: false
   property bool askingPassword: false
   property int strength: 80
   property bool isSecure: true
 }
 QtObject {
   id: fakeNetwork
   property bool wifiEnabled: false
   property bool wifiScanning: false
   property bool wifiConnecting: false
   property var wifiConnectTarget: null
   property var friendlyWifiNetworks: [ap]
   function toggleWifi() { wifiEnabled = !wifiEnabled; }
   function rescanWifi() { test.wifiScans++; }
   function connectToWifiNetwork(device) { test.wifiActions++; device.askingPassword = true; }
   function disconnectWifiNetwork() { test.wifiActions++; }
   function changePassword(device, password) { test.check(device === ap && password === "secret", "password submitted"); test.wifiActions++; }
 }
 QtObject { id: fakeAdapter; property bool enabled: false; property bool discovering: false }
 QtObject {
   id: device
   property string name: "Test headphones"
   property bool paired: false
   property bool connected: false
   property bool pairing: false
   function pair() { test.pairs++; paired = true; }
   function connect() { test.connects++; connected = true; }
   function disconnect() { test.disconnects++; connected = false; }
   function forget() { test.forgets++; paired = false; }
 }
 EncoreControlTile { id: tile; expandable: true; onClicked: expanded = !expanded }
 EncoreConnections { id: wifi; width: 380; bluetooth: false; network: fakeNetwork }
 Loader {
   id: btLoader
   active: true
   sourceComponent: EncoreConnections { width: 380; bluetooth: true; adapter: fakeAdapter; devices: [device] }
 }
 Timer {
   interval: 60; running: true; repeat: true
   property int step: 0
   onTriggered: {
     switch(step++) {
       case 0:
         test.check(test.wifiScans === 0 && !fakeAdapter.discovering, "closed radios do not scan");
         tile.clicked(); test.check(tile.expanded, "tile expands");
         tile.clicked(); test.check(!tile.expanded, "tile collapses");
         test.find(wifi, "connectionPower").clicked();
         test.find(btLoader.item, "connectionPower").clicked();
         break;
       case 1:
         test.check(test.wifiScans === 1, "Wi-Fi scans after power-on");
         test.check(fakeAdapter.discovering, "Bluetooth scans after power-on");
         test.find(wifi, "connectionAction").clicked();
         test.find(btLoader.item, "connectionAction").clicked();
         break;
       case 2:
         test.check(test.pairs === 1, "Bluetooth pairs");
         test.find(btLoader.item, "connectionAction").clicked();
         const password = test.find(wifi, "wifiPassword");
         test.check(password.visible, "Wi-Fi password field appears");
         password.text = "secret"; password.accepted();
         break;
       case 3:
         test.check(test.connects === 1 && test.wifiActions === 2, "connect and password actions");
         test.find(btLoader.item, "connectionAction").clicked();
         break;
       case 4:
         test.check(test.disconnects === 1, "Bluetooth disconnects");
         btLoader.active = false;
         break;
       case 5:
         test.check(!fakeAdapter.discovering, "collapsing stops Bluetooth scanning");
         btLoader.active = true;
         break;
       case 6:
         test.check(btLoader.item && fakeAdapter.discovering, "Bluetooth reopens and scans");
         btLoader.item.adapter = null;
         break;
       case 7:
         test.check(!test.find(btLoader.item, "connectionPower").enabled, "missing adapter handled");
         test.check(!fakeAdapter.discovering, "adapter removal stops owned discovery");
         console.log(test.failures === 0 ? "PASS: Encore connection panels" : "FAILED");
         Qt.quit();
     }
   }
 }
}
''')
    runtime = root / "runtime"
    runtime.mkdir(mode=0o700)
    environment = dict(os.environ, QT_QPA_PLATFORM="offscreen", QSG_RHI_BACKEND="software", XDG_RUNTIME_DIR=str(runtime), DBUS_SYSTEM_BUS_ADDRESS="unix:path=/nonexistent")
    environment.pop("WAYLAND_DISPLAY", None)
    result = subprocess.run(["qs", "-p", str(root), "--no-color"], env=environment, capture_output=True, text=True, timeout=15)
    output = result.stdout + result.stderr
    assert result.returncode == 0 and "PASS: Encore connection panels" in output and "FAIL:" not in output and "TypeError" not in output and "ReferenceError" not in output, output
    print("PASS: expansion, radio power, scanning, Wi-Fi password, Bluetooth pairing/connection, collapse/reopen, and missing adapter")
