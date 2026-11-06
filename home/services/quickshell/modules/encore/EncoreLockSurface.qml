import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.panels.lock

Rectangle {
    id: root
    required property LockContext context
    // Keep the entire security surface opaque, including failed image loads.
    color: "#210c32"
    readonly property string wallpaper: Config.options.background.wallpaperPath
    readonly property bool video: /\.(mp4|webm|mkv|avi|mov)$/i.test(wallpaper)
    readonly property string imagePath: video ? Config.options.background.thumbnailPath : wallpaper
    function focusPassword() { password.forceActiveFocus() }
    function chooseAction(action) {
        if (!Config.options.lock.security.requirePasswordToPower) {
            context.unlocked(action)
            return
        }
        context.targetAction = context.targetAction === action ? LockContext.ActionEnum.Unlock : action
        focusPassword()
    }
    Component.onCompleted: focusPassword()
    Connections {
        target: root.context
        function onShouldReFocus() { root.focusPassword() }
        function onCurrentTextChanged() {
            if (password.text !== root.context.currentText) password.text = root.context.currentText
        }
        function onShowFailureChanged() {
            if (root.context.showFailure && Config.options.encore.motion) shake.restart()
        }
        function onUnlockInProgressChanged() { if (!root.context.unlockInProgress) root.focusPassword() }
    }
    Image {
        anchors.fill: parent
        source: root.imagePath || Quickshell.shellPath("assets/images/default_wallpaper.png")
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        opacity: status === Image.Ready ? 1 : 0
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#8030213f" }
            GradientStop { position: 1; color: "#d9210c32" }
        }
    }
    Rectangle { anchors.fill: parent; anchors.margins: 12; radius: Config.options.encore.frameRounding; color: "transparent"; border.width: 5; border.color: EncoreStyle.lavender }
    Rectangle { anchors.fill: parent; anchors.margins: 23; radius: Math.max(0, Config.options.encore.frameRounding - 10); color: "transparent"; border.width: 1; border.color: EncoreStyle.pink }
    MouseArea { anchors.fill: parent; onClicked: root.focusPassword() }
    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(420, root.width - 72)
        spacing: root.height < 650 ? 18 : 34
        EncoreClock {
            Layout.fillWidth: true; Layout.preferredHeight: root.height < 650 ? 160 : 210
            rotation: Config.options.encore.cardTilt ? -2 : 0
            EncoreTape { x: 20; y: -9; rotation: -12 }
            EncoreTape { anchors.right: parent.right; anchors.rightMargin: 15; y: -8; rotation: 17 }
        }
        EncoreCard {
            id: authCard
            Layout.fillWidth: true; Layout.preferredHeight: form.implicitHeight + 40
            rotation: Config.options.encore.cardTilt ? 1.2 : 0
            property real shakeOffset: 0
            transform: Translate { x: authCard.shakeOffset }
            SequentialAnimation {
                id: shake
                NumberAnimation { target: authCard; property: "shakeOffset"; to: -9; duration: 60 }
                NumberAnimation { target: authCard; property: "shakeOffset"; to: 7; duration: 90 }
                NumberAnimation { target: authCard; property: "shakeOffset"; to: -4; duration: 90 }
                NumberAnimation { target: authCard; property: "shakeOffset"; to: 0; duration: 130; easing.type: Easing.OutBack }
            }
            ColumnLayout {
                id: form; anchors.fill: parent; anchors.margins: 20; spacing: 14
                RowLayout {
                    Layout.fillWidth: true
                    EncoreText { text: "♡  " + SystemInfo.username; font.bold: true; font.pixelSize: 22; Layout.fillWidth: true }
                    EncoreText { text: HyprlandXkb.currentLayoutCode; color: EncoreStyle.muted; font.pixelSize: 12 }
                }
                EncoreText {
                    Layout.fillWidth: true; wrapMode: Text.Wrap
                    text: root.context.showFailure ? "That didn't quite land. Try again, love." : root.context.unlockInProgress ? "One little moment…" : root.context.targetAction === LockContext.ActionEnum.Poweroff ? "Enter your password to shut down." : root.context.targetAction === LockContext.ActionEnum.Reboot ? "Enter your password to restart." : "Your little universe is waiting."
                    color: root.context.showFailure ? EncoreStyle.pink : EncoreStyle.muted
                }
                RowLayout {
                    Layout.fillWidth: true; spacing: 10
                    TextField {
                        id: password
                        objectName: "encoreLockPassword"
                        Layout.fillWidth: true; implicitHeight: 46
                        enabled: !root.context.unlockInProgress
                        echoMode: TextInput.Password
                        inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                        placeholderText: "Password"
                        color: EncoreStyle.text; placeholderTextColor: EncoreStyle.muted
                        selectionColor: EncoreStyle.lavender; selectedTextColor: EncoreStyle.ink
                        font.family: EncoreStyle.font; font.pixelSize: 16; padding: 12
                        text: root.context.currentText
                        background: Rectangle { radius: 11; color: EncoreStyle.surface; border.width: 2; border.color: password.activeFocus ? EncoreStyle.pink : EncoreStyle.outline }
                        onTextChanged: { if (root.context.currentText !== text) root.context.currentText = text }
                        property bool ctrlHeld: false
                        onAccepted: root.context.tryUnlock(ctrlHeld)
                        Keys.onPressed: event => {
                            password.ctrlHeld = (event.modifiers & Qt.ControlModifier) !== 0
                            root.context.resetClearTimer()
                            if (event.key === Qt.Key_Escape) {
                                root.context.clearText(); root.context.resetTargetAction(); event.accepted = true
                            }
                        }
                    }
                    EncoreButton { symbol: "arrow_forward"; fill: EncoreStyle.lavender; hint: "Unlock or confirm selected action"; enabled: !root.context.unlockInProgress; onClicked: root.context.tryUnlock() }
                }
                EncorePrideStripe { Layout.fillWidth: true; implicitHeight: 5 }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter; spacing: 12
                    EncoreButton { symbol: "fingerprint"; visible: root.context.fingerprintsConfigured; hint: "Use fingerprint"; enabled: !root.context.unlockInProgress; onClicked: root.context.tryFingerUnlock() }
                    EncoreButton { symbol: "bedtime"; hint: "Sleep"; onClicked: Session.suspend() }
                    EncoreButton { symbol: "power_settings_new"; hint: "Shut down"; selected: root.context.targetAction === LockContext.ActionEnum.Poweroff; onClicked: root.chooseAction(LockContext.ActionEnum.Poweroff) }
                    EncoreButton { symbol: "restart_alt"; hint: "Restart"; selected: root.context.targetAction === LockContext.ActionEnum.Reboot; onClicked: root.chooseAction(LockContext.ActionEnum.Reboot) }
                }
            }
        }
        EncoreText {
            Layout.alignment: Qt.AlignHCenter
            text: "✦  TAKE UP SPACE. YOU BELONG HERE.  ✦"
            color: "#f0e1fc"; font.pixelSize: 11; font.letterSpacing: 1
        }
    }
}
