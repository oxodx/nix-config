import QtQuick
import QtQuick.Layouts
import qs.services

EncoreCard {
    id: root
    required property var notification
    implicitHeight: content.implicitHeight + 28
    fill: EncoreStyle.surface
    ColumnLayout {
        id: content
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 14
        }
        spacing: 6
        RowLayout {
            Layout.fillWidth: true
            EncoreText {
                text: root.notification.appName || "Notification"
                Layout.fillWidth: true
                color: EncoreStyle.muted
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1
            }
            EncoreButton {
                symbol: "close"
                implicitHeight: 26
                implicitWidth: 26
                padding: 2
                hint: "Dismiss notification"
                onClicked: Notifications.discardNotification(root.notification.notificationId)
            }
        }
        EncoreText {
            text: root.notification.summary
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 2
            font.bold: true
        }
        EncoreText {
            text: root.notification.body
            visible: text.length > 0
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            maximumLineCount: 3
            font.pixelSize: 12
            color: EncoreStyle.muted
        }
        Flow {
            Layout.fillWidth: true
            spacing: 6
            Repeater {
                model: root.notification.actions
                EncoreButton {
                    required property var modelData
                    text: modelData.text
                    implicitHeight: 30
                    fill: EncoreStyle.lavender
                    onClicked: Notifications.attemptInvokeAction(root.notification.notificationId,
                                                                 modelData.identifier)
                }
            }
        }
    }
}
