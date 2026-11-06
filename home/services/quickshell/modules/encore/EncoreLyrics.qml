import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.services

Item {
    id: root
    readonly property var player: MprisController.activePlayer
    readonly property string track: (player?.trackArtist || "") + " / " + (player?.trackTitle || "")
    property var lines: []
    property string status: "Play a song for lyrics."
    property string requestedTrack: ""
    property real position: player?.position ?? 0
    readonly property int currentLine: {
        let current = -1
        for (let i = 0; i < lines.length; i++) { if (lines[i].t <= position) current = i; else break }
        return current
    }
    function parseLrc(text) {
        const parsed = []
        for (const line of text.split("\n")) {
            const tags = /\[(\d+):(\d+(?:\.\d+)?)\]/g
            const words = line.replace(/\[[^\]]+\]/g, "").trim()
            let match
            while ((match = tags.exec(line)) !== null)
                parsed.push({t:Number(match[1])*60+Number(match[2]), text:words})
        }
        return parsed.sort((a,b) => a.t-b.t)
    }
    function fetch() {
        lines = []
        if (!player?.trackTitle) { status = "Play a song for lyrics."; return }
        requestedTrack = track
        status = "Looking for lyrics…"
        fetcher.running = false
        const url = "https://lrclib.net/api/get?artist_name=" + encodeURIComponent(player.trackArtist || "") + "&track_name=" + encodeURIComponent(player.trackTitle) + "&album_name=" + encodeURIComponent(player.trackAlbum || "") + "&duration=" + Math.round(player.length || 0)
        fetcher.command = ["curl", "--fail", "--silent", "--show-error", "--max-time", "12", "--user-agent", "EncoreQuickshell/1.0", url]
        fetcher.running = true
    }
    onTrackChanged: { fetcher.running = false; requestedTrack = ""; lines = []; debounce.restart() }
    Timer { id: debounce; interval: 500; onTriggered: root.fetch() }
    Timer {
        interval: 200; repeat: true; running: root.visible && (root.player?.isPlaying ?? false)
        onTriggered: { root.player.positionChanged(); root.position = root.player.position }
    }
    Process {
        id: fetcher
        stdout: StdioCollector {
            onStreamFinished: {
                if (root.requestedTrack !== root.track) return
                try {
                    const data = JSON.parse(text)
                    root.lines = root.parseLrc(data.syncedLyrics || "")
                    root.status = data.instrumental ? "Instrumental ♡" : root.lines.length ? "" : "No synced lyrics for this track."
                } catch (error) { root.status = "Lyrics unavailable. Your music still sounds good." }
            }
        }
        onExited: (code, exitStatus) => { if (code !== 0 && root.requestedTrack === root.track) root.status = "Lyrics unavailable offline." }
    }
    readonly property real lineProgress: {
        if (currentLine < 0 || !lines[currentLine]) return 0
        const start = lines[currentLine].t
        const end = lines[currentLine + 1]?.t ?? player?.length ?? start + 5
        return Math.max(0, Math.min(1, (position - start) / Math.max(0.1, end - start)))
    }
    EncoreLyricVisual {
        anchors.fill: parent
        lineText: root.lines[root.currentLine]?.text || root.status || "♫"
        previousText: root.lines[root.currentLine - 1]?.text || ""
        nextText: root.lines[root.currentLine + 1]?.text || ""
        trackText: root.player?.trackTitle ? root.track : ""
        playing: root.player?.isPlaying ?? false
        synced: root.currentLine >= 0 && root.lines.length > 0
        lineProgress: root.lineProgress
    }
}
