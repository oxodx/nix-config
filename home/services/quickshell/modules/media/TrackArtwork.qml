import qs.services
import qs.components

SkewedImage {
  source: MprisService.activeTrack?.artUrl || "image://icon/audio-x-generic-symbolic"
  asynchronous: true
  cache: false
}
