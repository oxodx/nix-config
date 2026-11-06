import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import qs

PanelWindow {
    id: root
    property bool opened: false
    property bool rightAligned: false
    property int cardWidth: 420
    property int cardHeight: 680
    property real reveal: opened ? 1 : 0
    default property alias body: body.data
    signal dismissed
    screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    exclusiveZone: 0
    color: "transparent"
    visible: reveal > 0
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:encore:popup"
    WlrLayershell.keyboardFocus: opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    Behavior on reveal {
        NumberAnimation {
            duration: 220
            easing.type: Easing.OutCubic
        }
    }
    onOpenedChanged: if (opened)
                         body.forceActiveFocus()

    Rectangle {
        anchors.fill: parent
        color: "#6630213f"
        opacity: root.reveal
    }
    MouseArea {
        anchors.fill: parent
        onClicked: root.dismissed()
    }
    EncoreCard {
        id: phone
        width: Math.min(root.cardWidth, root.width - 32)
        height: Math.min(root.cardHeight, root.height - 100)
        x: root.rightAligned ? root.width - width - 20 : (root.width - width) / 2
        y: (root.height - height) / 2 + (1 - root.reveal) * 64
        scale: 0.96 + 0.04 * root.reveal
        opacity: root.reveal
        radius: 32
        border.width: 3
        // Consume clicks on the phone, leaving only the scrim to dismiss it.
        MouseArea {
            anchors.fill: parent
        }
        EncorePrideStripe {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 12
            width: 72
            height: 5
        }
        Item {
            id: body
            anchors.fill: parent
            anchors.margins: 20
            anchors.topMargin: 34
            anchors.bottomMargin: 24
            focus: true
            Keys.onEscapePressed: root.dismissed()
        }
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            width: 80
            height: 4
            radius: 2
            color: EncoreStyle.outline
        }
    }
}
