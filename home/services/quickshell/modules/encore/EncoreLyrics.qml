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
    ColumnLayout {
        anchors.fill: parent; spacing: 8
        EncoreText { Layout.fillWidth: true; text: root.lines[root.currentLine - 1]?.text || ""; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 14; color: "#dfbce9"; style: Text.Outline; styleColor: "#451f58" }
        EncoreText {
            Layout.fillWidth: true; Layout.fillHeight: true
            text: root.lines[root.currentLine]?.text || root.status || "♫"
            horizontalAlignment: Text.AlignHCenter; wrapMode: Text.Wrap
            font.pixelSize: 24; font.bold: true; color: "#fff0fc"; style: Text.Outline; styleColor: "#55246c"
        }
        EncoreText { Layout.fillWidth: true; text: root.player?.trackTitle ? root.track : ""; horizontalAlignment: Text.AlignHCenter; font.pixelSize: 10; color: "#ead6fa"; style: Text.Outline; styleColor: "#451f58" }
    }
}
