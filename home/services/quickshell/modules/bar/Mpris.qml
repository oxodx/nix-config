import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.utils
import qs.components

WrapperMouseArea {
  id: root

  Layout.fillHeight: true

  acceptedButtons: Qt.RightButton | Qt.LeftButton

  onClicked: event => {
    event.accepted = true;

    MprisState.player.togglePlaying();
  }

  RowLayout {
    visible: MprisState.player
    Layout.fillHeight: true

    ClippingWrapperRectangle {
      radius: height / 2
      margin: Config.padding * 3

      Image {
        id: artwork
        anchors.fill: parent
        source: MprisState.player?.trackArtUrl || ""
        sourceSize: Qt.size(width, height)
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        smooth: true
      }
    }

    Text {
      id: title
      text: MprisState.player?.trackTitle || ""
    }
  }
}
