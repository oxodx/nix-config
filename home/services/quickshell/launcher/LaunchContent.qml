import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import qs
import qs.components

Item {
  id: root
  signal dismissed
  height: 7 + searchContainer.implicitHeight + list.topMargin * 2 + list.delegateHeight * 10
  width: 560

  SkewedSurface {
    id: content
    height: 7 + searchContainer.implicitHeight + list.topMargin + list.bottomMargin + Math.min(list.contentHeight, list.delegateHeight * 10)
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
    fillColor: "#f2171a22"
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
          values: search.text.startsWith(">")
            ? [{ kind: "command", command: search.text.slice(1).trim() }]
            : DesktopEntries.applications.values.map(object => {
            const stxt = search.text.toLowerCase();
            const ntxt = object.name.toLowerCase();
            let si = 0;
            let ni = 0;

            let matches = [];
            let startMatch = -1;

            for (let si = 0; si != stxt.length; ++si) {
              const sc = stxt[si];

              while (true) {
                if (ni == ntxt.length)
                  return null;

                const nc = ntxt[ni++];

                if (nc == sc) {
                  if (startMatch == -1)
                    startMatch = ni;
                  break;
                } else {
                  if (startMatch != -1) {
                    matches.push({
                      index: startMatch,
                      length: ni - startMatch
                    });

                    startMatch = -1;
                  }
                }
              }
            }

            if (startMatch != -1) {
              matches.push({
                index: startMatch,
                length: ni - startMatch + 1
              });
            }

            return {
              object: object,
              matches: matches
            };
          }).filter(entry => entry !== null).sort((a, b) => {
            let ai = 0;
            let bi = 0;
            let s = 0;

            while (ai != a.matches.length && bi != b.matches.length) {
              const am = a.matches[ai];
              const bm = b.matches[bi];

              s = bm.length - am.length;
              if (s != 0)
                return s;

              s = am.index - bm.index;
              if (s != 0)
                return s;

              ++ai;
              ++bi;
            }

            s = a.matches.length - b.matches.length;
            if (s != 0)
              return s;

            s = a.object.name.length - b.object.name.length;
            if (s != 0)
              return s;

            return a.object.name.localeCompare(b.object.name);
          }).map(entry => ({ kind: "app", object: entry.object }))

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
            } else
              entry.execute();
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
