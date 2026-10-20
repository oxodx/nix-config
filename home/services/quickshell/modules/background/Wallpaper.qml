import qs.theme
import qs.services
import QtQuick
import Quickshell

Item {
  id: root

  property url source: WallpaperService.source
  readonly property alias status: image.status

  anchors.fill: parent

  Rectangle {
    anchors.fill: parent
    color: Appearance.colors.m3background

    Text {
      anchors.centerIn: parent
      visible: image.status === Image.Error
      text: "Unable to load wallpaper"
      color: Appearance.colors.m3onSurfaceVariant
      font.pointSize: 14
    }
  }

  Image {
    id: image

    anchors.fill: parent
    source: root.source
    asynchronous: true
    retainWhileLoading: true
    fillMode: Image.PreserveAspectCrop
    horizontalAlignment: Image.AlignHCenter
    verticalAlignment: Image.AlignVCenter
  }
}
