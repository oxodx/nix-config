pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import qs.components
import qs.services
import qs.theme

SkewedSurface {
  id: root
  signal dismissed
  property url selectedFile: WallpaperService.source
  property bool applyWhenReady: false
  readonly property bool applied: String(selectedFile) === String(WallpaperService.source)
  Connections {
    target: WallpaperService
    function onSourceChanged(): void { root.selectedFile = WallpaperService.source; }
  }

  slantLeft: true
  slantRight: true
  slant: 24
  fillColor: Appearance.colors.panel
  outlineColor: Appearance.colors.widgetOutlineSeparate
  shadowOffset: 6

  function applySelection(): void {
    if (preview.status === Image.Ready) WallpaperService.apply(selectedFile);
  }

  Keys.onEscapePressed: dismissed()
  Component.onCompleted: grid.forceActiveFocus()

  Image {
    id: preview
    visible: false
    source: root.selectedFile
    asynchronous: true
    sourceSize: Qt.size(512, 288)
    onStatusChanged: {
      if (status === Image.Ready && root.applyWhenReady) {
        root.applyWhenReady = false;
        root.applySelection();
      } else if (status === Image.Error) root.applyWhenReady = false;
    }
  }

  FolderListModel {
    id: files
    folder: WallpaperService.directory
    nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.avif", "*.bmp", "*.gif"]
    caseSensitive: false
    showDirsFirst: true
    showDotAndDotDot: false
    showOnlyReadable: true
    sortCaseSensitive: false
    onFolderChanged: { grid.currentIndex = 0; grid.positionViewAtBeginning(); }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.leftMargin: 30
    anchors.rightMargin: 30
    anchors.topMargin: 22
    anchors.bottomMargin: 22
    spacing: 14

    RowLayout {
      Layout.fillWidth: true
      Layout.minimumWidth: parent.width
      MaterialIcon {
        text: "wallpaper"
        color: Appearance.colors.m3tertiary
        font.pointSize: Appearance.font.size.extraLarge
      }
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        StyledText {
          text: "Wallpaper"
          font.pointSize: Appearance.font.size.large
          font.weight: Font.Bold
        }
        StyledText {
          text: "Make your desktop yours · applies to all screens"
          color: Appearance.colors.m3onSurfaceVariant
          font.pointSize: Appearance.font.size.smaller
        }
      }
      ActionButton {
        implicitWidth: 100
        implicitHeight: 50
        icon: WallpaperService.downloading ? "close" : "shuffle"
        label: WallpaperService.downloading ? "Cancel" : "Random"
        Accessible.name: WallpaperService.downloading ? "Cancel wallpaper download" : "Random safe wallpaper from Konachan"
        onTriggered: WallpaperService.downloading ? WallpaperService.cancelDownload() : WallpaperService.fetchRandom()
      }
      ActionButton {
        icon: "close"
        Accessible.name: "Close wallpaper picker"
        onTriggered: root.dismissed()
      }
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: 8
      ActionButton {
        icon: "arrow_upward"
        Accessible.name: "Parent folder"
        enabled: String(files.parentFolder) !== String(files.folder)
        onTriggered: WallpaperService.directory = files.parentFolder
      }
      ActionButton {
        icon: "home"
        Accessible.name: "Home folder"
        onTriggered: WallpaperService.directory = "file://" + Quickshell.env("HOME")
      }
      ActionButton {
        icon: "photo_library"
        Accessible.name: "Pictures folder"
        onTriggered: WallpaperService.directory = WallpaperService.pictures
      }
      StyledText {
        Layout.fillWidth: true
        Layout.leftMargin: 6
        text: decodeURIComponent(String(WallpaperService.directory).replace(/^file:\/\//, ""))
        elide: Text.ElideMiddle
        color: Appearance.colors.m3onSurfaceVariant
        font.pointSize: Appearance.font.size.smaller
      }
    }

    GridView {
      id: grid
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      cellWidth: width / Math.max(1, Math.floor(width / 190))
      cellHeight: 152
      model: files
      boundsBehavior: Flickable.StopAtBounds
      keyNavigationEnabled: true
      ScrollIndicator.vertical: ScrollIndicator {}
      Keys.onReturnPressed: currentItem?.activate(true)
      Keys.onEnterPressed: currentItem?.activate(true)
      Keys.onSpacePressed: currentItem?.activate(false)

      delegate: Item {
        id: tile
        required property url fileUrl
        required property string fileName
        required property bool fileIsDir
        required property int index
        width: grid.cellWidth
        height: grid.cellHeight
        readonly property bool selected: String(root.selectedFile) === String(fileUrl)

        function activate(apply: bool): void {
          if (fileIsDir) WallpaperService.directory = fileUrl;
          else {
            if (String(root.selectedFile) === String(fileUrl)) {
              if (apply) root.applySelection();
            } else {
              root.applyWhenReady = apply;
              root.selectedFile = fileUrl;
            }
          }
        }

        SkewedSurface {
          anchors.fill: parent
          anchors.margins: 5
          slantLeft: true
          slantRight: true
          slant: 12
          fillColor: mouse.containsMouse ? Appearance.colors.widgetActive : Appearance.colors.widget
          outlineColor: tile.selected ? Appearance.colors.m3tertiary : tile.GridView.isCurrentItem && grid.activeFocus ? Appearance.colors.m3primary : Appearance.colors.widgetOutline
          shadowColor: "transparent"

          SkewedImage {
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: 5 }
            height: 100
            slant: 10
            visible: !tile.fileIsDir
            asynchronous: true
            source: tile.fileIsDir ? "" : tile.fileUrl
          }
          MaterialIcon {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 25
            visible: tile.fileIsDir
            text: "folder"
            fill: 1
            font.pointSize: 38
            color: Appearance.colors.m3primary
          }
          StyledText {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 12 }
            text: tile.fileName
            elide: Text.ElideRight
            font.pointSize: Appearance.font.size.smaller
            color: tile.selected ? Appearance.colors.m3tertiary : Appearance.colors.m3onSurface
          }
          MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: { grid.currentIndex = tile.index; grid.forceActiveFocus(); tile.activate(false); }
            onDoubleClicked: if (!tile.fileIsDir) root.applySelection()
          }
        }
      }

      Column {
        anchors.centerIn: parent
        visible: files.count === 0 && files.status !== FolderListModel.Loading
        spacing: 8
        MaterialIcon {
          anchors.horizontalCenter: parent.horizontalCenter
          text: "photo_library"
          color: Appearance.colors.m3tertiary
          font.pointSize: 36
        }
        StyledText { text: "No images here"; anchors.horizontalCenter: parent.horizontalCenter }
        StyledText {
          text: "Add images to this folder, or browse another one."
          color: Appearance.colors.m3onSurfaceVariant
          font.pointSize: Appearance.font.size.smaller
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        StyledText {
          Layout.fillWidth: true
          text: decodeURIComponent(String(root.selectedFile).split("/").pop())
          elide: Text.ElideRight
          font.weight: Font.DemiBold
        }
        StyledText {
          Layout.fillWidth: true
          elide: Text.ElideRight
          text: WallpaperService.error || (WallpaperService.downloading ? "Finding a safe landscape wallpaper on Konachan…" : preview.status === Image.Error ? "Could not load this image" : root.applied ? "Current wallpaper · saved across restarts" : "Ready to apply · double-click or press Enter")
          color: WallpaperService.error || preview.status === Image.Error ? Appearance.colors.alert : Appearance.colors.m3onSurfaceVariant
          font.pointSize: Appearance.font.size.smaller
        }
      }
      ActionButton {
        implicitWidth: 150
        implicitHeight: 50
        icon: root.applied ? "check" : "wallpaper"
        label: root.applied ? "Applied" : "Apply wallpaper"
        active: root.applied
        enabled: preview.status === Image.Ready && !root.applied
        onTriggered: root.applySelection()
      }
    }
  }
}
