pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import QtCore
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
  id: root
  property MprisPlayer trackedPlayer: null
  property MprisPlayer activePlayer: trackedPlayer ?? Mpris.players.values[0] ?? null
  signal trackChanged(reverse: bool)

  property bool __reverse: false

  property var activeTrack
  readonly property int position: Math.floor(activePlayer?.position ?? 0)
  readonly property int length: {
    const duration = activePlayer?.lengthSupported ? activePlayer.length : lyrics.trackDuration;
    return Number.isFinite(duration) && duration > 0 ? Math.floor(duration) : 0;
  }

  FrameAnimation {
    running: root.activePlayer?.isPlaying ?? false
    onTriggered: root.activePlayer?.positionChanged()
  }
  readonly property alias plainLyrics: lyrics.plainLyrics
  readonly property alias syncedLyrics: lyrics.syncedLyrics
  readonly property alias lyricsLoading: lyrics.lyricsLoading
  readonly property alias lyricsError: lyrics.lyricsError
  readonly property alias currentLyric: lyrics.currentLyric
  readonly property alias currentLyricIndex: lyrics.currentLyricIndex
  readonly property alias previousLyric: lyrics.previousLyric
  readonly property alias nextLyric: lyrics.nextLyric
  readonly property alias firstPlainLyric: lyrics.firstPlainLyric
  readonly property alias lyricProgress: lyrics.lineProgress
  readonly property alias lyricStatus: lyrics.statusText
  property alias lyricOffset: settings.lyricOffset

  Settings {
    id: settings
    location: "file://" + StandardPaths.writableLocation(StandardPaths.GenericConfigLocation) + "/quickshell-lyrics.ini"
    category: "lyrics"
    property real lyricOffset: 0
  }

  function retryLyrics(): void {
    lyrics.retry();
  }

  LyricsService {
    id: lyrics
    timingOffset: root.lyricOffset
    player: root.activePlayer
    track: root.activeTrack
  }

  Instantiator {
    model: Mpris.players

    Connections {
      required property MprisPlayer modelData
      target: modelData

      Component.onCompleted: {
        if (root.trackedPlayer == null || modelData.isPlaying)
          root.trackedPlayer = modelData;
      }

      Component.onDestruction: {
        if (root.trackedPlayer == null || !root.trackedPlayer.isPlaying) {
          for (const player of Mpris.players.values) {
            if (player.playbackState.isPlaying) {
              root.trackedPlayer = player;
              break;
            }
          }

          if (trackedPlayer == null && Mpris.players.values.length != 0)
            trackedPlayer = Mpris.players.values[0];
        }
      }

      function onPlaybackStateChanged() {
        if (root.trackedPlayer !== modelData)
          root.trackedPlayer = modelData;
      }
    }
  }

  Connections {
    target: activePlayer

    function onPostTrackChanged() {
      root.updateTrack();
    }

    function onTrackArtUrlChanged() {
      //root.updateTrack();
      if (root.activePlayer.uniqueId == root.activeTrack.uniqueId && root.activePlayer.trackArtUrl != root.activeTrack.artUrl) {
        // cantata likes to send cover updates *BEFORE* updating the track info.
        // as such, art url changes shouldn't be able to break the reverse animation
        const r = root.__reverse;
        root.updateTrack();
        root.__reverse = r;
      }
    }
  }

  onActivePlayerChanged: this.updateTrack()

  function updateTrack() {
    this.activeTrack = {
      uniqueId: this.activePlayer?.uniqueId ?? 0,
      artUrl: this.activePlayer?.trackArtUrl ?? "",
      title: this.activePlayer?.trackTitle || "Unknown Title",
      artist: this.activePlayer?.trackArtist || "Unknown Artist",
      album: this.activePlayer?.trackAlbum || "Unknown Album"
    };

    this.trackChanged(__reverse);
    this.__reverse = false;
  }

  property bool isPlaying: this.activePlayer && this.activePlayer.isPlaying
  property bool canTogglePlaying: this.activePlayer?.canTogglePlaying ?? false
  function togglePlaying() {
    if (this.canTogglePlaying)
      this.activePlayer.togglePlaying();
  }

  property bool canGoPrevious: this.activePlayer?.canGoPrevious ?? false
  function previous() {
    if (this.canGoPrevious) {
      this.__reverse = true;
      this.activePlayer.previous();
    }
  }

  property bool canGoNext: this.activePlayer?.canGoNext ?? false
  function next() {
    if (this.canGoNext) {
      this.__reverse = false;
      this.activePlayer.next();
    }
  }

  property bool canChangeVolume: !!(this.activePlayer?.volumeSupported && this.activePlayer?.canControl)

  property bool loopSupported: !!(this.activePlayer?.loopSupported && this.activePlayer?.canControl)
  property var loopState: this.activePlayer?.loopState ?? MprisLoopState.None
  function setLoopState(loopState: var) {
    if (this.loopSupported)
      this.activePlayer.loopState = loopState;
  }

  property bool shuffleSupported: !!(this.activePlayer?.shuffleSupported && this.activePlayer?.canControl)
  property bool hasShuffle: this.activePlayer?.shuffle ?? false
  function setShuffle(shuffle: bool) {
    if (this.shuffleSupported)
      this.activePlayer.shuffle = shuffle;
  }

  function setActivePlayer(player: MprisPlayer) {
    const targetPlayer = player ?? Mpris.players[0];

    if (targetPlayer && this.activePlayer)
      this.__reverse = Mpris.players.indexOf(targetPlayer) < Mpris.players.indexOf(this.activePlayer);
    else
      this.__reverse = false;

    this.trackedPlayer = targetPlayer;
  }

  IpcHandler {
    target: "mpris"

    function pauseAll(): void {
      for (const player of Mpris.players.values)
        if (player.canPause)
          player.pause();
    }

    function playPause(): void {
      root.togglePlaying();
    }
    function previous(): void {
      root.previous();
    }
    function next(): void {
      root.next();
    }
  }
}
