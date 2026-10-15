import qs.theme
import QtQuick
import qs.components
import QtQuick.Templates as T

T.Slider {
  id: control

  implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitHandleWidth + leftPadding + rightPadding)
  implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitHandleHeight + topPadding + bottomPadding)

  property color barColor: Appearance.colors.sliderFill
  property color grooveColor: "#30ceffff"

  background: SliderGroove {
    x: control.leftPadding
    y: control.topPadding + control.availableHeight / 2 - height / 2
    width: control.availableWidth
    height: implicitHeight
    trackColor: control.grooveColor
    fillColor: control.barColor
    fillWidth: control.handle.x + control.handle.width / 2 - x
  }

  handle: Rectangle {
    x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
    y: control.topPadding + control.availableHeight / 2 - height / 2
    implicitWidth: 16
    implicitHeight: 16
    radius: 0
    rotation: 45
  }
}
