import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.models
import qs.modules.common.widgets

EncorePopup {
    id: root
    opened: GlobalStates.searchOpen && !GlobalStates.screenLocked
    cardWidth: 450
    cardHeight: 710
    onDismissed: GlobalStates.searchOpen = false
    onOpenedChanged: {
        if (opened) {
            LauncherSearch.query = "";
            search.clear();
            search.forceActiveFocus();
        }
    }
    Connections {
        target: LauncherSearch
        function onQueryChanged() {
            if (root.opened && search.text !== LauncherSearch.query)
                search.text = LauncherSearch.query;
        }
    }
    function runCurrent() {
        const entry = results.model[results.currentIndex];
        if (!entry)
            return;
        GlobalStates.searchOpen = false;
        entry.execute();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                EncoreText {
                    text: "YOUR NEXT THING"
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 2
                    color: EncoreStyle.muted
                }
                EncoreText {
                    text: "Let's go."
                    font.pixelSize: 32
                    font.bold: true
                }
            }
            Item {
                Layout.fillWidth: true
            }
            EncoreButton {
                symbol: "close"
                hint: "Close launcher"
                fill: EncoreStyle.pink
                onClicked: GlobalStates.searchOpen = false
            }
        }
        EncoreCard {
            Layout.fillWidth: true
            implicitHeight: 52
            fill: EncoreStyle.surface
            radius: 15
            TextField {
                id: search
                anchors.fill: parent
                anchors.margins: 6
                placeholderText: "Find an app, a thought, a calculation…"
                color: EncoreStyle.text
                placeholderTextColor: EncoreStyle.muted
                selectionColor: EncoreStyle.lavender
                selectedTextColor: EncoreStyle.ink
                font.family: EncoreStyle.font
                font.pixelSize: 14
                background: Item {}
                onTextChanged: {
                    LauncherSearch.query = text;
                    results.currentIndex = 0;
                }
                onAccepted: root.runCurrent()
                Keys.onDownPressed: results.currentIndex = Math.min(results.count - 1, results.currentIndex
                                                                    + 1)
                Keys.onUpPressed: results.currentIndex = Math.max(0, results.currentIndex - 1)
                Keys.onEscapePressed: GlobalStates.searchOpen = false
            }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            EncoreButton {
                text: "Apps"
                implicitHeight: 32
                fill: EncoreStyle.lavender
                onClicked: {
                    search.text = Config.options.search.prefix.app;
                    search.forceActiveFocus();
                }
            }
            EncoreButton {
                text: "Clipboard"
                implicitHeight: 32
                onClicked: {
                    Cliphist.refresh();
                    search.text = Config.options.search.prefix.clipboard;
                    search.forceActiveFocus();
                }
            }
            EncoreButton {
                text: "Emoji"
                implicitHeight: 32
                fill: EncoreStyle.yellow
                onClicked: {
                    search.text = Config.options.search.prefix.emojis;
                    search.forceActiveFocus();
                }
            }
        }
        EncoreText {
            text: search.text.length ? results.count + " RESULTS" : "PICK SOMETHING GOOD"
            color: EncoreStyle.muted
            font.pixelSize: 10
            font.bold: true
            font.letterSpacing: 2
        }
        ListView {
            id: results
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 8
            model: search.text.length ? LauncherSearch.results : AppSearch.list.slice(0).sort((a, b) => a.name.localeCompare(
                                                                                                            b.name)).slice(
                                            0, 40)
            currentIndex: 0
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar {}
            onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)
            delegate: EncoreButton {
                id: result
                required property var modelData
                required property int index
                width: ListView.view.width - 6
                implicitHeight: 60
                selected: results.currentIndex === index
                fill: EncoreStyle.cream
                onClicked: {
                    results.currentIndex = index;
                    root.runCurrent();
                }
                contentItem: RowLayout {
                    spacing: 12
                    Image {
                        Layout.preferredWidth: 32
                        Layout.preferredHeight: 32
                        visible: source.toString() !== ""
                        source: result.modelData.icon ? Quickshell.iconPath(result.modelData.icon,
                                                                            "application-x-executable") : (
                                                            result.modelData.iconType
                                                            === LauncherSearchResult.IconType.System
                                                            ? Quickshell.iconPath(result.modelData.iconName,
                                                                                  "application-x-executable") :
                                                              "")
                        asynchronous: true
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        EncoreText {
                            Layout.fillWidth: true
                            text: result.modelData.blurImage ? "Hidden clipboard image" :
                                                               result.modelData.name
                            font.bold: true
                            color: EncoreStyle.ink
                        }
                        EncoreText {
                            Layout.fillWidth: true
                            text: result.modelData.genericName || result.modelData.type || "Application"
                            font.pixelSize: 11
                            color: "#756080"
                        }
                    }
                    EncoreText {
                        text: "↵"
                        color: EncoreStyle.ink
                        font.pixelSize: 20
                    }
                }
            }
            EncoreText {
                anchors.centerIn: parent
                visible: results.count === 0
                text: "No matches. Try another search."
                color: EncoreStyle.muted
            }
        }
        EncoreText {
            text: "↑ ↓  TO EXPLORE     ENTER  TO OPEN     ESC  TO LEAVE"
            font.pixelSize: 9
            font.bold: true
            font.letterSpacing: 0.5
            color: EncoreStyle.muted
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
