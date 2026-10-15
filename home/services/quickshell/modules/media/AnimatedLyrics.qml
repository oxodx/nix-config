pragma ComponentBehavior: Bound

import qs.services
import qs.theme
import QtQuick
import QtQuick.Layouts
import qs.components

Item {
  id: root
  clip: true

  property bool compact: false
  property color currentColor: "white"
  property color surroundingColor: "#70ffffff"
  property bool frontActive: true
  property bool immediateRefresh: false

  function scheduleRefresh(immediate: bool): void {
    immediateRefresh = immediateRefresh || immediate;
    Qt.callLater(applyRefresh);
  }

  function applyRefresh(): void {
    const immediate = immediateRefresh;
    immediateRefresh = false;
    refresh(immediate);
  }

  function currentText(): string {
    if (MprisService.lyricsLoading)
      return "Finding lyrics…";
    const lines = MprisService.syncedLyrics;
    const index = MprisService.currentLyricIndex;
    return index >= 0 ? lines[index]?.text || "♪" : MprisService.firstPlainLyric || MprisService.lyricStatus;
  }

  function populate(layer: Item): void {
    layer.lyricIndex = MprisService.currentLyricIndex;
    layer.words = MprisService.syncedLyrics[layer.lyricIndex]?.words ?? [];
    layer.currentText = currentText();
    if (currentText() === "Finding lyrics…" || currentText() === "No lyrics available") {
      layer.previousText = "";
      layer.nextText = "";
    } else {
      const lines = MprisService.syncedLyrics;
      const index = MprisService.currentLyricIndex;
      layer.previousText = lines[index - 1]?.text ?? "";
      layer.nextText = lines[index + 1]?.text ?? "";
    }
    layer.synced = MprisService.currentLyricIndex >= 0;
  }

  function refresh(immediate: bool): void {
    if (transition.running)
      transition.complete();

    const outgoing = frontActive ? front : back;
    const incoming = frontActive ? back : front;
    populate(incoming);

    if (immediate) {
      outgoing.opacity = 0;
      outgoing.y = 0;
      incoming.opacity = 1;
      incoming.y = 0;
      frontActive = !frontActive;
      return;
    }

    incoming.opacity = 0;
    incoming.y = height * 0.3;
    transition.restart();
  }

  Component.onCompleted: {
    populate(front);
    front.opacity = 1;
    back.opacity = 0;
  }

  Connections {
    target: MprisService
    function onCurrentLyricIndexChanged(): void {
      root.scheduleRefresh(false);
    }
    function onFirstPlainLyricChanged(): void {
      root.scheduleRefresh(false);
    }
    function onLyricsLoadingChanged(): void {
      root.scheduleRefresh(false);
    }
    function onLyricsErrorChanged(): void {
      root.scheduleRefresh(false);
    }
    function onLyricStatusChanged(): void {
      root.scheduleRefresh(false);
    }
    function onActivePlayerChanged(): void {
      root.scheduleRefresh(true);
    }
    function onSyncedLyricsChanged(): void {
      root.scheduleRefresh(true);
    }
  }

  LyricStack {
    id: front
    width: root.width
    height: root.height
  }

  LyricStack {
    id: back
    width: root.width
    height: root.height
  }

  ParallelAnimation {
    id: transition

    YAnimator {
      target: root.frontActive ? front : back
      from: 0
      to: -root.height * 0.3
      duration: 520
      easing.type: Easing.InOutCubic
    }

    OpacityAnimator {
      target: root.frontActive ? front : back
      from: 1
      to: 0
      duration: 420
      easing.type: Easing.InOutCubic
    }

    YAnimator {
      target: root.frontActive ? back : front
      from: root.height * 0.3
      to: 0
      duration: 520
      easing.type: Easing.InOutCubic
    }

    OpacityAnimator {
      target: root.frontActive ? back : front
      from: 0
      to: 1
      duration: 460
      easing.type: Easing.InOutCubic
    }

    onFinished: root.frontActive = !root.frontActive
  }

  component LyricStack: Item {
    id: stack
    property string previousText: ""
    property string currentText: ""
    property string nextText: ""
    property bool synced: false
    property int lyricIndex: -1
    property var words: []

    ColumnLayout {
      anchors.fill: parent
      spacing: root.compact ? -2 : 0

      StyledText {
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: parent.parent.previousText
        color: root.surroundingColor
        font.pointSize: root.compact ? 6 : Appearance.font.size.smaller
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }

      TimedLyricText {
        Layout.fillWidth: true
        Layout.fillHeight: true
        lineText: stack.currentText
        words: stack.words
        position: MprisService.lyricPosition
        highlighting: stack.synced && stack.lyricIndex === MprisService.currentLyricIndex
        color: parent.parent.synced ? root.currentColor : Appearance.colors.m3onSurfaceVariant
        font.pointSize: root.compact ? 8 : Appearance.font.size.normal
        font.weight: parent.parent.synced ? Font.Bold : Font.Normal
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }

      StyledText {
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: parent.parent.nextText
        color: root.surroundingColor
        font.pointSize: root.compact ? 6 : Appearance.font.size.smaller
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }
    }
  }
}
