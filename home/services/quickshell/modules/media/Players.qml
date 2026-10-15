pragma ComponentBehavior: Bound

import qs.theme
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.components

FullwidthMouseArea {
  id: root

  required property var bar
  property bool skewed: false
  property bool compactBar: false
  property real edgeInset: 0
  readonly property var player: MprisController.activePlayer

  hoverEnabled: true
  fillWindowWidth: true
  acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.ForwardButton | Qt.BackButton

  PersistentProperties {
    id: persist
    reloadableId: "MusicWidget"
    property bool menuOpen: false
    onReloaded: mediaMenu.snapOpacity(menuOpen ? 1 : 0)
  }

  onPressed: event => {
    if (event.button === Qt.LeftButton)
      MprisController.togglePlaying();
    else if (event.button === Qt.RightButton)
      persist.menuOpen = !persist.menuOpen;
    else if (event.button === Qt.ForwardButton)
      MprisController.next();
    else if (event.button === Qt.BackButton)
      MprisController.previous();
  }

  onWheel: event => {
    event.accepted = true;
    if (MprisController.canChangeVolume)
      root.player.volume = Math.max(0, Math.min(1, root.player.volume + event.angleDelta.y / 2400));
  }

  BackgroundArt {
    id: background
    visible: !root.compactBar
    anchors.fill: parent
    overlay.color: "#b012141b"
    skewed: root.skewed

    function refresh(reverse: bool): void {
      setArt(MprisController.activeTrack?.artUrl ?? "", reverse, false);
    }

    Component.onCompleted: refresh(false)

    Connections {
      target: MprisController
      function onTrackChanged(reverse: bool): void { background.refresh(reverse); }
    }
  }

  RowLayout {
    visible: !root.compactBar
    anchors {
      fill: parent
      leftMargin: root.edgeInset + 6
      rightMargin: root.edgeInset + 6
      topMargin: 5
      bottomMargin: 6
    }
    spacing: 7

    TrackArtwork {
      Layout.preferredWidth: 30
      Layout.preferredHeight: 30
      slant: 5
      outlineColor: Appearance.colors.widgetOutline
    }

    ColumnLayout {
      Layout.minimumWidth: 100
      Layout.preferredWidth: 145
      Layout.maximumWidth: 170
      Layout.fillHeight: true
      spacing: -1

      StyledText {
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: root.player ? MprisController.activeTrack?.title ?? "Unknown title" : "Nothing playing"
        color: "#f8ffffff"
        font.pointSize: 10
        font.weight: Font.DemiBold
        verticalAlignment: Text.AlignBottom
        elide: Text.ElideRight
      }

      StyledText {
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: root.player ? MprisController.activeTrack?.artist ?? root.player.identity : "Open a media player"
        color: "#98ffffff"
        font.pointSize: 7
        verticalAlignment: Text.AlignTop
        elide: Text.ElideRight
      }
    }

    StyledRect {
      Layout.minimumWidth: 190
      Layout.preferredWidth: 330
      Layout.fillWidth: true
      Layout.fillHeight: true
      color: "#16000000"
      radius: 0

      AnimatedLyrics {
        anchors {
          fill: parent
          leftMargin: 10
          rightMargin: 10
        }
        compact: true
      }
    }

    MediaControlButton {
      Layout.preferredWidth: 34
      Layout.preferredHeight: 32
      buttonSize: 32
      icon: "skip_previous"
      enabled: MprisController.canGoPrevious
      onTriggered: MprisController.previous()
    }

    MediaControlButton {
      Layout.preferredWidth: 42
      Layout.preferredHeight: 34
      buttonSize: 30
      prominent: true
      icon: MprisController.isPlaying ? "pause" : "play_arrow"
      enabled: MprisController.canTogglePlaying
      onTriggered: MprisController.togglePlaying()
    }

    MediaControlButton {
      Layout.preferredWidth: 34
      Layout.preferredHeight: 32
      buttonSize: 32
      icon: "skip_next"
      enabled: MprisController.canGoNext
      onTriggered: MprisController.next()
    }
  }

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: root.edgeInset
    anchors.rightMargin: root.edgeInset
    anchors.topMargin: 1
    anchors.bottomMargin: 4
    visible: root.compactBar
    spacing: 16

    StyledText {
      Layout.preferredWidth: Math.min(135, root.width * 0.22)
      Layout.minimumWidth: 0
      text: (MprisController.activeTrack?.artist ?? root.player?.identity ?? "").toUpperCase()
      color: Appearance.colors.m3primary
      font.pointSize: 8
      font.weight: Font.Bold
      elide: Text.ElideRight
    }
    AnimatedLyrics {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.minimumWidth: 0
      compact: true
      currentColor: Appearance.colors.m3tertiary
      surroundingColor: "#40ffffff"
    }
    StyledText {
      Layout.preferredWidth: Math.min(145, root.width * 0.22)
      Layout.minimumWidth: 0
      text: (MprisController.activeTrack?.title ?? "").toUpperCase()
      horizontalAlignment: Text.AlignRight
      color: Appearance.colors.m3primary
      font.pointSize: 8
      font.weight: Font.Bold
      elide: Text.ElideRight
    }
  }

  ProgressBar {
    anchors {
      left: parent.left
      right: parent.right
      bottom: parent.bottom
      leftMargin: root.edgeInset + 8
      rightMargin: root.edgeInset + 8
    }
    visible: root.player !== null && MprisController.length > 0
    height: root.compactBar ? 1 : 3
    thickness: root.compactBar ? 1 : 3
    value: MprisController.position
    to: Math.max(1, MprisController.length)
  }

  property TooltipItem hoverTooltip: TooltipItem {
    tooltip: root.bar.tooltip
    owner: root
    show: root.containsMouse && !persist.menuOpen
    animateSize: false

    ColumnLayout {
      implicitWidth: 340
      spacing: 2

      StyledText {
        Layout.fillWidth: true
        text: MprisController.activeTrack?.title ?? "No media playing"
        font.weight: Font.DemiBold
        elide: Text.ElideRight
      }
      StyledText {
        Layout.fillWidth: true
        text: `${MprisController.activeTrack?.artist ?? ""}  •  right-click for details  •  scroll for volume`
        color: Appearance.colors.m3onSurfaceVariant
        elide: Text.ElideRight
      }
    }
  }

  property TooltipItem mediaMenu: TooltipItem {
    id: mediaMenu
    tooltip: root.bar.tooltip
    owner: root
    isMenu: true
    customBackground: true
    animateSize: false
    show: persist.menuOpen
    onClose: persist.menuOpen = false

    contentItem {
      implicitWidth: 560
      implicitHeight: 460
    }

    MediaMenu { anchors.fill: parent }
  }
}
