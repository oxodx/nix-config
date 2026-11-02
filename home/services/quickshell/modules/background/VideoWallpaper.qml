import QtQuick
import QtMultimedia

Item {
  id: root

  property string path: ""
  property string screenName: ""
  property bool paused: false
  property bool restartOnPause: false
  property bool hidden: false

  MediaPlayer {
    id: player
    source: root.path !== "" ? ("file://" + root.path) : ""
    loops: MediaPlayer.Infinite
    videoOutput: out
    Component.onCompleted: if (!root.paused) play()
  }

  onPausedChanged: {
    if (paused) {
      player.pause()
    } else {
      if (root.restartOnPause)
        player.position = 0
      player.play()
    }
  }

  VideoOutput {
    id: out
    anchors.fill: parent
    fillMode: VideoOutput.PreserveAspectCrop
  }
}
