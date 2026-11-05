import qs.theme
import QtQuick
import QtQuick.Layouts
import qs.components

// A numbered page tile, in the style of SekaiPop's settings: a big muted number, a title, and a
// short line. The selected tile takes the accent.
Rectangle {
  id: root

  property string number: "01"
  property string title: ""
  property string detail: ""
  property bool selected: false
  signal activated()

  Layout.fillWidth: true
  Layout.preferredHeight: 92
  radius: Appearance.rounding.normal
  color: selected ? Appearance.colors.m3primaryContainer
       : tileHover.containsMouse ? Qt.alpha(Appearance.colors.m3primary, 0.14)
       : Appearance.colors.widget
  border.width: 1
  border.color: selected ? Appearance.colors.m3primary
              : tileHover.containsMouse ? Qt.alpha(Appearance.colors.m3primary, 0.6)
              : Appearance.colors.widgetOutlineSeparate
  Behavior on color { ColorAnimation { duration: 150 } }

  StyledText {
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.margins: 12
    text: root.number
    font.pointSize: Appearance.font.size.large
    font.weight: Font.Bold
    color: root.selected ? Appearance.colors.m3onPrimaryContainer : Appearance.colors.m3onSurfaceVariant
    opacity: 0.5
  }

  ColumnLayout {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: 14
    spacing: 2

    StyledText {
      text: root.title
      font.pointSize: Appearance.font.size.large
      font.weight: Font.DemiBold
      color: root.selected ? Appearance.colors.m3onPrimaryContainer : Appearance.colors.m3onSurface
    }
    StyledText {
      text: root.detail
      font.pointSize: Appearance.font.size.smaller
      color: root.selected ? Appearance.colors.m3onPrimaryContainer : Appearance.colors.m3onSurfaceVariant
      elide: Text.ElideRight
      Layout.fillWidth: true
    }
  }

  MouseArea {
    id: tileHover
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.activated()
  }
}
