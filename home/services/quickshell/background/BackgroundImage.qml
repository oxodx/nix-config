import QtQuick
import Quickshell
import qs.lock as Lock

Item {
  id: root

  required property ShellScreen screen
  property real slideAmount: 1.0 - Lock.Controller.bkgSlide
  property alias asynchronous: image.asynchronous

  readonly property real scaledHeight: image.sourceSize.width > 0
    ? image.sourceSize.height * root.width / image.sourceSize.width
    : root.height
  readonly property real remainingSize: Math.max(0, root.scaledHeight - root.height)

  Image {
    id: image
    width: root.width
    height: Math.max(root.height, root.scaledHeight)
    fillMode: Image.PreserveAspectCrop
    horizontalAlignment: Image.AlignHCenter
    verticalAlignment: Image.AlignVCenter
    source: {
      var s = Quickshell.env("HOME") + "/Pictures/wallpaper";
      return Qt.resolvedUrl(`${s}.png`);
    }
    y: -(root.slideAmount * root.remainingSize)
  }
}
