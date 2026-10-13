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

  RowLayout {
    id: leftSection
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    height: 34
    width: implicitWidth
    spacing: 6

    // OS Icon
    FullwidthMouseArea {
      MaterialIcon {
        anchors.centerIn: parent
        text: Icons.osIcon
        font.family: "Symbols Nerd Font Mono"
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

  Mpris.Players {
    bar: root
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.topMargin: 3
    anchors.bottomMargin: 3
    width: 760
  }

  RowLayout {
    id: rightSection
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    height: 34
    width: implicitWidth
    spacing: 6

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
