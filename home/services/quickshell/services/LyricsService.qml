pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Scope {
  id: root

  property MprisPlayer player: null
  property var track: null
  property real timingOffset: 0
  property string plainLyrics: ""
  property var syncedLyrics: []
  property bool lyricsLoading: false
  property string lyricsError: ""
  property bool instrumental: false
  property bool enhanced: false
  property string source: ""
  property real trackDuration: 0
  readonly property real clockPosition: player?.position ?? 0
  readonly property real effectivePosition: clockPosition + timingOffset
  readonly property string statusText: !player ? "Nothing playing" : lyricsLoading ? "Finding lyrics…" : instrumental ? "Instrumental" : syncedLyrics.length ? (enhanced ? "Word-synced lyrics" : "Synced lyrics") : plainLyrics ? "Unsynced lyrics" : lyricsError || "No lyrics available"
  readonly property int currentLyricIndex: {
    let low = 0;
    let high = syncedLyrics.length;
    while (low < high) {
      const middle = (low + high) >> 1;
      if (syncedLyrics[middle].time <= effectivePosition) low = middle + 1;
      else high = middle;
    }
    return low - 1;
  }
  readonly property string currentLyric: syncedLyrics[currentLyricIndex]?.text ?? ""
  readonly property string previousLyric: syncedLyrics[currentLyricIndex - 1]?.text ?? ""
  readonly property string nextLyric: syncedLyrics[currentLyricIndex + 1]?.text ?? ""
  readonly property string firstPlainLyric: plainLyrics.split("\n").map(line => line.trim()).find(line => line !== "") ?? ""
  readonly property real lineProgress: {
    const line = syncedLyrics[currentLyricIndex];
    if (!line) return 0;
    if (line.words?.length) {
      let characters = 0;
      for (const word of line.words) {
        if (effectivePosition < word.start) break;
        const fraction = word.end > word.start ? Math.max(0, Math.min(1, (effectivePosition - word.start) / (word.end - word.start))) : 1;
        characters = word.offset + word.length * fraction;
        if (fraction < 1) break;
      }
      return line.text.length ? Math.max(0, Math.min(1, characters / line.text.length)) : 0;
    }
    return line.end > line.time ? Math.max(0, Math.min(1, (effectivePosition - line.time) / (line.end - line.time))) : 0;
  }

  // MprisService already ticks Quickshell's interpolated position. A second
  // clock plus playerctl corrections can repeatedly rewind stale players.
  onTrackChanged: lookupDelay.restart()

  function lyricKey(): string {
    if (!track || !player || !track.title || track.title === "Unknown Title") return "";
    if ((!track.artist || track.artist === "Unknown Artist") && !track.title.includes(" - ")) return "";
    return JSON.stringify([(track.artist ?? "").trim().toLowerCase(), track.title.trim().toLowerCase()]);
  }

  Timer {
    id: lookupDelay
    interval: 300
    onTriggered: root.fetchLyrics(false)
  }

  function clear(): void {
    plainLyrics = "";
    syncedLyrics = [];
    lyricsError = "";
    instrumental = false;
    enhanced = false;
    source = "";
    trackDuration = 0;
  }

  function fetchLyrics(refresh: bool): void {
    const key = lyricKey();
    if (key === lookup.requestKey && lookup.running) return;
    if (!refresh && key === lookup.requestKey && (syncedLyrics.length || plainLyrics || instrumental)) return;
    if (!key) {
      clear();
      lyricsLoading = false;
      return;
    }
    if (key !== lookup.requestKey) clear();
    lyricsLoading = !(syncedLyrics.length || plainLyrics || instrumental);
    if (lookup.running) return;
    lookup.requestKey = key;
    const metadata = JSON.stringify({artist: track.artist, title: track.title, album: track.album, duration: player.lengthSupported ? Math.round(player.length) : 0});
    lookup.command = ["quickshell-lyrics", metadata].concat(refresh ? ["--refresh"] : []);
    lookup.running = true;
  }

  function retry(): void { fetchLyrics(true); }

  Process {
    id: lookup
    property string requestKey: ""
    stdout: SplitParser {
      onRead: data => {
        if (lookup.requestKey !== root.lyricKey()) return;
        try {
          const result = JSON.parse(data);
          root.syncedLyrics = Array.isArray(result.lines) ? result.lines : [];
          root.plainLyrics = result.plainLyrics ?? "";
          root.enhanced = result.enhanced ?? false;
          root.instrumental = result.instrumental ?? false;
          root.source = result.source ?? "";
          root.trackDuration = Number(result.duration) || 0;
          root.lyricsLoading = false;
          root.lyricsError = "";
        } catch (error) {
          root.lyricsError = "Could not read lyrics — retry";
        }
      }
    }
    onRunningChanged: {
      if (running) watchdog.restart();
      else watchdog.stop();
    }
    onExited: code => {
      if (requestKey !== root.lyricKey()) {
        lookupDelay.restart();
        return;
      }
      root.lyricsLoading = false;
      if (code !== 0) {
        root.lyricsError = "Lyrics lookup failed — retry";
        return;
      }
      root.lyricsError = root.syncedLyrics.length || root.plainLyrics || root.instrumental ? "" : "No lyrics found";
    }
  }

  Timer {
    id: watchdog
    interval: 40000
    onTriggered: {
      lookup.running = false;
      root.lyricsLoading = false;
      root.lyricsError = "Lyrics lookup timed out — retry";
    }
  }
}
