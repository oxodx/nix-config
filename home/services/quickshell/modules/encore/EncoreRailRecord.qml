import QtQuick
import qs
import qs.services
import qs.modules.common

EncoreRailButton {
    id: root
    hint: MprisController.activePlayer?.trackTitle ? "Now playing: " + MprisController.activePlayer.trackTitle : "Music controls"
    onClicked: GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen
    contentItem: Item {
        Rectangle {
            id: record
            anchors.centerIn: parent; width: 23; height: 23; radius: 12
            color: "#210c32"; border.width: 1; border.color: EncoreStyle.lavender
            RotationAnimator on rotation {
                from: 0; to: 360; duration: 14000; loops: Animation.Infinite
                running: root.visible && Config.options.encore.motion && (MprisController.activePlayer?.isPlaying ?? false)
            }
            Rectangle { anchors.centerIn: parent; width: 17; height: 17; radius: 9; color: "transparent"; border.width: 1; border.color: "#744593" }
            Rectangle { anchors.centerIn: parent; width: 10; height: 10; radius: 5; color: EncoreStyle.pink }
            Rectangle { x: 10; y: 1; width: 2; height: 5; radius: 1; color: EncoreStyle.lavender }
            Rectangle { anchors.centerIn: parent; width: 3; height: 3; radius: 2; color: EncoreStyle.ink }
        }
    }
}
