import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.components
import qs.utils

LazyLoader {
  active: Config.wallpaperPath !== ""

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: wallpaperWindow

      required property var modelData

      screen: modelData

      WlrLayershell.layer: WlrLayer.Background
      WlrLayershell.exclusionMode: ExclusionMode.Ignore

      anchors.top: true
      anchors.bottom: true
      anchors.left: true
      anchors.right: true

      color: "black"

      Item {
        id: root
        anchors.fill: parent

        property string source: Config.wallpaperPath || ""
        property Image current: one

        onSourceChanged: {
          if (!source)
            current = null;
          else if (current === one)
            two.update();
          else
            one.update();
        }

        Loader {
          anchors.fill: parent
          active: !root.source
          asynchronous: true

          sourceComponent: Rectangle {
            color: Theme.surface

            Row {
              anchors.centerIn: parent
              spacing: Theme.spacingL

              MaterialIcon {
                text: "sentiment_stressed"
                color: Theme.surfaceVariantText
                anchors.verticalCenter: parent.verticalCenter
              }

              Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.spacingS

                Text {
                  text: "Wallpaper missing?"
                  color: Theme.surfaceVariantText
                  font.pixelSize: Theme.fontSizeXLarge * 2
                  font.weight: Font.Bold
                }

                Text {
                  text: "Set wallpaper in Settings"
                  color: Theme.primary
                  font.pixelSize: Theme.fontSizeLarge
                }
              }
            }
          }
        }

        Img {
          id: one
        }

        Img {
          id: two
        }
      }
    }
  }

  component Img: Image {
    id: img

    function update(): void {
      source = "";
      source = root.source;
    }

    anchors.fill: parent
    fillMode: Image.PreserveAspectCrop
    smooth: true
    asynchronous: true
    cache: true

    opacity: 0

    onStatusChanged: {
      if (status === Image.Ready)
        root.current = this;
    }

    states: State {
      name: "visible"
      when: root.current === img

      PropertyChanges {
        img.opacity: 1
      }
    }

    transitions: Transition {
      NumberAnimation {
        target: img
        properties: "opacity"
        duration: Theme.mediumDuration
        easing.type: Easing.OutCubic
      }
    }
  }
}
