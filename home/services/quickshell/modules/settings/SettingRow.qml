import qs.theme
import QtQuick
import QtQuick.Layouts
import qs.components

// One line of a settings page: a title and a short description on the left, and the control on
// the right. The control is whatever the row is given as a child.
Rectangle {
  id: root

  property string title: ""
  property string detail: ""
  default property alias control: slot.data

  Layout.fillWidth: true
  implicitHeight: 56
  radius: Appearance.rounding.normal
  color: rowHover.containsMouse ? Qt.alpha(Appearance.colors.m3primary, 0.1) : "transparent"
  border.width: rowHover.containsMouse ? 1 : 0
  border.color: Qt.alpha(Appearance.colors.m3primary, 0.45)
  Behavior on color { ColorAnimation { duration: 140 } }
  Behavior on border.color { ColorAnimation { duration: 140 } }

  MouseArea {
    id: rowHover
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
  }

  ColumnLayout {
    anchors.left: parent.left
    anchors.right: slot.left
    anchors.verticalCenter: parent.verticalCenter
    anchors.leftMargin: 16
    anchors.rightMargin: 16
    spacing: 2

    StyledText {
      text: root.title
      font.weight: Font.DemiBold
      color: Appearance.colors.m3onSurface
    }
    StyledText {
      visible: root.detail !== ""
      text: root.detail
      font.pointSize: Appearance.font.size.smaller
      color: Appearance.colors.m3onSurfaceVariant
      wrapMode: Text.WordWrap
      Layout.fillWidth: true
    }
  }

  Item {
    id: slot
    anchors.right: parent.right
    anchors.rightMargin: 16
    anchors.verticalCenter: parent.verticalCenter
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
  }
}
