import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs
import qs.services
import qs.modules.common.widgets

PanelWindow {
    id: root
    property string kind: "volume"
    property real level: Audio.value
    function show(kind, level) {
        root.kind = kind;
        root.level = level;
        timer.restart();
    }
    screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
    anchors.bottom: true
    margins.bottom: 110
    implicitWidth: 300
    implicitHeight: 70
    exclusiveZone: 0
    color: "transparent"
    visible: timer.running && !GlobalStates.screenLocked
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:encore:osd"
    mask: Region {}
    Timer {
        id: timer
        interval: 1800
    }
    Connections {
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (Audio.ready)
                root.show("volume", Audio.value);
        }
        function onMutedChanged() {
            if (Audio.ready)
                root.show("volume", Audio.value);
        }
    }
    Connections {
        target: Brightness
        function onBrightnessChanged() {
            const monitor = Brightness.getMonitorForScreen(root.screen);
            if (monitor)
                root.show("brightness", monitor.brightness);
        }
    }
    EncoreCard {
        anchors.fill: parent
        anchors.margins: 6
        fill: EncoreStyle.paper
        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12
            MaterialSymbol {
                text: root.kind === "brightness" ? "brightness_6" : (Audio.sink?.audio.muted ? "volume_off" :
                                                                                               "volume_up")
                color: EncoreStyle.text
                iconSize: 24
            }
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 12
                radius: 6
                color: EncoreStyle.surface
                Rectangle {
                    width: Math.min(1, Math.max(0, root.level)) * parent.width
                    height: parent.height
                    radius: 6
                    color: EncoreStyle.lavender
                    border.width: 1
                    border.color: EncoreStyle.ink
                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
            }
            EncoreText {
                text: Math.round(root.level * 100) + "%"
                font.bold: true
            }
        }
    }
}
