import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs
import qs.bar

ColumnLayout {
  id: root

  required property PwNode trackedNode
  required property string nodeImage
  required property list<PwNode> nodeList

  signal selected(node: PwNode)

  PwNodeLinkTracker {
    id: linkTracker
    node: trackedNode
  }

  PwObjectTracker {
    objects: [trackedNode, ...linkTracker.linkGroups]
  }

  MixerEntry {
    id: nodeEntry
    node: trackedNode
    image: nodeImage
  }

  Rectangle {
    Layout.fillWidth: true
    implicitHeight: 1
    visible: linkTracker.linkGroups.length > 0

    color: Appearance.colors.separator
  }

  Repeater {
    model: linkTracker.linkGroups

    MixerEntry {
      required property PwLinkGroup modelData
      node: trackedNode.isSink ? modelData.source : modelData.target
      state: modelData.state
      peakDetect: trackedNode.isSink

      image: {
        let icon = "audio-x-generic-symbolic";
        let props = node.properties;
        if (props["application.icon-name"])
          icon = props["application.icon-name"];
        else if (props["application.process.binary"])
          icon = props["application.process.binary"];

        return Quickshell.iconPath(icon);
      }
    }
  }
}
