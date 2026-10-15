import QtQuick
import QtQuick.Layouts
import qs.bar

BarWidgetInner {
  id: root
  required property var bar
  implicitWidth: row.implicitWidth

  RowLayout {
    id: row

    anchors {
      fill: parent
      topMargin: 5
      bottomMargin: 5
    }
    spacing: 8

    Network {
      Layout.fillHeight: true
      Layout.preferredWidth: height
      bar: root.bar
    }

    Bluetooth {
      Layout.fillHeight: true
      Layout.preferredWidth: height
      bar: root.bar
    }
  }
}
