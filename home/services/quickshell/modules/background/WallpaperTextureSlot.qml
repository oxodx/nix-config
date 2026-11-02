import QtQuick
import qs.services

Image {
  id: root

  anchors.fill: parent
  fillMode: Image.PreserveAspectCrop
  asynchronous: true
  smooth: true
  mipmap: false
  cache: false
  layer.enabled: false
  layer.smooth: true
}
