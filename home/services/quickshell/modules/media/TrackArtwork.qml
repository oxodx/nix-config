import qs.components

SkewedImage {
  source: MprisController.activeTrack?.artUrl || "image://icon/audio-x-generic-symbolic"
  asynchronous: true
  cache: false
}
