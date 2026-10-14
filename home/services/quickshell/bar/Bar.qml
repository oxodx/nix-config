pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.utils
import qs.components
import qs.bar.systray as SysTray
import qs.bar.audio as Audio
import qs.bar.mpris as Mpris
import qs.bar.connections as Connections
import qs.bar.power as Power
import qs.notifications as Notifs
import qs.launcher as Launcher

BarContainment {
  id: root

  SkewedSurface {
    id: leftIsland
    anchors.left: parent.left
    anchors.top: parent.top
    height: 60
    width: leftSection.implicitWidth + 34

    slantRight: true

    Rectangle {
      anchors {
        left: parent.left
        right: parent.right
        rightMargin: 20
        bottom: parent.bottom
      }
      height: 2
      color: Appearance.colors.m3tertiary
      opacity: 0.7
    }

    RowLayout {
      id: leftSection
      anchors {
        fill: parent
        leftMargin: 10
        rightMargin: 28
        topMargin: 5
        bottomMargin: 5
      }
      spacing: 7

      FullwidthMouseArea {
        id: launcherButton
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onPressed: Launcher.Controller.toggle()

        SkewedPanel {
          anchors.fill: parent
          anchors.margins: 3
          slantLeft: true
          slantRight: true
          slant: 7
          fillColor: launcherButton.containsMouse ? Appearance.colors.widgetActive : "transparent"
          outlineColor: launcherButton.containsMouse ? Appearance.colors.m3tertiary : "transparent"

          Behavior on fillColor {
            ColorAnimation {
              duration: 140
            }
          }
        }

        MaterialIcon {
          anchors.centerIn: parent
          text: Icons.osIcon
          font.family: "Symbols Nerd Font Mono"
          font.pointSize: Appearance.font.size.large
          color: Appearance.colors.m3tertiary
        }

        Layout.fillHeight: true
        Layout.preferredWidth: height
        Layout.alignment: Qt.AlignVCenter
      }

      Notifs.NotificationWidget {
        bar: root
        Layout.fillHeight: true
        Layout.preferredWidth: height
      }

      Workspaces {
        bar: root
        Layout.fillHeight: true
      }
    }
  }

  SkewedSurface {
    id: centerIsland
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    height: 60
    width: Mpris.MprisController.activePlayer ? Math.min(900, Math.max(600, parent.width - leftIsland.width - rightIsland.width - 48)) : 360

    slantLeft: true
    slantRight: true
    fillColor: "#dc11131a"

    Rectangle {
      anchors {
        left: parent.left
        right: parent.right
        leftMargin: 22
        rightMargin: 22
        bottom: parent.bottom
      }
      height: 2
      color: Appearance.colors.m3tertiary
      opacity: Mpris.MprisController.activePlayer ? 0.9 : 0.35
      visible: !Mpris.MprisController.activePlayer
    }

    Mpris.Players {
      bar: root
      anchors.fill: parent
      skewed: true
      edgeInset: 22
    }
  }

  SkewedSurface {
    id: rightIsland
    anchors.right: parent.right
    anchors.top: parent.top
    height: 60
    width: rightSection.implicitWidth + 34

    slantLeft: true

    Rectangle {
      anchors {
        left: parent.left
        right: parent.right
        leftMargin: 20
        bottom: parent.bottom
      }
      height: 2
      color: Appearance.colors.m3tertiary
      opacity: 0.7
    }

    RowLayout {
      id: rightSection
      anchors {
        fill: parent
        leftMargin: 28
        rightMargin: 10
        topMargin: 5
        bottomMargin: 5
      }
      spacing: 7

      Audio.AudioControls {
        bar: root
        Layout.fillHeight: true
      }

      Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 26
        color: Appearance.colors.widgetOutlineSeparate
      }

      SysTray.SysTray {
        bar: root
        Layout.fillHeight: true
      }

      Connections.Connections {
        bar: root
        Layout.fillHeight: true
      }

      Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 26
        color: Appearance.colors.widgetOutlineSeparate
      }

      Power.Power {
        bar: root
        Layout.fillHeight: true
        Layout.preferredWidth: height
      }

      ClockWidget {
        bar: root
        Layout.fillHeight: true
      }
    }
  }
}
