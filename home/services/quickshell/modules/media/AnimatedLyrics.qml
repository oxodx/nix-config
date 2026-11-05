pragma ComponentBehavior: Bound

import qs.services
import qs.theme
import QtQuick
import qs.components

// Three lyric lines for the bar's media strip: the previous line, the current line (with word
// highlight), and the next line. Each row has a fixed pixel height, so text cannot spill into the
// row above or below. A line change scrolls the column up by exactly one row, then snaps back
// with the rows relabelled, so the lines move up as a block.
Item {
  id: root
  clip: true
  z: 1

  property color currentColor: Appearance.colors.m3onSurface
  property color surroundingColor: Appearance.colors.m3onSurfaceVariant

  readonly property int rowHeight: 14
  readonly property real restY: (root.height - 3 * root.rowHeight) / 2

  readonly property var lines: MprisService.syncedLyrics
  readonly property bool hasLines: lines.length > 0
  readonly property int live: MprisService.currentLyricIndex

  // Lyric files often repeat a line right after itself (backing vocals). Back-to-back identical
  // lines are merged into one row, so they do not read as an echo.
  readonly property var uniq: {
    const out = [];
    for (let i = 0; i < lines.length; i++) {
      if (i === 0 || lines[i].text !== lines[i - 1].text)
        out.push(lines[i]);
    }
    return out;
  }
  readonly property var uniqIndex: {
    const map = [];
    let k = -1;
    for (let i = 0; i < lines.length; i++) {
      if (i === 0 || lines[i].text !== lines[i - 1].text)
        k++;
      map.push(k);
    }
    return map;
  }
  readonly property int liveUniq: live >= 0 && live < uniqIndex.length ? uniqIndex[live] : -1

  // The row shown in the middle. It lags `liveUniq` during the scroll.
  property int shown: -1
  readonly property int cur: shown >= 0 ? shown : 0
  readonly property bool synced: hasLines && shown >= 0
  readonly property bool lit: synced && shown === liveUniq

  readonly property string fallbackText: {
    if (MprisService.lyricsLoading) return "Finding lyrics…";
    return MprisService.firstPlainLyric || MprisService.lyricStatus;
  }

  function rowText(row: int): string {
    if (!hasLines)
      return row === 1 ? fallbackText : "";
    return uniq[cur - 1 + row]?.text || (row === 1 ? "♪" : "");
  }

  Component.onCompleted: shown = liveUniq

  Connections {
    target: MprisService
    function onSyncedLyricsChanged(): void {
      // A new song starts from its first line, with no scroll.
      scroll.stop();
      track.y = root.restY;
      root.shown = root.liveUniq;
    }
    function onCurrentLyricIndexChanged(): void {
      if (root.liveUniq === root.shown)
        return;
      // One row ahead scrolls. Anything else (a seek, or a skip) jumps.
      if (root.shown >= 0 && root.liveUniq === root.shown + 1 && !scroll.running) {
        scroll.restart();
      } else {
        scroll.stop();
        track.y = root.restY;
        root.shown = root.liveUniq;
      }
    }
  }

  SequentialAnimation {
    id: scroll
    NumberAnimation {
      target: track
      property: "y"
      to: root.restY - root.rowHeight
      duration: 320
      easing.type: Easing.InOutCubic
    }
    ScriptAction {
      script: {
        root.shown = root.liveUniq;
        track.y = root.restY;
      }
    }
  }

  Item {
    id: track
    x: 0
    y: root.restY
    width: root.width
    height: 4 * root.rowHeight

    Repeater {
      model: 4

      TimedLyricText {
        id: row
        required property int index
        readonly property bool middle: index === 1

        x: 0
        y: index * root.rowHeight
        width: track.width
        height: root.rowHeight
        lineText: root.rowText(index)
        words: middle && root.lit ? (root.uniq[root.shown]?.words ?? []) : []
        highlighting: middle && root.lit
        position: MprisService.lyricPosition
        color: middle && !root.lit && root.synced ? root.currentColor : root.surroundingColor
        highlightColor: root.currentColor
        opacity: middle ? 1 : 0.75
        font.pixelSize: middle ? 12 : 10
        font.weight: middle && root.synced ? Font.Bold : Font.Normal
        lineHeightMode: Text.FixedHeight
        lineHeight: root.rowHeight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }
    }
  }
}
