pragma Singleton
pragma ComponentBehavior: Bound

import QtQml.Models
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import qs

Singleton {
  id: root
  property MprisPlayer trackedPlayer: null
  property MprisPlayer activePlayer: trackedPlayer ?? Mpris.players.values[0] ?? null
  signal trackChanged(reverse: bool)

  property bool __reverse: false

  property var activeTrack
  property string plainLyrics: ""
  property var syncedLyrics: []
  property bool lyricsLoading: false
  property string lyricsError: ""
  property var lyricsCache: ({})

  readonly property int currentLyricIndex: {
    const lines = syncedLyrics ?? [];
    if (!Array.isArray(lines))
      return -1;
    const position = activePlayer?.position ?? 0;
    let current = -1;
    for (let i = 0; i < lines.length; ++i) {
      if (lines[i].time > position)
        break;
      current = i;
    }
    return current;
  }
  readonly property string currentLyric: currentLyricIndex >= 0 ? syncedLyrics[currentLyricIndex].text : ""
  readonly property string previousLyric: currentLyricIndex > 0 ? syncedLyrics[currentLyricIndex - 1].text : ""
  readonly property string nextLyric: currentLyricIndex + 1 < syncedLyrics.length ? syncedLyrics[currentLyricIndex + 1].text : ""
  readonly property string firstPlainLyric: plainLyrics.split("\n").map(line => line.trim()).find(line => line !== "") ?? ""

  function lyricKey(track): string {
    return `${track.title}\n${track.artist}\n${track.album}`.toLowerCase();
  }

  function parseSyncedLyrics(source: string): var {
    if (!source)
      return [];
    const lines = [];
    for (const rawLine of source.split("\n")) {
      const match = rawLine.match(/^\[(\d+):(\d+(?:\.\d+)?)\](.*)$/);
      if (!match)
        continue;
      lines.push({
        time: Number(match[1]) * 60 + Number(match[2]),
        text: match[3].trim()
      });
    }
    return lines;
  }

  function applyLyrics(result): void {
    plainLyrics = result.plainLyrics ?? "";
    syncedLyrics = parseSyncedLyrics(result.syncedLyrics ?? "");
    lyricsError = plainLyrics || syncedLyrics.length > 0 ? "" : "No lyrics found";
  }

  function cacheAndApply(result): void {
    const updated = Object.assign({}, lyricsCache);
    updated[lyricProcess.requestKey] = result;
    lyricsCache = updated;
    if (lyricProcess.requestKey === lyricKey(activeTrack))
      applyLyrics(result);
  }

  function startLrclibSearch(): void {
    lyricProcess.stage = "search";
    lyricProcess.command = ["curl", "--fail", "--silent", "--show-error", "--max-time", "12", "--header", "Lrclib-Client: oxod-quickshell/1.0", "--get", "https://lrclib.net/api/search", "--data-urlencode", `track_name=${activeTrack.title}`, "--data-urlencode", `artist_name=${activeTrack.artist}`];
    lyricProcess.running = true;
  }

  function startPlainLyricsFallback(): void {
    const primaryArtist = activeTrack.artist.split(/\s+(?:&|and|feat\.?|ft\.?)\s+|,|;/i)[0].trim();
    lyricProcess.stage = "fallback";
    lyricProcess.command = ["curl", "--fail", "--silent", "--show-error", "--max-time", "12", `https://api.lyrics.ovh/v1/${encodeURIComponent(primaryArtist)}/${encodeURIComponent(activeTrack.title)}`];
    lyricProcess.running = true;
  }

  function fetchLyrics(): void {
    const track = activeTrack;
    if (!activePlayer || !track || !track.title || !track.artist) {
      plainLyrics = "";
      syncedLyrics = [];
      lyricsError = "";
      lyricsLoading = false;
      return;
    }

    const key = lyricKey(track);
    const cached = lyricsCache[key];
    if (cached !== undefined) {
      applyLyrics(cached);
      lyricsLoading = false;
      return;
    }

    lyricsLoading = true;
    lyricsError = "";
    plainLyrics = "";
    syncedLyrics = [];
    lyricProcess.requestKey = key;
    lyricProcess.stage = "exact";
    const command = ["curl", "--fail", "--silent", "--show-error", "--max-time", "12", "--header", "Lrclib-Client: oxod-quickshell/1.0", "--get", "https://lrclib.net/api/get", "--data-urlencode", `track_name=${track.title}`, "--data-urlencode", `artist_name=${track.artist}`, "--data-urlencode", `album_name=${track.album}`];
    const duration = Math.round(activePlayer.length ?? 0);
    if (duration >= 1 && duration <= 3600)
      command.push("--data-urlencode", `duration=${duration}`);
    lyricProcess.command = command;
    lyricProcess.running = true;
  }

  Process {
    id: lyricProcess
    property string requestKey: ""
    property string stage: "exact"

    stdout: StdioCollector {
      id: lyricOutput
    }

    onExited: code => {
      if (code !== 0) {
        if (lyricProcess.stage === "exact")
          root.startLrclibSearch();
        else if (lyricProcess.stage === "search")
          root.startPlainLyricsFallback();
        else {
          root.lyricsLoading = false;
          root.lyricsError = "No lyrics found";
        }
        return;
      }

      try {
        const response = JSON.parse(lyricOutput.text);
        if (lyricProcess.stage === "search") {
          if (!Array.isArray(response) || response.length === 0) {
            root.startPlainLyricsFallback();
            return;
          }
          root.cacheAndApply(response[0]);
        } else if (lyricProcess.stage === "fallback") {
          root.cacheAndApply({
            plainLyrics: response.lyrics ?? "",
            syncedLyrics: ""
          });
        } else
          root.cacheAndApply(response);
        root.lyricsLoading = false;
      } catch (error) {
        if (lyricProcess.stage !== "fallback")
          root.startPlainLyricsFallback();
        else {
          root.lyricsLoading = false;
          root.lyricsError = "Could not read lyrics";
        }
      }
    }
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

    this.fetchLyrics();

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
