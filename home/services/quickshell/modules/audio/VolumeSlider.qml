import QtQuick
import qs.components
import QtQuick.Shapes

Item {
  id: root
  property real from: 0.0
  property real to: 1.5
  property real warning: 1.0
  property real value: 0.0
  property real peak: 1.0

  implicitWidth: groove.implicitWidth
  implicitHeight: 20

  property real __valueOffset: ((value - from) / (to - from)) * groove.width
  property real __peakOffset: peak * __valueOffset
  property real __wheelValue: -1

  MouseArea {
    id: mouseArea
    anchors.fill: parent

    SliderGroove {
      id: groove
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      height: implicitHeight
      fillWidth: root.__valueOffset
      fillColor: "#40ceffff"
      peakWidth: root.__peakOffset
      peakColor: "#60ceffff"
      warningStart: ((root.warning - root.from) / (root.to - root.from)) * width
      outlineColor: "#20050505"
      cornerRadius: 5
    }

    Rectangle {
      id: handle
      anchors.verticalCenter: groove.verticalCenter
      height: 15
      width: height
      radius: height * 0.5
      x: __valueOffset - width * 0.5
    }

    onWheel: event => {
      event.accepted = true;
      __wheelValue = value + (event.angleDelta.y / 120) * 0.05;
      __wheelValue = -1;
    }
  }

  Binding {
    when: mouseArea.pressed
    target: root
    property: "value"
    value: (mouseArea.mouseX / width) * (to - from) + from
    restoreMode: Binding.RestoreBinding
  }

  Binding {
    when: __wheelValue != -1
    target: root
    property: "value"
    value: __wheelValue
    restoreMode: Binding.RestoreBinding
  }
}
