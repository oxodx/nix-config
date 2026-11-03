import QtQuick
import qs.theme

MixerEntryBase {
  id: root

  headerComponent: Text {
    color: Appearance.colors.m3onSurface
    elide: Text.ElideRight
    text: root.getNodeName(root.node)
  }
}
