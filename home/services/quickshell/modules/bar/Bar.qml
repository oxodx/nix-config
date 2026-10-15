pragma ComponentBehavior: Bound
import qs.services
import qs.theme
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.utils
import qs.components
import qs.modules.tray as SysTray
import qs.modules.audio as Audio
import qs.modules.media as Mpris
import qs.modules.connections as Connections
import qs.modules.power as Power
import qs.modules.notifications as Notifs

BarContainment {
  id: root
  BarSurface {
    id: leftIsland
    anchors.left: parent.left
    anchors.top: parent.top
    height: root.barHeight
    width: leftSection.implicitWidth + 42
    cutRight: true
    RowLayout {
      id: leftSection
      anchors.fill: parent
      anchors.leftMargin: 10
      anchors.rightMargin: 32
      spacing: 10
      FullwidthMouseArea {
        id: launcherButton
        Layout.preferredWidth: 24
        Layout.fillHeight: true
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onPressed: LauncherService.toggle()
        MaterialIcon {
          anchors.centerIn: parent
          text: "apps"
          font.pointSize: 14
          color: launcherButton.containsMouse ? Appearance.colors.m3tertiary : Appearance.colors.m3primary
        }
      }
      StatsWidget {
        Layout.alignment: Qt.AlignVCenter
      }
      Workspaces {
        bar: root
        Layout.fillHeight: true
        visible: root.width >= 1700 && visibleWorkspaces.length > 0
      }
    }
  }

  BarSurface {
    id: centerIsland
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    height: root.barHeight
    // Symmetric bounds keep the centered island clear of both corner panels.
    width: Math.max(0, Math.min(820, root.width - 2 * Math.max(leftIsland.width, rightIsland.width) - 24))
    visible: width >= 240 && MprisService.activePlayer !== null
    cutLeft: true
    cutRight: true
    Mpris.Players {
      bar: root
      anchors.fill: parent
      compactBar: true
      edgeInset: 30
    }
  }

  BarSurface {
    id: rightIsland
    anchors.right: parent.right
    anchors.top: parent.top
    height: root.barHeight
    width: rightSection.implicitWidth + 42
    cutLeft: true

    RowLayout {
      id: rightSection
      anchors.fill: parent
      anchors.leftMargin: 32
      anchors.rightMargin: 10
      spacing: 8

      SysTray.SysTray {
        bar: root
        Layout.fillHeight: true
      }

      Notifs.NotificationWidget {
        bar: root
        Layout.fillHeight: true
        Layout.preferredWidth: 30
      }

      Connections.Connections {
        bar: root
        Layout.fillHeight: true
      }

      Audio.AudioControls {
        bar: root
        Layout.fillHeight: true
      }

      Power.Power {
        bar: root
        Layout.fillHeight: true
        Layout.preferredWidth: 28
      }

      ClockWidget {
        bar: root
        Layout.fillHeight: true
      }
    }
  }
}
