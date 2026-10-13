import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Notifications
import qs
import qs.components

Item {
  id: root
  required property Notification notif
  required property var backer

  implicitWidth: 450
  implicitHeight: c.implicitHeight

  HoverHandler {
    onHoveredChanged: {
      backer.pauseCounter += hovered ? 1 : -1;
    }
  }

  SkewedSurface {
    anchors.fill: parent
    slantLeft: true
    slantRight: true
    slant: 18
    fillColor: notif.urgency == NotificationUrgency.Critical ? "#ed341b29" : "#ed171a22"
    outlineColor: notif.urgency == NotificationUrgency.Critical ? "#80ff747b" : Appearance.colors.widgetOutlineSeparate
    shadowOffset: 5
  }

  SkewedPanel {
    id: border
    anchors.fill: parent
    slantLeft: true
    slantRight: true
    slant: 18
    outlineWidth: 1
    outlineColor: notif.urgency == NotificationUrgency.Critical ? "#80ff747b" : Appearance.colors.widgetOutline
  }

  ColumnLayout {
    id: c
    anchors.fill: parent
    spacing: 0

    ColumnLayout {
      Layout.margins: 10

      RowLayout {
        Image {
          visible: source != ""
          source: notif.appIcon ? Quickshell.iconPath(notif.appIcon) : ""
          fillMode: Image.PreserveAspectFit
          antialiasing: true
          sourceSize.width: 30
          sourceSize.height: 30
          Layout.preferredWidth: 30
          Layout.preferredHeight: 30
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 0

          StyledText {
            Layout.fillWidth: true
            visible: text !== ""
            text: notif.summary
            font.pointSize: Appearance.font.size.normal
            font.weight: Font.Bold
            elide: Text.ElideRight
          }

          StyledText {
            Layout.fillWidth: true
            visible: text !== ""
            text: notif.appName ?? ""
            color: Appearance.colors.m3tertiary
            font.pointSize: Appearance.font.size.smaller
            elide: Text.ElideRight
          }
        }

        Item {
          Layout.fillWidth: true
        }

        MouseArea {
          id: closeArea
          Layout.preferredWidth: 30
          Layout.preferredHeight: 30

          hoverEnabled: true
          onPressed: root.backer.discard()

          Rectangle {
            anchors.fill: parent
            anchors.margins: 5
            radius: width * 0.5
            antialiasing: true
            color: "#60ffffff"
            opacity: closeArea.containsMouse ? 1 : 0
            Behavior on opacity {
              SmoothedAnimation {
                velocity: 8
              }
            }
          }

          CloseButton {
            anchors.fill: parent
            ringFill: root.backer.timePercentage
          }
        }
      }

      Item {
        Layout.topMargin: 3
        visible: bodyLabel.text != "" || notifImage.visible
        implicitWidth: bodyLabel.width
        implicitHeight: Math.max(notifImage.size, bodyLabel.implicitHeight)

        Image {
          id: notifImage
          readonly property int size: visible ? 14 * 8 : 0
          y: bodyLabel.y + bodyLabel.topPadding

          visible: source != ""
          source: notif.image
          fillMode: Image.PreserveAspectFit
          cache: false
          antialiasing: true

          width: size
          height: size
          sourceSize.width: size
          sourceSize.height: size
        }

        Label {
          id: bodyLabel
          width: root.implicitWidth - 20
          text: notif.body
          wrapMode: Text.Wrap

          onLineLaidOut: line => {
            if (!notifImage.visible)
              return;

            const isize = notifImage.size + 6;
            if (line.y + line.height <= notifImage.y + isize) {
              line.x += isize;
              line.width -= isize;
            }
          }
        }
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.margins: 1
      spacing: 0
      visible: notif.actions.length != 0

      Rectangle {
        height: 1
        Layout.fillWidth: true
        color: border.outlineColor
        antialiasing: true
      }

      RowLayout {
        spacing: 0

        Repeater {
          model: notif.actions

          Item {
            required property NotificationAction modelData
            required property int index

            Layout.fillWidth: true
            implicitHeight: 35

            Rectangle {
              anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                leftMargin: -implicitWidth * 0.5
              }

              visible: index != 0
              implicitWidth: 1
              color: Appearance.colors.widgetOutline
              antialiasing: true
            }

            MouseArea {
              id: actionArea
              anchors.fill: parent

              onClicked: {
                modelData.invoke();
              }

              Rectangle {
                anchors.fill: parent
                color: actionArea.pressed && actionArea.containsMouse ? "#20000000" : "transparent"
              }

              RowLayout {
                anchors.centerIn: parent

                Image {
                  visible: notif.hasActionIcons
                  source: Quickshell.iconPath(modelData.identifier)
                  fillMode: Image.PreserveAspectFit
                  antialiasing: true
                  sourceSize.height: 25
                  sourceSize.width: 25
                }

                Label {
                  text: modelData.text
                }
              }
            }
          }
        }
      }
    }
  }
}
