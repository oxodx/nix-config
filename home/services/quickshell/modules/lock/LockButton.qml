import qs.theme
import QtQuick
import qs.components

Item {
  id: root
  implicitHeight: 75
  implicitWidth: showProgress * 0.1

  signal clicked
  property string icon
  property bool show: true

  property int showProgress: show ? 1000 : 0
  Behavior on showProgress {
    NumberAnimation {
      duration: 100
      easing.type: Easing.OutQuad
    }
  }

  MouseArea {
    id: mouseArea
    implicitWidth: 75
    implicitHeight: 75
    hoverEnabled: true

    y: -(height + 30) * (1.0 - showProgress * 0.001)
    x: 12.5 - 50 * (1.0 - showProgress * 0.001)

    Component.onCompleted: clicked.connect(root.clicked)

    SkewedSurface {
      anchors.fill: parent
      slantLeft: true
      slantRight: true
      slant: 12
      fillColor: Appearance.interpolateColors(hoverColorInterp * 0.001, Appearance.colors.widget, Appearance.colors.widgetActive)
      outlineColor: Appearance.colors.widgetOutline
      shadowOffset: 4

      property int hoverColorInterp: mouseArea.containsMouse || mouseArea.pressed ? 1000 : 0
      Behavior on hoverColorInterp {
        SmoothedAnimation {
          velocity: 10000
        }
      }

      Image {
        anchors.fill: parent
        anchors.margins: 15

        source: root.icon
        sourceSize.width: width
        sourceSize.height: height
      }
    }
  }
}
