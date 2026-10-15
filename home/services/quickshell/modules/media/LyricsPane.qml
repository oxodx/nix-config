pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import qs.theme
import qs.components

SkewedSurface {
  id: root
  property var controller: MprisController
  implicitHeight: 270
  slantLeft: true
  slantRight: true
  slant: 14
  shadowColor: "transparent"
  fillColor: "#2811131a"
  outlineColor: Appearance.colors.widgetOutline
  property bool follow: true
  readonly property bool synced: root.controller.syncedLyrics.length > 0
  readonly property var lines: synced ? root.controller.syncedLyrics : root.controller.plainLyrics.split("\n").map(text => ({
        text: text.trim()
      })).filter(line => line.text !== "")

  function followCurrent() {
    if (follow && synced && list.count > 0)
      list.positionViewAtIndex(Math.max(0, root.controller.currentLyricIndex), ListView.Center);
  }
  onFollowChanged: if (follow)
    followCurrent()
  onLinesChanged: {
    follow = true;
    Qt.callLater(followCurrent);
  }
  Connections {
    target: root.controller
    function onCurrentLyricIndexChanged() {
      root.followCurrent();
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.leftMargin: 22
    anchors.rightMargin: 22
    anchors.topMargin: 10
    anchors.bottomMargin: 10
    spacing: 6

    RowLayout {
      Layout.fillWidth: true
      spacing: 5
      MaterialIcon {
        text: "lyrics"
        font.pointSize: 14
        color: Appearance.colors.m3tertiary
      }
      StyledText {
        Layout.fillWidth: true
        text: root.controller.lyricStatus
        font.pointSize: Appearance.font.size.small
        color: Appearance.colors.m3onSurfaceVariant
        elide: Text.ElideRight
      }
      MediaControlButton {
        buttonSize: 28
        iconSize: 13
        icon: "refresh"
        enabled: !root.controller.lyricsLoading && root.controller.activePlayer !== null
        onTriggered: root.controller.retryLyrics()
      }
      MediaControlButton {
        buttonSize: 28
        iconSize: 13
        icon: "my_location"
        active: root.follow
        enabled: root.synced
        onTriggered: {
          root.follow = true;
          root.followCurrent();
        }
      }
    }

    ListView {
      id: list
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      spacing: 4
      model: root.lines
      boundsBehavior: Flickable.StopAtBounds
      onDraggingChanged: if (dragging)
        root.follow = false
      onHeightChanged: Qt.callLater(root.followCurrent)
      header: Item {
        height: Math.max(0, list.height / 2 - 28)
      }
      footer: Item {
        height: Math.max(0, list.height / 2 - 28)
      }
      Controls.ScrollBar.vertical: Controls.ScrollBar {
        policy: Controls.ScrollBar.AsNeeded
      }

      Behavior on contentY {
        enabled: root.follow && !list.dragging && !list.flicking
        NumberAnimation {
          duration: 420
          easing.type: Easing.OutCubic
        }
      }

      delegate: MouseArea {
        id: line
        required property var modelData
        required property int index
        readonly property bool current: root.synced && index === root.controller.currentLyricIndex
        width: list.width
        height: Math.max(46, label.implicitHeight + 20)
        hoverEnabled: true
        cursorShape: root.synced && root.controller.activePlayer?.canSeek ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
          if (root.synced && root.controller.activePlayer?.canSeek) {
            root.controller.activePlayer.position = Math.max(0, modelData.time - root.controller.lyricOffset);
            root.follow = true;
          }
        }
        SkewedSurface {
          anchors.fill: parent
          slantLeft: true
          slantRight: true
          slant: 8
          fillColor: line.current ? Appearance.colors.widgetActive : line.containsMouse ? Appearance.colors.widget : "transparent"
          outlineColor: "transparent"
          shadowColor: "transparent"
          Behavior on fillColor {
            ColorAnimation {
              duration: 180
            }
          }
        }
        StyledText {
          id: label
          anchors.centerIn: parent
          width: parent.width - 30
          text: line.modelData.text || "♪"
          horizontalAlignment: Text.AlignHCenter
          wrapMode: Text.Wrap
          font.pointSize: Appearance.font.size.normal
          font.weight: line.current ? Font.Bold : Font.Normal
          color: line.current ? Appearance.colors.m3tertiary : Appearance.colors.m3onSurfaceVariant
          opacity: !root.synced || line.current ? 1 : 0.5
          Behavior on opacity {
            NumberAnimation {
              duration: 200
            }
          }
        }
        ProgressBar {
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          anchors.leftMargin: 14
          anchors.rightMargin: 14
          visible: line.current
          thickness: 1
          value: root.controller.lyricProgress
        }
      }
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: event => {
          root.follow = false;
          event.accepted = false;
        }
      }
      StyledText {
        anchors.centerIn: parent
        width: parent.width - 24
        visible: list.count === 0
        text: root.controller.lyricStatus
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        color: Appearance.colors.m3onSurfaceVariant
      }
    }

    RowLayout {
      Layout.fillWidth: true
      visible: root.synced
      StyledText {
        text: "Timing"
        font.pointSize: Appearance.font.size.small
        opacity: 0.6
      }
      Item {
        Layout.fillWidth: true
      }
      MediaControlButton {
        buttonSize: 26
        iconSize: 12
        icon: "remove"
        onTriggered: root.controller.lyricOffset = Math.max(-10, root.controller.lyricOffset - 0.25)
      }
      StyledText {
        text: (root.controller.lyricOffset >= 0 ? "+" : "") + root.controller.lyricOffset.toFixed(2) + "s"
        font.pointSize: Appearance.font.size.small
        font.family: Appearance.font.family.mono
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: root.controller.lyricOffset = 0
        }
      }
      MediaControlButton {
        buttonSize: 26
        iconSize: 12
        icon: "add"
        onTriggered: root.controller.lyricOffset = Math.min(10, root.controller.lyricOffset + 0.25)
      }
    }
  }
}
