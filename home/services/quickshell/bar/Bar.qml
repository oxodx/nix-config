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

BarContainment {
  id: root

  SkewedSurface {
    id: leftIsland
    anchors.left: parent.left
    anchors.top: parent.top
    height: 56
    width: leftSection.implicitWidth + 34

    slantRight: true

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
        hoverEnabled: true

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
    height: 56
    width: Mpris.MprisController.activePlayer ? Math.min(900, Math.max(600, parent.width - leftIsland.width - rightIsland.width - 48)) : 360

    Behavior on width {
      NumberAnimation {
        duration: Appearance.anim.durations.normal
        easing.type: Easing.OutCubic
      }
    }

    slantLeft: true
    slantRight: true
    fillColor: "#dc11131a"

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
    height: 56
    width: rightSection.implicitWidth + 34

    slantLeft: true

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

      SysTray.SysTray {
        bar: root
        Layout.fillHeight: true
      }

      Connections.Connections {
        bar: root
        Layout.fillHeight: true
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
