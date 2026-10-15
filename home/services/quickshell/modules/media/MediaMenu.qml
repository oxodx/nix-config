pragma ComponentBehavior: Bound

import qs.theme
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs.components

Item {
  id: root

  implicitWidth: 560
  implicitHeight: 460

  readonly property var player: MprisController.activePlayer
  readonly property int position: MprisController.position
  readonly property int length: MprisController.length

  function timeString(value: int): string {
    if (!Number.isFinite(value) || value < 0)
      return "--:--";
    const hours = Math.floor(value / 3600);
    const minutes = Math.floor((value % 3600) / 60);
    const seconds = Math.floor(value % 60).toString().padStart(2, "0");
    return hours > 0 ? `${hours}:${minutes.toString().padStart(2, "0")}:${seconds}` : `${minutes}:${seconds}`;
  }

  SkewedSurface {
    anchors.fill: parent
    slantLeft: true
    slantRight: true
    slant: 24
    fillColor: "#f21c1b24"
    shadowColor: Appearance.colors.elevatedShadow
    shadowOffset: 5
  }

  ColumnLayout {
    anchors {
      fill: parent
      leftMargin: 34
      rightMargin: 34
      topMargin: 20
      bottomMargin: 18
    }
    spacing: 11

    RowLayout {
      Layout.fillWidth: true
      spacing: 10

      MaterialIcon {
        text: "graphic_eq"
        fill: 1
        color: Appearance.colors.m3tertiary
      }

      StyledText {
        Layout.fillWidth: true
        text: root.player?.identity ?? "Media"
        color: Appearance.colors.m3onSurfaceVariant
        font.pointSize: Appearance.font.size.smaller
        font.weight: Font.DemiBold
        elide: Text.ElideRight
      }

      Repeater {
        model: Mpris.players

        Rectangle {
          id: playerButton
          required property MprisPlayer modelData
          Layout.preferredWidth: 30
          Layout.preferredHeight: 26
          color: modelData === root.player ? Appearance.colors.widgetActive : Appearance.colors.widget
          border.color: modelData === root.player ? Appearance.colors.m3tertiary : Appearance.colors.widgetOutline
          border.width: 1

          Image {
            anchors.centerIn: parent
            width: 18
            height: 18
            source: {
              const entry = DesktopEntries.byId(playerButton.modelData.desktopEntry);
              return Quickshell.iconPath(entry?.icon || "audio-x-generic-symbolic");
            }
            sourceSize.width: 36
            sourceSize.height: 36
          }

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: MprisController.setActivePlayer(playerButton.modelData)
          }
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.preferredHeight: 154
      spacing: 18

      TrackArtwork {
        Layout.preferredWidth: 154
        Layout.preferredHeight: 154
        slant: 18
        outlineColor: Appearance.colors.m3tertiary
      }

      ColumnLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 5

        StyledText {
          Layout.fillWidth: true
          text: MprisController.activeTrack?.title ?? "Nothing playing"
          font.pointSize: Appearance.font.size.large
          font.weight: Font.Bold
          color: "white"
          wrapMode: Text.Wrap
          maximumLineCount: 2
          elide: Text.ElideRight
        }

        StyledText {
          Layout.fillWidth: true
          text: MprisController.activeTrack?.artist ?? "Open a music player"
          font.pointSize: Appearance.font.size.normal
          color: Appearance.colors.m3tertiary
          elide: Text.ElideRight
        }

        StyledText {
          Layout.fillWidth: true
          text: MprisController.activeTrack?.album ?? ""
          color: Appearance.colors.m3onSurfaceVariant
          wrapMode: Text.Wrap
          maximumLineCount: 2
          elide: Text.ElideRight
        }

        Item { Layout.fillHeight: true }

        StyledText {
          Layout.fillWidth: true
          text: root.player ? `${Math.round((root.player.volume ?? 0) * 100)}% volume` : "No active player"
          color: Appearance.colors.m3onSurfaceVariant
          font.pointSize: Appearance.font.size.smaller
          horizontalAlignment: Text.AlignRight
        }
      }
    }

    SkewedSurface {
      Layout.fillWidth: true
      Layout.preferredHeight: 76
      slantLeft: true
      slantRight: true
      slant: 12
      shadowColor: "transparent"
      fillColor: "#2811131a"
      outlineColor: Appearance.colors.widgetOutline

      AnimatedLyrics {
        anchors {
          fill: parent
          leftMargin: 18
          rightMargin: 18
          topMargin: 8
          bottomMargin: 8
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: 10

      StyledText {
        text: root.timeString(root.position)
        color: Appearance.colors.m3onSurfaceVariant
        font.family: Appearance.font.family.mono
      }

      MediaSlider {
        id: seek
        Layout.fillWidth: true
        enabled: root.player?.canSeek ?? false
        from: 0
        to: Math.max(1, root.length)
        barColor: Appearance.colors.m3tertiary
        grooveColor: Appearance.colors.sliderGroove
        onPressedChanged: if (!pressed && root.player?.canSeek) root.player.position = value

        Binding {
          target: seek
          property: "value"
          value: root.position
          when: !seek.pressed
        }
      }

      StyledText {
        text: root.timeString(root.length)
        color: Appearance.colors.m3onSurfaceVariant
        font.family: Appearance.font.family.mono
      }
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      MediaControlButton {
        buttonSize: 34
        icon: (root.player?.volume ?? 0) <= 0 ? "volume_off" : "volume_up"
        enabled: MprisController.canChangeVolume
        onTriggered: root.player.volume = root.player.volume > 0 ? 0 : 0.7
      }

      MediaSlider {
        id: volume
        Layout.preferredWidth: 100
        from: 0
        to: 1
        enabled: MprisController.canChangeVolume
        barColor: Appearance.colors.m3tertiary
        grooveColor: Appearance.colors.sliderGroove
        onMoved: root.player.volume = value

        Binding {
          target: volume
          property: "value"
          value: root.player?.volume ?? 0
          when: !volume.pressed
        }
      }

      Item { Layout.fillWidth: true }

      MediaControlButton {
        buttonSize: 36
        icon: MprisController.hasShuffle ? "shuffle_on" : "shuffle"
        active: MprisController.hasShuffle
        enabled: MprisController.shuffleSupported
        onTriggered: MprisController.setShuffle(!MprisController.hasShuffle)
      }
      MediaControlButton {
        buttonSize: 36
        icon: "skip_previous"
        enabled: MprisController.canGoPrevious
        onTriggered: MprisController.previous()
      }
      MediaControlButton {
        buttonSize: 38
        prominent: true
        icon: MprisController.isPlaying ? "pause" : "play_arrow"
        enabled: MprisController.canTogglePlaying
        onTriggered: MprisController.togglePlaying()
      }
      MediaControlButton {
        buttonSize: 36
        icon: "skip_next"
        enabled: MprisController.canGoNext
        onTriggered: MprisController.next()
      }
      MediaControlButton {
        buttonSize: 36
        icon: MprisController.loopState === MprisLoopState.Track ? "repeat_one" : "repeat"
        active: MprisController.loopState !== MprisLoopState.None
        enabled: MprisController.loopSupported
        onTriggered: {
          if (MprisController.loopState === MprisLoopState.None)
            MprisController.setLoopState(MprisLoopState.Track);
          else if (MprisController.loopState === MprisLoopState.Track)
            MprisController.setLoopState(MprisLoopState.Playlist);
          else
            MprisController.setLoopState(MprisLoopState.None);
        }
      }
    }
  }
}
