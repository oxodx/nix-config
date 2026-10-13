import QtQuick
import QtQuick.Layouts
import qs.bar

BarWidgetInner {
  id: root
  required property var bar
  implicitWidth: row.implicitWidth + 10

  RowLayout {
    id: row

    anchors {
      fill: parent
      margins: 5
    }

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
