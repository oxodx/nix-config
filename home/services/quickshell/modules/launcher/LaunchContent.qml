import qs.services
import qs.theme
import QtQuick
import "Search.js" as Search
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import qs.components

Item {
  id: root
  signal dismissed
  readonly property int visibleRows: 11
  readonly property real listHeight: Math.min(list.contentHeight, list.delegateHeight * visibleRows)
  height: content.height
  width: 560

  SkewedSurface {
    id: content
    height: 18 + searchContainer.implicitHeight + 8 + list.topMargin + list.bottomMargin + root.listHeight + 14
    Behavior on height {
      NumberAnimation {
        duration: 200
        easing.type: Easing.OutCubic
      }
    }
    width: 560
    slantLeft: true
    slantRight: true
    slant: 24
    fillColor: Appearance.colors.panel
    outlineColor: Appearance.colors.widgetOutlineSeparate
    shadowOffset: 6

    ColumnLayout {
      anchors.fill: parent
      anchors.leftMargin: 30
      anchors.rightMargin: 30
      anchors.topMargin: 18
      anchors.bottomMargin: 14
      spacing: 8

      SkewedSurface {
        id: searchContainer
        Layout.fillWidth: true
        implicitHeight: 52
        slantLeft: true
        slantRight: true
        slant: 12
        fillColor: "#30c0ffff"
        outlineColor: search.activeFocus ? Appearance.colors.m3tertiary : "#50ffffff"
        shadowColor: "transparent"

        RowLayout {
          id: searchbox
          anchors.fill: parent
          anchors.margins: 5

          MaterialIcon {
            text: "search"
            fill: 1
            font.pointSize: Appearance.font.size.extraLarge
            color: Appearance.colors.m3tertiary
          }

          TextInput {
            id: search
            Layout.fillWidth: true
            color: "white"
            font.pointSize: Appearance.font.size.normal
            selectionColor: Appearance.colors.m3primaryContainer
            selectedTextColor: Appearance.colors.m3onPrimaryContainer

            focus: true
            Keys.forwardTo: [list]
            Keys.onEscapePressed: root.dismissed()

            Keys.onPressed: event => {
              if (event.modifiers & Qt.ControlModifier) {
                if (event.key == Qt.Key_J) {
                  list.currentIndex = list.currentIndex == list.count - 1 ? 0 : list.currentIndex + 1;
                  event.accepted = true;
                } else if (event.key == Qt.Key_K) {
                  list.currentIndex = list.currentIndex == 0 ? list.count - 1 : list.currentIndex - 1;
                  event.accepted = true;
                }
              }
            }

            onAccepted: {
              list.currentItem?.launch();
            }

            onTextChanged: {
              list.currentIndex = 0;
            }
          }

          StyledText {
            Layout.fillWidth: true
            visible: search.text === ""
            text: "Search apps  •  > run a command"
            color: Appearance.colors.m3onSurfaceVariant
            font.pointSize: Appearance.font.size.smaller
          }
        }
      }

      ListView {
        id: list
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        cacheBuffer: 0 // works around QTBUG-131106
        //reuseItems: true
        model: ScriptModel {
          values: Search.results(DesktopEntries.applications.values, search.text, LauncherUsage.counts)

          onValuesChanged: list.currentIndex = 0
        }

        topMargin: 2
        bottomMargin: list.count == 0 ? 0 : 2

        add: Transition {
          NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            duration: 100
          }
        }

        displaced: Transition {
          NumberAnimation {
            property: "y"
            duration: 200
            easing.type: Easing.OutCubic
          }
          NumberAnimation {
            property: "opacity"
            to: 1
            duration: 100
          }
        }

        move: Transition {
          NumberAnimation {
            property: "y"
            duration: 200
            easing.type: Easing.OutCubic
          }
          NumberAnimation {
            property: "opacity"
            to: 1
            duration: 100
          }
        }

        remove: Transition {
          NumberAnimation {
            property: "y"
            duration: 200
            easing.type: Easing.OutCubic
          }
          NumberAnimation {
            property: "opacity"
            to: 0
            duration: 100
          }
        }

        highlight: SkewedPanel {
          slantLeft: true
          slantRight: true
          slant: 10
          fillColor: "#28e0ffff"
          outlineColor: Appearance.colors.m3tertiary
        }

        keyNavigationEnabled: true
        keyNavigationWraps: true
        highlightMoveVelocity: -1
        highlightMoveDuration: 100
        preferredHighlightBegin: list.topMargin
        preferredHighlightEnd: list.height - list.bottomMargin
        highlightRangeMode: ListView.ApplyRange
        snapMode: ListView.SnapToItem

        readonly property real delegateHeight: 52

        delegate: MouseArea {
          id: appDelegate
          required property var modelData

          readonly property bool commandMode: modelData.kind === "command"
          readonly property var entry: modelData.object ?? null

          implicitHeight: list.delegateHeight
          implicitWidth: ListView.view.width

          function launch(): void {
            if (commandMode) {
              if (modelData.command === "")
                return;
              Quickshell.execDetached(["sh", "-lc", modelData.command]);
            } else {
              entry.execute();
              LauncherUsage.record(entry);
            }
            root.dismissed();
          }

          onClicked: launch()

          RowLayout {
            id: delegateLayout
            anchors {
              verticalCenter: parent.verticalCenter
              left: parent.left
              leftMargin: 12
            }
            spacing: 12

            IconImage {
              visible: !appDelegate.commandMode
              Layout.alignment: Qt.AlignVCenter
              asynchronous: true
              implicitSize: 34
              source: Quickshell.iconPath(appDelegate.entry?.icon ?? "")
            }

            MaterialIcon {
              visible: appDelegate.commandMode
              Layout.preferredWidth: 34
              text: "terminal"
              fill: 1
              color: Appearance.colors.m3tertiary
              font.pointSize: Appearance.font.size.extraLarge
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 0

              StyledText {
                Layout.fillWidth: true
                text: appDelegate.commandMode ? (modelData.command || "Type a command") : appDelegate.entry?.name ?? ""
                color: "#f0f0f0"
                font.weight: Font.DemiBold
                elide: Text.ElideRight
              }

              StyledText {
                Layout.fillWidth: true
                visible: text !== ""
                text: appDelegate.commandMode ? "Run in your shell" : appDelegate.entry?.comment ?? ""
                color: Appearance.colors.m3onSurfaceVariant
                font.pointSize: Appearance.font.size.smaller
                elide: Text.ElideRight
              }
            }

            MaterialIcon {
              Layout.rightMargin: 12
              text: "keyboard_return"
              color: Appearance.colors.m3onSurfaceVariant
            }
          }
        }
      }
    }
  }
}
