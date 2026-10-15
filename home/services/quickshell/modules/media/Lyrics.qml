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

  readonly property int currentLyricIndex: {
    const lines = syncedLyrics ?? [];
    if (!Array.isArray(lines))
      return -1;
    const position = player?.position ?? 0;
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
    if (!player || !track || !track.title || !track.artist) {
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
    const command = lrclibArguments(track).concat(["--data-urlencode", `album_name=${track.album}`]);
    const duration = Math.round(player.length ?? 0);
    if (duration >= 1 && duration <= 3600)
      command.push("--data-urlencode", `duration=${duration}`);
    request("exact", "https://lrclib.net/api/get", command);
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

}
