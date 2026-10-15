pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Scope {
  id: root
  property MprisPlayer player: null
  property var track: null
  onTrackChanged: fetchLyrics()

  property string plainLyrics: ""
  property var syncedLyrics: []
  property bool lyricsLoading: false
  property string lyricsError: ""
  property var lyricsCache: ({})
  property real timingOffset: 0
  property bool instrumental: false
  readonly property real effectivePosition: (player?.position ?? 0) + timingOffset
  readonly property real lineProgress: {
    if (currentLyricIndex < 0)
      return 0;
    const start = syncedLyrics[currentLyricIndex].time;
    const end = syncedLyrics[currentLyricIndex + 1]?.time ?? player?.length ?? start;
    return end > start ? Math.max(0, Math.min(1, (effectivePosition - start) / (end - start))) : 0;
  }
  readonly property string statusText: !player ? "Nothing playing" : lyricsLoading ? "Finding lyrics…" : instrumental ? "Instrumental" : syncedLyrics.length > 0 ? "Synced lyrics" : plainLyrics ? "Unsynced lyrics" : lyricsError || "No lyrics available"

  readonly property int currentLyricIndex: {
    const lines = syncedLyrics ?? [];
    if (!Array.isArray(lines))
      return -1;
    const position = effectivePosition;
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
    return track ? `${track.title}\n${track.artist}\n${track.album}`.toLowerCase() : "";
  }

  function parseSyncedLyrics(source: string): var {
    if (!source)
      return [];
    const lines = [];
    const offset = Number(source.match(/\[offset:([+-]?\d+)\]/i)?.[1] ?? 0) / 1000;
    for (const rawLine of source.split("\n")) {
      const timestamps = /\[(\d+):(\d+(?:\.\d+)?)\]/g;
      const text = rawLine.replace(/\[[^\]]*\]/g, "").trim();
      let match;
      while ((match = timestamps.exec(rawLine)) !== null)
        lines.push({
          time: Math.max(0, Number(match[1]) * 60 + Number(match[2]) + offset),
          text: text
        });
    }
    return lines.sort((a, b) => a.time - b.time);
  }

  function applyLyrics(result): void {
    plainLyrics = result.plainLyrics ?? "";
    syncedLyrics = parseSyncedLyrics(result.syncedLyrics ?? "");
    instrumental = result.instrumental ?? false;
    lyricsError = instrumental || plainLyrics || syncedLyrics.length > 0 ? "" : "No lyrics found";
  }

  function cacheAndApply(result): void {
    const updated = Object.assign({}, lyricsCache);
    updated[lyricProcess.requestKey] = result;
    lyricsCache = updated;
    if (lyricProcess.requestKey === lyricKey(track))
      applyLyrics(result);
  }

  function request(stage: string, url: string, requestArguments: var): void {
    lyricProcess.stage = stage;
    lyricProcess.command = ["curl", "--fail", "--silent", "--show-error", "--max-time", "12"].concat(requestArguments, [url]);
    lyricProcess.running = true;
  }

  function lrclibArguments(track): var {
    return ["--header", "Lrclib-Client: oxod-quickshell/1.0", "--get", "--data-urlencode", `track_name=${track.title}`, "--data-urlencode", `artist_name=${track.artist}`];
  }

  function startLrclibSearch(): void {
    request("search", "https://lrclib.net/api/search", lrclibArguments(track));
  }

  function startPlainLyricsFallback(): void {
    const primaryArtist = track.artist.split(/\s+(?:&|and|feat\.?|ft\.?)\s+|,|;/i)[0].trim();
    request("fallback", `https://api.lyrics.ovh/v1/${encodeURIComponent(primaryArtist)}/${encodeURIComponent(track.title)}`, []);
  }

  function fetchLyrics(): void {
    const track = root.track;
    const key = lyricKey(track);
    instrumental = false;
    if (!player || !track || !track.title || !track.artist) {
      plainLyrics = "";
      syncedLyrics = [];
      lyricsError = "";
      lyricsLoading = false;
      return;
    }

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
    // Let the old request finish; its exit handler will start the current
    // track rather than letting a late response replace the new lyrics.
    if (lyricProcess.running)
      return;
    lyricProcess.requestKey = key;
    const command = lrclibArguments(track).concat(["--data-urlencode", `album_name=${track.album}`]);
    const duration = Math.round(player.length ?? 0);
    if (duration >= 1 && duration <= 3600)
      command.push("--data-urlencode", `duration=${duration}`);
    request("exact", "https://lrclib.net/api/get", command);
  }

  function retry(): void {
    const updated = Object.assign({}, lyricsCache);
    delete updated[lyricKey(track)];
    lyricsCache = updated;
    fetchLyrics();
  }

  Process {
    id: lyricProcess
    property string requestKey: ""
    property string stage: "exact"

    stdout: StdioCollector {
      id: lyricOutput
    }

    onExited: code => {
      if (lyricProcess.requestKey !== root.lyricKey(root.track)) {
        root.fetchLyrics();
        return;
      }
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
          const normalize = value => String(value ?? "").toLowerCase().replace(/[\s.,!?'"():;_-]+/g, "");
          const score = result => (normalize(result.trackName) === normalize(root.track.title) ? 100 : 0) + (normalize(result.artistName) === normalize(root.track.artist) ? 50 : 0) + (result.syncedLyrics ? 10 : 0) - Math.abs((result.duration ?? root.player?.length ?? 0) - (root.player?.length ?? 0));
          response.sort((a, b) => score(b) - score(a));
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
}
