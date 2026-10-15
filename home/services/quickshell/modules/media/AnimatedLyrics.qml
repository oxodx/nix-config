pragma ComponentBehavior: Bound

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

  function currentText(): string {
    if (MprisController.lyricsLoading)
      return "Finding lyrics…";
    return MprisController.currentLyric || MprisController.firstPlainLyric || MprisController.lyricsError || "No lyrics available";
  }

  function populate(layer: Item): void {
    layer.currentText = currentText();
    if (currentText() === "Finding lyrics…" || currentText() === "No lyrics available") {
      layer.previousText = "";
      layer.nextText = "";
    } else {
      layer.previousText = MprisController.previousLyric;
      layer.nextText = MprisController.nextLyric;
    }
    layer.synced = MprisController.currentLyric !== "";
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
    target: MprisController
    function onCurrentLyricIndexChanged(): void {
      root.refresh(false);
    }
    function onFirstPlainLyricChanged(): void {
      root.refresh(false);
    }
    function onLyricsLoadingChanged(): void {
      root.refresh(false);
    }
    function onLyricsErrorChanged(): void {
      root.refresh(false);
    }
    function onActivePlayerChanged(): void {
      root.refresh(true);
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
    property string previousText: ""
    property string currentText: ""
    property string nextText: ""
    property bool synced: false

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

      StyledText {
        Layout.fillWidth: true
        Layout.fillHeight: true
        text: parent.parent.currentText
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
