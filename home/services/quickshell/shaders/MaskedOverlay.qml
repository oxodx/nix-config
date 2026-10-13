import QtQuick

ShaderEffect {
  property var overlayItem
  property size overlaySize
  property point overlayPos

  fragmentShader: Qt.resolvedUrl("masked_overlay.frag.qsb")

  property point pOverlayPos: Qt.point(overlayPos.x / width, overlayPos.y / height)

  property point pOverlaySize: Qt.point(overlaySize.width / width, overlaySize.height / height)

  property point pMergeInset: Qt.point(3 / width, 3 / height)

  property real pMergeCutoff: 0.15
}
