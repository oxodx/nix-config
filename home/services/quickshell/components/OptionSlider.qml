pragma ComponentBehavior: Bound

import QtQuick

Item {
  id: root

  property list<string> values
  property int index: 0
  signal activated(index: int)

  implicitWidth: 300
  implicitHeight: 40

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    onReleased: root.activated(root.index)

    property real halfHandle: handle.width / 2
    property real activeWidth: groove.width - handle.width
    property real valueOffset: mouseArea.halfHandle + (root.index / (root.values.length - 1)) * mouseArea.activeWidth

    Repeater {
      model: root.values

      Item {
        id: delegate
        required property int index
        required property string modelData

        anchors.top: groove.bottom
        anchors.topMargin: 2
        x: mouseArea.halfHandle + (delegate.index / (root.values.length - 1)) * mouseArea.activeWidth

        Rectangle {
          id: mark
          color: "#60eeffff"
          width: 1
          height: groove.height
        }

        StyledText {
          anchors.top: mark.bottom

          x: delegate.index === 0 ? -4 : delegate.index === root.values.length - 1 ? -this.width + 4 : -(this.width / 2)

          text: delegate.modelData
          color: "#a0eeffff"
        }
      }
    }

    StyledRect {
      id: grooveFill

      anchors {
        left: groove.left
        top: groove.top
        bottom: groove.bottom
      }

      radius: 5
      color: "#80ceffff"
      width: mouseArea.valueOffset
    }

    StyledRect {
      id: groove

      anchors {
        left: parent.left
        right: parent.right
      }

      y: 5
      implicitHeight: 7
      border.color: "#20eeffff"
      border.width: 1
      radius: 5
    }

    StyledRect {
      id: handle
      anchors.verticalCenter: groove.verticalCenter
      height: 15
      width: height
      radius: height * 0.5
      x: mouseArea.valueOffset - width * 0.5
    }
  }

  Binding {
    when: mouseArea.pressed
    root.index: Math.max(0, Math.min(root.values.length - 1, Math.round((mouseArea.mouseX / root.width) * (root.values.length - 1))))
    restoreMode: Binding.RestoreBinding
  }
}
