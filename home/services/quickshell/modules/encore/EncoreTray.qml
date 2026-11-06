import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

RowLayout {
    spacing: 7
    Repeater {
        model: SystemTray.items
        EncoreButton {
            id: button
            required property SystemTrayItem modelData
            implicitWidth: 34
            implicitHeight: 34
            padding: 7
            hint: modelData.tooltipTitle || modelData.title || modelData.id
            onClicked: modelData.activate()
            contentItem: Image {
                source: button.modelData.icon
                sourceSize.width: 20
                sourceSize.height: 20
                fillMode: Image.PreserveAspectFit
            }
            TapHandler {
                acceptedButtons: Qt.RightButton
                onTapped: if (button.modelData.hasMenu)
                              menu.open()
            }
            QsMenuAnchor {
                id: menu
                menu: button.modelData.menu
                anchor {
                    item: button
                    gravity: Edges.Bottom
                    edges: Edges.Bottom
                    adjustment: PopupAdjustment.ResizeY | PopupAdjustment.SlideX
                }
            }
        }
    }
}
