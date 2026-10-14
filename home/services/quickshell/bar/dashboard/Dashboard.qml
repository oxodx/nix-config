pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import qs
import qs.components
import qs.launcher as Launcher
import qs.lock as Lock
import qs.notifications as Notifs
import qs.bar.mpris as Mpris

Item {
  id: root

  signal requestClose

  implicitWidth: 520
  implicitHeight: 390

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var battery: UPower.displayDevice

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  SkewedSurface {
    anchors.fill: parent
    slantLeft: true
    slantRight: true
    slant: 24
    fillColor: "#f2171a22"
    outlineColor: Appearance.colors.widgetOutlineSeparate
    shadowColor: "#70000000"
    shadowOffset: 6
  }

  ColumnLayout {
    anchors {
      fill: parent
      leftMargin: 34
      rightMargin: 34
      topMargin: 24
      bottomMargin: 22
    }
    spacing: 14

    RowLayout {
      Layout.fillWidth: true
      spacing: 14

      ColumnLayout {
        Layout.fillWidth: true
        spacing: -2

        StyledText {
          text: Qt.formatDateTime(clock.date, "hh:mm:ss")
          color: Appearance.colors.m3onSurface
          font.pointSize: Appearance.font.size.extraLarge
          font.weight: Font.Bold
        }

        StyledText {
          text: Qt.formatDateTime(clock.date, "dddd, MMMM d")
          color: Appearance.colors.m3tertiary
          font.weight: Font.DemiBold
        }
      }

      ColumnLayout {
        spacing: 3

        StyledText {
          Layout.alignment: Qt.AlignRight
          text: root.battery ? `${Math.round(root.battery.percentage * 100)}% battery` : "Desktop power"
          color: Appearance.colors.m3onSurfaceVariant
        }

        StyledText {
          Layout.alignment: Qt.AlignRight
          text: `${Notifs.NotificationManager.notifications.length} notifications`
          color: Appearance.colors.m3onSurfaceVariant
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      DashboardAction {
        Layout.fillWidth: true
        icon: "apps"
        label: "Launcher"
        onTriggered: {
          root.requestClose();
          Launcher.Controller.open();
        }
      }

      DashboardAction {
        Layout.fillWidth: true
        icon: "screenshot_region"
        label: "Capture"
        onTriggered: {
          root.requestClose();
          ShellIpc.screenshot();
        }
      }

      DashboardAction {
        Layout.fillWidth: true
        icon: Notifs.NotificationManager.dnd ? "notifications_off" : "notifications"
        label: "Focus"
        active: Notifs.NotificationManager.dnd
        onTriggered: Notifs.NotificationManager.dnd = !Notifs.NotificationManager.dnd
      }

      DashboardAction {
        Layout.fillWidth: true
        icon: "lock"
        label: "Lock"
        onTriggered: {
          root.requestClose();
          Lock.Controller.locked = true;
        }
      }
    }

    SkewedSurface {
      Layout.fillWidth: true
      Layout.preferredHeight: 58
      slantLeft: true
      slantRight: true
      slant: 11
      fillColor: Appearance.colors.widget
      outlineColor: Appearance.colors.widgetOutline
      shadowColor: "transparent"

      RowLayout {
        anchors {
          fill: parent
          leftMargin: 18
          rightMargin: 18
        }
        spacing: 12

        MaterialIcon {
          text: root.sink?.audio?.muted ? "volume_off" : "volume_up"
          fill: 1
          color: Appearance.colors.m3tertiary
        }

        Mpris.MediaSlider {
          id: volumeSlider
          Layout.fillWidth: true
          from: 0
          to: 1
          enabled: root.sink?.audio != null
          barColor: Appearance.colors.m3tertiary
          grooveColor: "#30ffffff"
          onMoved: root.sink.audio.volume = value

          Binding {
            target: volumeSlider
            property: "value"
            value: root.sink?.audio?.volume ?? 0
            when: !volumeSlider.pressed
          }
        }

        StyledText {
          text: `${Math.round((root.sink?.audio?.volume ?? 0) * 100)}%`
          color: Appearance.colors.m3onSurfaceVariant
          font.family: Appearance.font.family.mono
        }
      }
    }

    SkewedSurface {
      Layout.fillWidth: true
      Layout.fillHeight: true
      slantLeft: true
      slantRight: true
      slant: 14
      fillColor: "#2411131a"
      outlineColor: Appearance.colors.widgetOutline
      shadowColor: "transparent"

      RowLayout {
        anchors {
          fill: parent
          leftMargin: 20
          rightMargin: 20
          topMargin: 12
          bottomMargin: 12
        }
        spacing: 14

        SkewedImage {
          Layout.preferredWidth: 72
          Layout.preferredHeight: 72
          slant: 10
          outlineColor: Appearance.colors.m3tertiary
          source: Mpris.MprisController.activeTrack?.artUrl || "image://icon/audio-x-generic-symbolic"
          asynchronous: true
          cache: false
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 2

          StyledText {
            Layout.fillWidth: true
            text: Mpris.MprisController.activeTrack?.title ?? "Nothing playing"
            color: Appearance.colors.m3onSurface
            font.weight: Font.Bold
            elide: Text.ElideRight
          }

          StyledText {
            Layout.fillWidth: true
            text: Mpris.MprisController.activeTrack?.artist ?? "Open a media player"
            color: Appearance.colors.m3tertiary
            elide: Text.ElideRight
          }
        }

        Mpris.MediaControlButton {
          buttonSize: 34
          icon: "skip_previous"
          enabled: Mpris.MprisController.canGoPrevious
          onTriggered: Mpris.MprisController.previous()
        }

        Mpris.MediaControlButton {
          buttonSize: 38
          prominent: true
          icon: Mpris.MprisController.isPlaying ? "pause" : "play_arrow"
          enabled: Mpris.MprisController.canTogglePlaying
          onTriggered: Mpris.MprisController.togglePlaying()
        }

        Mpris.MediaControlButton {
          buttonSize: 34
          icon: "skip_next"
          enabled: Mpris.MprisController.canGoNext
          onTriggered: Mpris.MprisController.next()
        }
      }
    }
  }
}
