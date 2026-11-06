import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs
import qs.services
import qs.modules.common

EncorePopup {
    id: root
    opened: GlobalStates.sidebarRightOpen && !GlobalStates.screenLocked
    rightAligned: true
    cardWidth: 420
    cardHeight: 800
    onDismissed: GlobalStates.sidebarRightOpen = false
    readonly property var brightnessMonitor: Brightness.getMonitorForScreen(screen)

    ColumnLayout {
        anchors.fill: parent
        spacing: 12
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 1
                EncoreText {
                    text: "THE LITTLE THINGS"
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 2
                    color: EncoreStyle.muted
                }
                EncoreText {
                    text: DateTime.time
                    font.pixelSize: 40
                    font.bold: true
                }
                EncoreText {
                    text: DateTime.longDate
                    color: EncoreStyle.muted
                    font.pixelSize: 12
                }
            }
            Item {
                Layout.fillWidth: true
            }
            EncoreButton {
                symbol: "close"
                fill: EncoreStyle.pink
                hint: "Close controls"
                onClicked: GlobalStates.sidebarRightOpen = false
            }
        }
        EncoreTray { Layout.fillWidth: true }
        Flickable {
            id: scroll
            Layout.fillHeight: true
            Layout.fillWidth: true
            contentHeight: column.implicitHeight + 6
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {}
            ColumnLayout {
                id: column
                width: scroll.width - 6
                spacing: 14
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 10
                    EncoreButton {
                        Layout.fillWidth: true
                        implicitHeight: 56
                        symbol: "wifi"
                        text: Network.wifiEnabled ? "Wi-Fi on" : "Wi-Fi off"
                        selected: Network.wifiEnabled
                        onClicked: Network.toggleWifi()
                        hint: Network.networkName || "Toggle Wi-Fi"
                    }
                    EncoreButton {
                        Layout.fillWidth: true
                        implicitHeight: 56
                        symbol: "bluetooth"
                        text: "Bluetooth"
                        selected: Bluetooth.defaultAdapter?.enabled ?? false
                        enabled: Bluetooth.defaultAdapter !== null
                        onClicked: Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
                    }
                    EncoreButton {
                        Layout.fillWidth: true
                        implicitHeight: 56
                        symbol: Notifications.silent ? "notifications_off" : "notifications"
                        text: "Quiet mode"
                        selected: Notifications.silent
                        onClicked: Notifications.silent = !Notifications.silent
                    }
                    EncoreButton {
                        Layout.fillWidth: true
                        implicitHeight: 56
                        symbol: "coffee"
                        text: "Stay awake"
                        selected: Idle.inhibit
                        onClicked: Idle.toggleInhibit()
                    }
                }
                EncoreCard {
                    Layout.fillWidth: true
                    implicitHeight: 130
                    fill: EncoreStyle.surface
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 14
                        spacing: 8
                        RowLayout {
                            EncoreButton {
                                symbol: Audio.sink?.audio.muted ? "volume_off" : "volume_up"
                                implicitWidth: 36
                                implicitHeight: 32
                                enabled: Audio.ready
                                hint: "Mute output"
                                onClicked: Audio.toggleMute()
                            }
                            EncoreSlider {
                                Layout.fillWidth: true
                                from: 0
                                to: 1
                                value: Audio.value
                                enabled: Audio.ready
                                onMoved: if (Audio.sink?.audio)
                                             Audio.sink.audio.volume = value
                                Accessible.name: "Volume"
                            }
                            EncoreText {
                                text: Math.round(Audio.value * 100) + "%"
                                Layout.preferredWidth: 38
                                font.pixelSize: 12
                            }
                        }
                        RowLayout {
                            EncoreButton {
                                symbol: "brightness_6"
                                implicitWidth: 36
                                implicitHeight: 32
                                enabled: false
                                hint: "Brightness"
                            }
                            EncoreSlider {
                                Layout.fillWidth: true
                                from: 0.01
                                to: 1
                                enabled: root.brightnessMonitor !== undefined
                                value: root.brightnessMonitor?.brightness ?? 0.5
                                onMoved: root.brightnessMonitor?.setBrightness(value)
                                Accessible.name: "Brightness"
                            }
                            EncoreText {
                                text: root.brightnessMonitor ? Math.round(root.brightnessMonitor.brightness
                                                                          * 100) + "%" : "N/A"
                                Layout.preferredWidth: 38
                                font.pixelSize: 12
                            }
                        }
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    EncoreButton {
                        Layout.fillWidth: true
                        symbol: "lan"
                        text: "Connections"
                        hint: Network.networkName || "Network settings"
                        onClicked: {
                            GlobalStates.sidebarRightOpen = false;
                            Quickshell.execDetached(["bash", "-c", Network.ethernet
                                                     ? Config.options.apps.networkEthernet :
                                                       Config.options.apps.network]);
                        }
                    }
                    EncoreButton {
                        Layout.fillWidth: true
                        symbol: "bedtime"
                        text: "Night light"
                        selected: Hyprsunset.temperatureActive
                        onClicked: Hyprsunset.temperatureActive ? Hyprsunset.disableTemperature() :
                                                                  Hyprsunset.enableTemperature()
                    }
                }
                EncoreMedia {
                    Layout.fillWidth: true
                }
                RowLayout {
                    Layout.fillWidth: true
                    EncoreText {
                        text: "IN YOUR INBOX"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 2
                        color: EncoreStyle.muted
                        Layout.fillWidth: true
                    }
                    EncoreButton {
                        text: "Clear"
                        implicitHeight: 30
                        enabled: Notifications.list.length > 0
                        onClicked: Notifications.discardAllNotifications()
                    }
                }
                EncoreText {
                    visible: Notifications.list.length === 0
                    text: "All caught up. Enjoy the quiet."
                    color: EncoreStyle.muted
                    Layout.bottomMargin: 10
                }
                Repeater {
                    model: Notifications.list.slice().reverse()
                    EncoreNotification {
                        required property var modelData
                        notification: modelData
                        Layout.fillWidth: true
                    }
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            EncoreButton {
                symbol: EncoreStyle.dark ? "light_mode" : "dark_mode"
                hint: "Switch Encore palette"
                onClicked: Config.options.encore.darkMode = !Config.options.encore.darkMode
            }
            EncoreButton {
                symbol: Audio.source?.audio.muted ? "mic_off" : "mic"
                hint: "Mute microphone"
                selected: Audio.source?.audio.muted ?? false
                enabled: Audio.source?.ready ?? false
                onClicked: Audio.toggleMicMute()
            }
            Item {
                Layout.fillWidth: true
            }
            EncoreButton {
                symbol: "settings"
                hint: "Shell settings"
                onClicked: {
                    GlobalStates.sidebarRightOpen = false;
                    Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("settings.qml")]);
                }
            }
            EncoreButton {
                symbol: "lock"
                hint: "Lock screen"
                onClicked: {
                    GlobalStates.sidebarRightOpen = false;
                    Quickshell.execDetached(["loginctl", "lock-session"]);
                }
            }
            EncoreButton {
                symbol: "power_settings_new"
                fill: EncoreStyle.pink
                hint: "Session menu"
                onClicked: {
                    GlobalStates.sidebarRightOpen = false;
                    GlobalStates.sessionOpen = true;
                }
            }
        }
    }
}
