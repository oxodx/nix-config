pragma ComponentBehavior: Bound

import qs.theme
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Networking
import qs.components
import qs.modules.media as Mpris

Item {
  id: root

  signal requestClose

  implicitWidth: 760
  implicitHeight: 660

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var source: Pipewire.defaultAudioSource
  PwObjectTracker {
    objects: [root.sink, root.source]
  }
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
    fillColor: Appearance.colors.panel
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
          text: root.battery?.isPresent ? `${Math.round(root.battery.percentage * 100)}% battery` : "Desktop power"
          color: Appearance.colors.m3onSurfaceVariant
        }

        StyledText {
          Layout.alignment: Qt.AlignRight
          text: `${NotificationService.notifications.length} notifications`
          color: Appearance.colors.m3onSurfaceVariant
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      DashboardAction {
        Layout.fillWidth: true
        icon: Networking.wifiEnabled ? "wifi" : "wifi_off"
        label: "Wi-Fi"
        active: Networking.wifiEnabled
        onTriggered: Networking.wifiEnabled = !Networking.wifiEnabled
      }

      DashboardAction {
        Layout.fillWidth: true
        icon: root.source?.audio?.muted ? "mic_off" : "mic"
        label: "Microphone"
        enabled: root.source?.audio != null
        active: root.source?.audio != null && !root.source.audio.muted
        onTriggered: {
          if (root.source?.audio)
            root.source.audio.muted = !root.source.audio.muted;
        }
      }

      DashboardAction {
        Layout.fillWidth: true
        icon: "apps"
        label: "Launcher"
        onTriggered: {
          root.requestClose();
          LauncherService.open();
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
        icon: NotificationService.dnd ? "notifications_off" : "notifications"
        label: "Focus"
        active: NotificationService.dnd
        onTriggered: NotificationService.dnd = !NotificationService.dnd
      }

      DashboardAction {
        Layout.fillWidth: true
        icon: "lock"
        label: "Lock"
        onTriggered: {
          root.requestClose();
          LockService.locked = true;
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

        ActionButton {
          implicitWidth: 34
          implicitHeight: 34
          icon: root.sink?.audio?.muted ? "volume_off" : "volume_up"
          active: root.sink?.audio?.muted ?? false
          enabled: root.sink?.audio != null
          Accessible.name: active ? "Unmute speakers" : "Mute speakers"
          onTriggered: root.sink.audio.muted = !root.sink.audio.muted
        }

        Mpris.MediaSlider {
          id: volumeSlider
          Layout.fillWidth: true
          from: 0
          to: 1
          enabled: root.sink?.audio != null
          barColor: Appearance.colors.m3tertiary
          grooveColor: Appearance.colors.sliderGroove
          onMoved: root.sink.audio.volume = value

          Binding {
            target: volumeSlider
            property: "value"
            value: root.sink?.audio?.volume ?? 0
            when: !volumeSlider.pressed
          }
        }

        StyledText {
          Layout.preferredWidth: 52
          horizontalAlignment: Text.AlignRight
          text: `${Math.round((root.sink?.audio?.volume ?? 0) * 100)}%`
          color: Appearance.colors.m3onSurfaceVariant
          font.family: Appearance.font.family.mono
        }
      }
    }

    SkewedSurface {
      Layout.fillWidth: true
      Layout.preferredHeight: 116
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

        Mpris.TrackArtwork {
          Layout.preferredWidth: 72
          Layout.preferredHeight: 72
          slant: 10
          outlineColor: Appearance.colors.m3tertiary
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 2

          StyledText {
            Layout.fillWidth: true
            text: MprisService.activeTrack?.title ?? "Nothing playing"
            color: Appearance.colors.m3onSurface
            font.weight: Font.Bold
            elide: Text.ElideRight
          }

          StyledText {
            Layout.fillWidth: true
            text: MprisService.activeTrack?.artist ?? "Open a media player"
            color: Appearance.colors.m3tertiary
            elide: Text.ElideRight
          }
        }

        Mpris.MediaControlButton {
          buttonSize: 34
          icon: "skip_previous"
          enabled: MprisService.canGoPrevious
          onTriggered: MprisService.previous()
        }

        Mpris.MediaControlButton {
          buttonSize: 38
          prominent: true
          icon: MprisService.isPlaying ? "pause" : "play_arrow"
          enabled: MprisService.canTogglePlaying
          onTriggered: MprisService.togglePlaying()
        }

        Mpris.MediaControlButton {
          buttonSize: 34
          icon: "skip_next"
          enabled: MprisService.canGoNext
          onTriggered: MprisService.next()
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 12

      CalendarCard {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }

      SystemUsage {
        Layout.fillWidth: true
        Layout.fillHeight: true
      }
    }
  }
}
