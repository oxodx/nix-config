import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Io
import qs.services

Item {
    id: root
    property var player: MprisController.activePlayer
    readonly property string track: (player?.trackArtist || "") + " / " + (player?.trackTitle || "")
    readonly property string trackKey: JSON.stringify([player?.trackArtist || "", player?.trackTitle || ""])
    property var lines: []
    property string plainLyrics: ""
    property bool estimated: false
    readonly property bool loading: fetcher.running
    property string status: "Play a song for lyrics."
    property string requestedTrack: ""
    property string completedTrack: ""
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
    function estimatePlainLyrics() {
        if (!plainLyrics.length || lines.length || !(player?.length > 15)) return
        const verses = plainLyrics.split("\n").map(line => line.trim()).filter(line => line.length && !/^\[[^\]]+\]$/.test(line))
        if (!verses.length) return
        const weights = verses.map(line => Math.max(2, line.split(/\s+/).length))
        const total = weights.reduce((sum, weight) => sum + weight, 0)
        const lead = Math.min(10, player.length * 0.04)
        const span = Math.max(1, player.length - lead - Math.min(6, player.length * 0.03))
        let elapsed = 0
        const timed = verses.map((text,index) => {
            const line = {t: lead + span * elapsed / total, text: text}
            elapsed += weights[index]
            return line
        })
        estimated = true
        lines = timed
    }
    function fetch(force = false) {
        if (fetcher.running) return
        if (!force && completedTrack === trackKey && requestedTrack === trackKey) return
        if (!player?.trackTitle) { estimated = false; lines = []; plainLyrics = ""; completedTrack = ""; requestedTrack = ""; status = "Play a song for lyrics."; return }
        if (requestedTrack !== trackKey) { estimated = false; lines = []; plainLyrics = ""; plainScroll.contentY = 0 }
        requestedTrack = trackKey
        status = "Looking for lyrics…"
        const command = ["python3", Quickshell.shellPath("scripts/lyrics/fetch.py"), "--title", player.trackTitle, "--artist", player.trackArtist || "", "--album", player.trackAlbum || "", "--duration", String(player.length || 0)]
        if (force) command.push("--force")
        fetcher.command = command
        fetcher.running = true
    }
    onTrackKeyChanged: debounce.restart()
    Timer { id: debounce; interval: 650; onTriggered: root.fetch() }
    Timer {
        interval: 200; repeat: true; running: root.visible && (root.player?.isPlaying ?? false)
        onTriggered: root.position = root.player.position
    }
    Connections {
        target: root.player
        function onPositionChanged() { root.position = root.player?.position ?? 0 }
        function onLengthChanged() { root.estimatePlainLyrics() }
    }
    Process {
        id: fetcher
        stdout: StdioCollector { id: response }
        stderr: StdioCollector {}
        onExited: (code, exitStatus) => {
            if (root.requestedTrack !== root.trackKey) { debounce.restart(); return }
            root.completedTrack = root.requestedTrack
            try {
                if (code !== 0) throw new Error("lookup")
                const data = JSON.parse(response.text)
                root.estimated = false
                root.lines = root.parseLrc(data.syncedLyrics || "")
                root.plainLyrics = root.lines.length ? "" : data.plainLyrics || ""
                root.estimatePlainLyrics()
                root.status = data.status === "instrumental" ? "Instrumental ♡" : data.status === "offline" ? "Can't reach lyrics right now. Tap retry." : root.lines.length || root.plainLyrics ? "" : "No lyrics found for this track yet."
            } catch (error) { root.status = "Couldn't load lyrics. Tap retry." }
        }
    }
    readonly property real lineProgress: {
        if (currentLine < 0 || !lines[currentLine]) return 0
        const start = lines[currentLine].t
        const end = lines[currentLine + 1]?.t ?? player?.length ?? start + 5
        return Math.max(0, Math.min(1, (position - start) / Math.max(0.1, end - start)))
    }
    EncoreLyricVisual {
        visible: root.lines.length > 0 || !root.plainLyrics.length
        anchors.fill: parent
        timedLines: root.lines
        lineIndex: root.currentLine
        lineText: root.lines[root.currentLine]?.text || root.status || "♫"
        previousText: root.lines[root.currentLine - 1]?.text || ""
        nextText: root.lines[root.currentLine + 1]?.text || ""
        trackText: root.player?.trackTitle ? root.track : ""
        playing: root.player?.isPlaying ?? false
        estimated: root.estimated
        synced: root.currentLine >= 0 && root.lines.length > 0
        lineProgress: root.lineProgress
    }
    ColumnLayout {
        anchors.fill: parent; spacing: 8
        visible: root.plainLyrics.length > 0 && !root.lines.length
        EncoreText { text: "♡  LYRICS / UNSYNCED"; color: EncoreStyle.pink; font.pixelSize: 10; font.letterSpacing: 2; Layout.alignment: Qt.AlignHCenter }
        Flickable {
            id: plainScroll
            Layout.fillWidth: true; Layout.fillHeight: true
            clip: true; contentHeight: plainText.implicitHeight
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {}
            EncoreText {
                id: plainText; width: plainScroll.width - 14
                text: root.plainLyrics; wrapMode: Text.Wrap; horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 21; font.bold: true; color: "#f0e1fc"
                style: Text.Outline; styleColor: "#451f58"
            }
        }
        EncoreText { text: root.track; font.pixelSize: 10; color: EncoreStyle.muted; Layout.fillWidth: true; horizontalAlignment: Text.AlignHCenter }
    }
    EncoreButton {
        anchors.right: parent.right; anchors.top: parent.top
        symbol: "refresh"; implicitWidth: 26; implicitHeight: 26; padding: 2
        visible: !root.lines.length && !root.plainLyrics.length && !!root.player?.trackTitle
        enabled: !root.loading; hint: "Retry lyrics lookup"
        onClicked: root.fetch(true)
    }
}
