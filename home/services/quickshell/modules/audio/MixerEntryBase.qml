import qs.components
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.modules.bar

RowLayout {
  id: root

  required property PwNode node
  property string image: ""
  required property Item headerComponent
  property bool peakDetect: true

  property int state: PwLinkState.Unlinked

  function getNodeName(node: PwNode): string {
    const name = node.properties["application.name"] ?? (node.description == "" ? node.name : node.description);
    const mediaName = node.properties["media.name"];

    return mediaName != undefined ? `${name} - ${mediaName}` : name + node.id;
  }

  PwObjectTracker {
    objects: [node]
  }

  PwNodePeakMonitor {
    id: peakMonitor
    node: root.node
    enabled: root.peakDetect
  }

  ClickableIcon {
    image: root.image
    icon: root.node.isStream ? "" : root.node.isSink ? "speaker" : "mic"
    asynchronous: true
    implicitHeight: 40
    implicitWidth: height
  }

  ColumnLayout {
    Item {
      id: container

      Layout.fillWidth: true
      implicitWidth: headerComponent.implicitWidth
      implicitHeight: headerComponent.implicitHeight

      children: [headerComponent]
      Binding {
        root.headerComponent.anchors.fill: container
      }
    }

    VolumeSlider {
      Layout.fillWidth: true

      value: node.audio.volume
      peak: root.peakDetect ? peakMonitor.peak : 1
      onValueChanged: node.audio.volume = value
    }
  }
}
