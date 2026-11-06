import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import qs
import qs.services
import qs.modules.common

Rectangle {
    id: root
    property string screenName: "default"
    color: "#170820"
    radius: Config.options.encore.frameRounding
    layer.enabled: true
    layer.effect: OpacityMask { maskSource: Rectangle { width: root.width; height: root.height; radius: root.radius } }
    focus: GlobalStates.encoreEditMode
    Keys.onEscapePressed: GlobalStates.encoreEditMode = false
    readonly property string wallpaper: Config.options.background.wallpaperPath
    readonly property bool video: /\.(mp4|webm|mkv|avi|mov)$/i.test(wallpaper)
    readonly property bool wide: width >= 1100
    readonly property real cardWidth: Math.min(280, width - 176)
    Image { anchors.fill: parent; anchors.margins: 12; source: (root.video ? Config.options.background.thumbnailPath : root.wallpaper) || Quickshell.shellPath("assets/images/default_wallpaper.png"); fillMode: Image.PreserveAspectCrop; asynchronous: true }
    Rectangle { anchors.fill: parent; anchors.margins: 12; color: Qt.rgba(0.18, 0.04, 0.28, Config.options.encore.wallpaperDim) }
    Rectangle { anchors.fill: parent; anchors.margins: 8; radius: Math.max(0, root.radius - 8); color: "transparent"; border.width: 5; border.color: "#a16dbe" }
    Rectangle { anchors.fill: parent; anchors.margins: 17; radius: Math.max(0, root.radius - 17); color: "transparent"; border.width: 2; border.color: "#b8e4b9ee" }
    Repeater {
        model: [[0.32,0.12,"✦",-18],[0.63,0.19,"♡",12],[0.45,0.81,"✧",8],[0.74,0.72,"✦",-13],[0.27,0.64,"♡",14]]
        EncoreText {
            id: sticker
            required property int index
            property real drift: 0
            transform: Translate { y: sticker.drift }
            SequentialAnimation on drift {
                running: Config.options.encore.motion && sticker.visible && !GlobalStates.screenLocked && !GlobalStates.encoreEditMode
                loops: Animation.Infinite
                NumberAnimation { from: -4; to: 4; duration: 2200 + sticker.index * 270; easing.type: Easing.InOutSine }
                NumberAnimation { from: 4; to: -4; duration: 2200 + sticker.index * 270; easing.type: Easing.InOutSine }
            }
            required property var modelData; x: root.width*modelData[0]; y: root.height*modelData[1]; text: modelData[2]; rotation: modelData[3] + drift * 0.6; font.pixelSize: 35; color: "#b8db9ceb"; visible: Config.options.encore.desktopWidgets; style: Text.Outline; styleColor: "#63376c" }
    }
    EncoreWidgetHost {
        widgetId: "weather"; screenName: root.screenName
        initialX: 88; initialY: 65; initialWidth: root.cardWidth; initialHeight: 235; tilt: -1
        EncoreWeather { anchors.fill: parent }
        EncoreTape { x: 20; y: -9 }
    }
    EncoreWidgetHost {
        widgetId: "calendar"; screenName: root.screenName
        initialX: 88; initialY: 320; initialWidth: root.cardWidth; initialHeight: 280; tilt: 0.8; fits: root.height >= 700
        EncoreCalendar { anchors.fill: parent }
    }
    EncoreWidgetHost {
        widgetId: "palette"; screenName: root.screenName
        initialX: 88; initialY: 620; initialWidth: root.cardWidth; initialHeight: 180; tilt: -1; fits: root.height >= 850
        EncorePalette { anchors.fill: parent }
    }
    EncoreWidgetHost {
        widgetId: "profile"; screenName: root.screenName
        initialX: root.width-root.cardWidth-88; initialY: 65; initialWidth: root.cardWidth; initialHeight: 180; tilt: 1; fits: root.wide
        EncoreProfile { anchors.fill: parent }
        EncoreTape { anchors.right: parent.right; anchors.rightMargin: 15; y: -9; rotation: 15 }
    }
    EncoreWidgetHost {
        widgetId: "clock"; screenName: root.screenName
        initialX: root.width-root.cardWidth-88; initialY: 265; initialWidth: root.cardWidth; initialHeight: 184; tilt: -0.6; fits: root.wide
        EncoreClock { anchors.fill: parent }
    }
    EncoreWidgetHost {
        widgetId: "todo"; screenName: root.screenName
        initialX: root.width-root.cardWidth-88; initialY: 470; initialWidth: root.cardWidth; initialHeight: 235; tilt: 0.8; fits: root.wide && root.height >= 700
        EncoreTodo { anchors.fill: parent }
    }
    EncoreWidgetHost {
        widgetId: "media"; screenName: root.screenName
        initialX: root.width-root.cardWidth-88; initialY: 730; initialWidth: root.cardWidth; initialHeight: 144; tilt: 1.3; fits: root.wide && root.height >= 1000
        EncoreMedia { anchors.fill: parent }
    }
    EncoreWidgetHost {
        widgetId: "lyrics"; screenName: root.screenName
        initialX: root.width*0.31; initialY: root.height*0.45; initialWidth: root.width*0.38; initialHeight: 226; tilt: -4; fits: root.wide
        EncoreLyrics { anchors.fill: parent }
    }
    EncoreWidgetHost {
        widgetId: "image"; screenName: root.screenName
        initialX: root.width*0.33; initialY: root.height-235; initialWidth: 170; initialHeight: 184; tilt: -3; fits: root.wide && root.height >= 700
        EncoreImage { anchors.fill: parent }
    }
    EncoreWidgetHost {
        widgetId: "note"; screenName: root.screenName
        initialX: root.width*0.57; initialY: root.height-205; initialWidth: 185; initialHeight: 145; tilt: 5; fits: root.wide && root.height >= 700
        EncoreCard {
            anchors.fill: parent; radius: 10; fill: EncoreStyle.dark ? "#56296a" : "#dbb1ed"
            EncoreTape { anchors.horizontalCenter: parent.horizontalCenter; y: -11; rotation: -10 }
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 15; spacing: 6
                EncoreText { text: "note to self ♡"; font.bold: true; font.pixelSize: 12 }
                TextArea {
                    Layout.fillWidth: true; Layout.fillHeight: true
                    text: Config.options.encore.note
                    onTextChanged: if (text !== Config.options.encore.note) Config.options.encore.note = text
                    wrapMode: TextEdit.Wrap; color: EncoreStyle.text; font.family: EncoreStyle.font; font.pixelSize: 13
                    background: Item {} selectByMouse: true
                }
            }
        }
    }
    EncoreTape { x: 110; y: 24; rotation: -10; width: 85; height: 20 }
    EncoreTape { x: root.width-190; y: 24; rotation: 10; width: 85; height: 20; color: "#bfdca4d6" }
    RowLayout {
        visible: GlobalStates.encoreEditMode
        z: 100
        anchors.horizontalCenter: parent.horizontalCenter; y: 19
        spacing: 10
        EncoreButton { text: "Cards & theme"; symbol: "tune"; onClicked: GlobalStates.encoreCustomizeOpen = true }
        EncoreButton { text: "Reset layout"; symbol: "restart_alt"; onClicked: EncoreDesktopState.resetLayout() }
        EncoreButton { text: "Done"; symbol: "check"; fill: EncoreStyle.pink; onClicked: GlobalStates.encoreEditMode = false }
    }
}
