pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs
import qs.bar
import qs.components

FullwidthMouseArea {
  id: root
  hoverEnabled: true
  fillWindowWidth: true

  required property var bar
  property bool skewed: false
  property real edgeInset: 0
  implicitWidth: row.implicitWidth + 10

  PersistentProperties {
    id: persist
    reloadableId: "MusicWidget"
    property bool widgetOpen: false

    onReloaded: {
      rightclickMenu.snapOpacity(widgetOpen ? 1.0 : 0.0);
    }
  }

  property alias widgetOpen: persist.widgetOpen

  acceptedButtons: Qt.RightButton | Qt.ForwardButton | Qt.BackButton
  onPressed: event => {
    if (event.button == Qt.RightButton)
      widgetOpen = !widgetOpen;
    else if (event.button == Qt.ForwardButton)
      MprisController.next();
    else if (event.button == Qt.BackButton)
      MprisController.previous();
  }

  onWheel: event => {
    event.accepted = true;
    if (MprisController.canChangeVolume)
      root.activePlayer.volume = Math.max(0, Math.min(1, root.activePlayer.volume + (event.angleDelta.y / 120) * 0.05));
  }

  readonly property var activePlayer: MprisController.activePlayer

  Item {
    id: widget
    anchors.fill: parent

    property real scaleMul: widgetOpen ? 100 : 1
    Behavior on scaleMul {
      SmoothedAnimation {
        velocity: 600
      }
    }
    scale: scaleCurve.interpolate(scaleMul / 100, 1, (width - 6) / width)

    EasingCurve {
      id: scaleCurve
      curve.type: Easing.Linear
    }

    implicitWidth: row.implicitWidth + 10

    BackgroundArt {
      id: bkg
      anchors.fill: parent
      overlay.color: "#b012141b"
      skewed: root.skewed

      function updateArt(reverse: bool) {
        this.setArt(MprisController.activeTrack.artUrl, reverse, false);
      }

      Component.onCompleted: this.updateArt(false)

      Connections {
        target: MprisController

        function onTrackChanged(reverse: bool) {
          bkg.updateArt(reverse);
        }
      }
    }

    RowLayout {
      id: row
      spacing: 5

      anchors {
        fill: parent
        leftMargin: root.edgeInset + 5
        rightMargin: root.edgeInset + 5
        topMargin: 5
        bottomMargin: 5
      }

      Item {
        Layout.preferredWidth: 28
        Layout.preferredHeight: 28
        Layout.alignment: Qt.AlignVCenter

        StyledRect {
          anchors.fill: parent
          radius: 6
          color: "#20ffffff"
        }

        Image {
          anchors.fill: parent
          anchors.margins: 1
          source: MprisController.activeTrack?.artUrl || "image://icon/audio-x-generic-symbolic"
          fillMode: Image.PreserveAspectCrop
          cache: false
          asynchronous: true
          sourceSize.width: 56
          sourceSize.height: 56
        }
      }

      ColumnLayout {
        Layout.preferredWidth: 185
        Layout.fillHeight: true
        spacing: -1

        StyledText {
          Layout.fillWidth: true
          Layout.alignment: Qt.AlignVCenter
          text: MprisController.activePlayer ? (MprisController.activeTrack?.title ?? "Unknown title") : "Nothing playing"
          color: "#f8ffffff"
          font.pointSize: 10
          font.weight: Font.DemiBold
          elide: Text.ElideRight
        }

        StyledText {
          Layout.fillWidth: true
          text: MprisController.activePlayer ? (MprisController.activeTrack?.artist ?? MprisController.activePlayer.identity) : "Open a music player"
          color: "#98ffffff"
          font.pointSize: 7
          elide: Text.ElideRight
        }
      }

      StyledRect {
        Layout.preferredWidth: 330
        Layout.fillHeight: true
        radius: 7
        color: "#16000000"

        function lyricText(): string {
          if (!MprisController.activePlayer)
            return "Lyrics appear here";
          if (MprisController.lyricsLoading)
            return "Finding lyrics…";
          return MprisController.currentLyric || MprisController.firstPlainLyric || MprisController.lyricsError || "No lyrics found";
        }

        function updateLyrics(immediate: bool): void {
          lyricSlide.replace(lyricComponent, {
            currentText: lyricText(),
            nextText: MprisController.nextLyric,
            highlighted: MprisController.currentLyric !== "" || MprisController.firstPlainLyric !== ""
          }, immediate);
        }

        Component.onCompleted: updateLyrics(true)

        Timer {
          id: lyricUpdateTimer
          interval: 0
          onTriggered: parent.updateLyrics(false)
        }

        Connections {
          target: MprisController
          function onCurrentLyricChanged() {
            lyricUpdateTimer.restart();
          }
          function onNextLyricChanged() {
            lyricUpdateTimer.restart();
          }
          function onFirstPlainLyricChanged() {
            lyricUpdateTimer.restart();
          }
          function onLyricsLoadingChanged() {
            lyricUpdateTimer.restart();
          }
          function onLyricsErrorChanged() {
            lyricUpdateTimer.restart();
          }
          function onActivePlayerChanged() {
            lyricUpdateTimer.restart();
          }
        }

        SlideView {
          id: lyricSlide
          anchors.fill: parent
          anchors.leftMargin: 10
          anchors.rightMargin: 10
          anchors.topMargin: 2
          anchors.bottomMargin: 2
          clip: true

          enterTransition: YAnimator {
            from: lyricSlide.height * 0.55
            to: 0
            duration: 320
            easing.type: Easing.OutCubic
          }

          exitTransition: YAnimator {
            to: -lyricSlide.height * 0.55
            duration: 260
            easing.type: Easing.InCubic
          }
        }

        Component {
          id: lyricComponent

          Item {
            required property string currentText
            required property string nextText
            required property bool highlighted
            readonly property bool svReady: true

            ColumnLayout {
              anchors.fill: parent
              spacing: -1

              StyledText {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: parent.parent.currentText
                color: parent.parent.highlighted ? "white" : "#a8ffffff"
                font.pointSize: 8
                font.weight: parent.parent.highlighted ? Font.DemiBold : Font.Normal
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
              }

              StyledText {
                Layout.fillWidth: true
                text: parent.parent.nextText
                visible: text !== ""
                color: "#70ffffff"
                font.pointSize: 7
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
              }
            }
          }
        }
      }

      ClickableIcon {
        Layout.fillHeight: true
        Layout.preferredWidth: height
        image: "image://icon/media-skip-backward-symbolic"
        implicitWidth: height
        scaleIcon: false
        baseMargin: 3
        hoverEnabled: false
        enabled: MprisController.canGoPrevious
        onClicked: MprisController.previous()
      }

      ClickableIcon {
        Layout.fillHeight: true
        Layout.preferredWidth: height
        image: `image://icon/${MprisController.isPlaying ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"}`
        implicitWidth: height
        scaleIcon: false
        hoverEnabled: false
        enabled: MprisController.canTogglePlaying
        onClicked: MprisController.togglePlaying()
      }

      ClickableIcon {
        Layout.fillHeight: true
        Layout.preferredWidth: height
        image: "image://icon/media-skip-forward-symbolic"
        implicitWidth: height
        scaleIcon: false
        baseMargin: 3
        hoverEnabled: false
        enabled: MprisController.canGoNext
        onClicked: MprisController.next()
      }
    }

    StyledRect {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      anchors.leftMargin: 6
      anchors.rightMargin: 6
      height: 2
      radius: 1
      color: "#28ffffff"
      visible: MprisController.activePlayer != null && positionInfo.length > 0

      StyledRect {
        width: parent.width * Math.max(0, Math.min(1, positionInfo.position / positionInfo.length))
        height: parent.height
        radius: parent.radius
        color: "#d8ffffff"
      }
    }

    property Scope positionInfo: Scope {
      id: positionInfo

      property var player: root.activePlayer
      property int position: Math.floor(player?.position ?? 0)
      property int length: Math.floor(player?.length ?? 0)

      FrameAnimation {
        id: posTracker
        running: positionInfo.player?.isPlaying ?? false
        onTriggered: positionInfo.player?.positionChanged()
      }

      function timeStr(time: int): string {
        const seconds = time % 60;
        const minutes = Math.floor(time / 60);

        return `${minutes}:${seconds.toString().padStart(2, '0')}`;
      }
    }

    property TooltipItem tooltip: TooltipItem {
      id: tooltip
      tooltip: bar.tooltip
      owner: root
      show: root.containsMouse
      animateSize: false

      RowLayout {
        spacing: 10
        implicitWidth: 360

        Image {
          Layout.preferredWidth: 42
          Layout.preferredHeight: 42
          Layout.alignment: Qt.AlignVCenter
          source: MprisController.activeTrack?.artUrl || "image://icon/audio-x-generic-symbolic"
          fillMode: Image.PreserveAspectCrop
          cache: false
          asynchronous: true
          sourceSize.width: 84
          sourceSize.height: 84
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 2

          StyledText {
            Layout.fillWidth: true
            text: MprisController.activePlayer ? (MprisController.activeTrack?.title ?? "Unknown title") : "No media playing"
            color: "#f4f6fb"
            font.pointSize: 10
            font.weight: Font.DemiBold
            elide: Text.ElideRight
          }

          StyledText {
            Layout.fillWidth: true
            text: MprisController.activePlayer ? (MprisController.activeTrack?.artist ?? MprisController.activePlayer.identity) : "Open a music player"
            color: "#aeb5c5"
            font.pointSize: 8
            elide: Text.ElideRight
          }

          StyledText {
            Layout.fillWidth: true
            visible: MprisController.activePlayer != null
            text: `${positionInfo.timeStr(positionInfo.position)} / ${positionInfo.timeStr(positionInfo.length)}  •  ${MprisController.activePlayer?.identity ?? ""}`
            color: "#7f899e"
            font.pointSize: 7
            elide: Text.ElideRight
          }
        }
      }
    }

    property var rightclickMenu: TooltipItem {
      id: rightclickMenu
      tooltip: bar.tooltip
      owner: root

      isMenu: true
      show: widgetOpen
      onClose: widgetOpen = false

      // some very large covers take a sec to appear in the background,
      // so we'll try to preload them.
      preloadBackground: root.containsMouse

      backgroundComponent: BackgroundArt {
        id: popupBkg
        anchors.fill: parent
        renderHeight: rightclickMenu.implicitHeight
        renderWidth: rightclickMenu.implicitWidth
        blurRadius: 100
        blurSamples: 201

        overlay.color: "#80000000"

        Connections {
          target: MprisController

          function onTrackChanged(reverse: bool) {
            popupBkg.setArt(MprisController.activeTrack.artUrl, reverse, false);
          }
        }

        Component.onCompleted: {
          setArt(MprisController.activeTrack.artUrl, false, true);
        }
      }

      contentItem {
        implicitWidth: 500
        implicitHeight: 820
      }

      Loader {
        active: rightclickMenu.visible
        width: 500
        height: 820

        sourceComponent: ColumnLayout {
          anchors.fill: parent

          property var player: root.activePlayer

          Connections {
            target: MprisController

            function onTrackChanged(reverse: bool) {
              trackStack.updateTrack(reverse, false);
            }
          }

          Item {
            id: playerSelectorContainment
            Layout.fillWidth: true
            implicitHeight: playerSelector.implicitHeight + 20
            implicitWidth: playerSelector.implicitWidth

            StyledRect {
              anchors.centerIn: parent
              implicitWidth: 50
              implicitHeight: 50
              radius: 5
              color: "#20ceffff"
            }

            RowLayout { //ScrollView {
              id: playerSelector
              property Item selectedPlayerDisplay: null
              x: parent.width / 2 - (selectedPlayerDisplay ? selectedPlayerDisplay.x + selectedPlayerDisplay.width / 2 : 0)
              anchors.verticalCenter: parent.verticalCenter
              width: Math.min(implicitWidth, playerSelectorContainment.width)

              Behavior on x {
                NumberAnimation {
                  duration: 400
                  easing.type: Easing.OutExpo
                }
              }

              //RowLayout {
              Repeater {
                model: Mpris.players

                MouseArea {
                  required property MprisPlayer modelData
                  readonly property bool selected: modelData == player
                  onSelectedChanged: if (selected)
                    playerSelector.selectedPlayerDisplay = this

                  implicitWidth: childrenRect.width
                  implicitHeight: childrenRect.height

                  onClicked: MprisController.setActivePlayer(modelData)

                  Item {
                    implicitWidth: 50
                    implicitHeight: 50

                    Image {
                      anchors.fill: parent
                      anchors.margins: 5
                      source: {
                        const entry = DesktopEntries.byId(modelData.desktopEntry);
                        return Quickshell.iconPath(entry?.icon || "audio-x-generic-symbolic");
                      }

                      sourceSize.width: 50
                      sourceSize.height: 50
                      cache: false
                    }
                  }
                }
                //}
              }
            }
          }

          Item {
            Layout.fillWidth: true
            Layout.bottomMargin: 20

            Label {
              anchors.centerIn: parent
              text: root.activePlayer.identity
            }
          }

          SlideView {
            id: trackStack
            Layout.fillWidth: true
            implicitHeight: 400
            clip: animating || (lastFlicked?.contentX ?? 0) != 0

            // inverse of default tooltip margin - 1px for border
            Layout.leftMargin: -4
            Layout.rightMargin: -4

            property Flickable lastFlicked
            property bool reverse: false

            Component.onCompleted: updateTrack(false, true)

            function updateTrack(reverse: bool, immediate: bool) {
              this.reverse = reverse;
              this.replace(trackComponent, {
                track: MprisController.activeTrack
              }, immediate);
            }

            property var trackComponent: Component {
              Flickable {
                id: flickable
                required property var track
                // in most cases this is ready around the same time as the background,
                // but may take longer if the image is huge.
                readonly property bool svReady: img.status === Image.Ready
                contentWidth: width + 1
                onDragStarted: trackStack.lastFlicked = this
                onDragEnded: {
                  //return;
                  if (Math.abs(contentX) > 75) {
                    if (contentX < 0)
                      MprisController.previous();
                    else if (contentX > 0)
                      MprisController.next();
                  }
                }

                ColumnLayout {
                  id: trackContent
                  width: flickable.width
                  height: flickable.height

                  Item {
                    Layout.fillWidth: true
                    implicitHeight: 302//img.implicitHeight
                    implicitWidth: img.implicitWidth

                    Image {
                      id: img
                      anchors.centerIn: parent
                      source: track.artUrl ?? ""
                      //height: 300
                      //fillMode: Image.PreserveAspectFit
                      cache: false
                      asynchronous: true

                      sourceSize.height: 300
                      sourceSize.width: 300

                      StyledRect {
                        id: artMask
                        anchors.fill: parent
                        radius: 5
                        visible: false
                        layer.enabled: true
                      }

                      layer.enabled: true
                      layer.effect: MultiEffect {
                        maskEnabled: true
                        maskSource: artMask
                      }
                    }
                  }

                  CenteredText {
                    Layout.topMargin: 20
                    text: track.title
                    font.pointSize: albumLabel.font.pointSize + 1
                  }

                  CenteredText {
                    id: albumLabel
                    Layout.topMargin: 18
                    text: track.album
                    opacity: 0.8
                  }

                  CenteredText {
                    Layout.topMargin: 20
                    text: track.artist
                  }

                  Item {
                    Layout.fillHeight: true
                  }
                }
              }
            }

            readonly property real fromPos: trackStack.width * (trackStack.reverse ? -1 : 1)

            // intentionally slightly faster than the background
            enterTransition: PropertyAnimation {
              property: "x"
              from: trackStack.fromPos
              to: 0
              duration: 350
              easing.type: Easing.OutExpo
            }

            exitTransition: PropertyAnimation {
              property: "x"
              to: target.x - trackStack.fromPos
              duration: 350
              easing.type: Easing.OutExpo
            }
          }

          ColumnLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 155
            Layout.leftMargin: 18
            Layout.rightMargin: 18
            visible: MprisController.lyricsLoading || MprisController.syncedLyrics.length > 0 || MprisController.plainLyrics !== "" || MprisController.lyricsError !== ""
            spacing: 6

            Label {
              Layout.alignment: Qt.AlignHCenter
              text: "Lyrics"
              font.bold: true
              color: "#e8ffffff"
            }

            Label {
              Layout.alignment: Qt.AlignHCenter
              visible: MprisController.lyricsLoading || (MprisController.syncedLyrics.length === 0 && MprisController.plainLyrics === "")
              text: MprisController.lyricsLoading ? "Finding lyrics…" : MprisController.lyricsError
              color: "#a8ffffff"
            }

            ListView {
              id: syncedLyricsView
              Layout.fillWidth: true
              Layout.fillHeight: true
              visible: MprisController.syncedLyrics.length > 0
              clip: true
              spacing: 5
              model: MprisController.syncedLyrics
              currentIndex: MprisController.currentLyricIndex
              preferredHighlightBegin: height * 0.42
              preferredHighlightEnd: height * 0.58
              highlightRangeMode: ListView.ApplyRange

              delegate: StyledText {
                required property var modelData
                required property int index
                width: ListView.view.width
                text: modelData.text || "♪"
                color: index === syncedLyricsView.currentIndex ? "white" : "#78ffffff"
                font.pixelSize: index === syncedLyricsView.currentIndex ? 14 : 11
                font.weight: index === syncedLyricsView.currentIndex ? Font.DemiBold : Font.Normal
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
              }
            }

            ScrollView {
              Layout.fillWidth: true
              Layout.fillHeight: true
              visible: MprisController.syncedLyrics.length === 0 && MprisController.plainLyrics !== ""
              clip: true

              StyledText {
                width: parent.width
                text: MprisController.plainLyrics
                color: "#d8ffffff"
                font.pixelSize: 11
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
              }
            }
          }

          Item {
            Layout.fillHeight: true
          }

          Item {
            Layout.fillWidth: true
            implicitHeight: controlsRow.implicitHeight

            RowLayout {
              id: controlsRow
              anchors.centerIn: parent

              ClickableIcon {
                image: {
                  switch (MprisController.loopState) {
                  case MprisLoopState.None:
                    return "root:icons/repeat-none.svg";
                  case MprisLoopState.Playlist:
                    return "root:icons/repeat-all.svg";
                  case MprisLoopState.Track:
                    return "root:icons/repeat-once.svg";
                  }
                }

                implicitWidth: 50
                implicitHeight: width
                scaleIcon: false
                baseMargin: 3
                enabled: MprisController.loopSupported
                onClicked: {
                  let target = MprisLoopState.None;
                  switch (MprisController.loopState) {
                  case MprisLoopState.None:
                    target = MprisLoopState.Playlist;
                    break;
                  case MprisLoopState.Playlist:
                    target = MprisLoopState.Track;
                    break;
                  case MprisLoopState.Track:
                    target = MprisLoopState.None;
                    break;
                  }

                  MprisController.setLoopState(target);
                }
              }

              ClickableIcon {
                image: "image://icon/media-skip-backward-symbolic"
                implicitWidth: 60
                implicitHeight: width
                scaleIcon: false
                baseMargin: 3
                enabled: MprisController.canGoPrevious
                onClicked: MprisController.previous()
              }

              ClickableIcon {
                image: `image://icon/${MprisController.isPlaying ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"}`
                Layout.leftMargin: -10
                Layout.rightMargin: -10
                implicitWidth: 80
                implicitHeight: width
                scaleIcon: false
                enabled: MprisController.canTogglePlaying
                onClicked: MprisController.togglePlaying()
              }

              ClickableIcon {
                image: "image://icon/media-skip-forward-symbolic"
                implicitWidth: 60
                implicitHeight: width
                scaleIcon: false
                baseMargin: 3
                enabled: MprisController.canGoNext
                onClicked: MprisController.next()
              }

              ClickableIcon {
                image: `root:icons/${MprisController.hasShuffle ? "shuffle" : "shuffle-off"}.svg`
                implicitWidth: 50
                implicitHeight: width
                scaleIcon: false
                enabled: MprisController.shuffleSupported
                onClicked: MprisController.setShuffle(!MprisController.hasShuffle)
              }
            }
          }

          RowLayout {
            Layout.margins: 5

            Label {
              Layout.preferredWidth: lengthLabel.implicitWidth
              text: positionInfo.timeStr(positionInfo.position)
            }

            MediaSlider {
              id: slider
              property bool bindSlider: true

              property real boundAnimStart: 0
              property real boundAnimFactor: 1
              property real lastPosition: 0
              property real lastLength: 0
              property real boundPosition: {
                const ppos = player.position / player.length;
                const bpos = boundAnimStart;
                return (ppos * boundAnimFactor) + (bpos * (1.0 - boundAnimFactor));
              }

              NumberAnimation {
                id: boundAnim
                target: slider
                property: "boundAnimFactor"
                from: 0
                to: 1
                duration: 600
                easing.type: Easing.OutExpo
              }

              Connections {
                target: player

                function onPositionChanged() {
                  if (false && player.position == 0 && slider.lastPosition != 0 && !boundAnim.running) {
                    slider.boundAnimStart = slider.lastPosition / slider.lastLength;
                    boundAnim.start();
                  }

                  slider.lastPosition = player.position;
                  slider.lastLength = player.length;
                }
              }

              ColorQuantizer {
                id: quant
                rescaleSize: 200
                depth: 0
                source: MprisController.activeTrack.artUrl
              }

              grooveColor: quant.colors.length === 0 ? "#30ceffff" : Qt.alpha(quant.colors[0], 0.5)
              barColor: quant.colors.length === 0 ? "#80ceffff" : Qt.alpha(Qt.lighter(quant.colors[0]), 0.9)

              Behavior on grooveColor {
                ColorAnimation {
                  duration: 200
                }
              }
              Behavior on barColor {
                ColorAnimation {
                  duration: 200
                }
              }

              Layout.fillWidth: true
              enabled: player.canSeek
              from: 0
              to: 1

              onPressedChanged: {
                if (!pressed)
                  player.position = value * player.length;
                bindSlider = !pressed;
              }

              Binding {
                when: slider.bindSlider
                slider.value: slider.boundPosition
              }
            }

            Label {
              id: lengthLabel
              text: positionInfo.timeStr(positionInfo.length)
            }
          }
        }
      }
    }
  }

  component FullheightLabel: Item {
    implicitHeight: fontmetrics.height
    implicitWidth: label.implicitWidth

    property alias text: label.text

    Label {
      id: label
      anchors.verticalCenter: parent.verticalCenter
    }
  }

  component CenteredText: Item {
    Layout.fillWidth: true

    property alias text: label.text
    property alias font: label.font

    Label {
      id: label
      visible: text != ""
      anchors.centerIn: parent
      elide: Text.ElideRight
      width: Math.min(parent.width - 20, implicitWidth)
    }
  }
}
