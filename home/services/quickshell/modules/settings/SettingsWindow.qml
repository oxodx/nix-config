import qs.theme
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.components

// The settings window: a dimmed overlay on the focused monitor, with a card of three numbered
// tiles (Look, Bar, About) and the settings for each. Escape or a click outside closes it.
PanelWindow {
  id: root

  required property ShellScreen screen

  readonly property var focusedMonitor: Hyprland.focusedMonitor
  readonly property bool focusedScreen: focusedMonitor === null || screen.name === focusedMonitor.name

  property int page: 0

  visible: ShellIpc.settingsOpen && focusedScreen
  color: Qt.alpha(Appearance.colors.m3shadow, 0.45)
  exclusionMode: ExclusionMode.Ignore

  anchors.top: true
  anchors.bottom: true
  anchors.left: true
  anchors.right: true

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "shell:settings"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  // Clicking the dim backdrop closes the window.
  MouseArea {
    anchors.fill: parent
    onClicked: ShellIpc.settingsOpen = false
  }

  Rectangle {
    id: card
    anchors.centerIn: parent
    width: Math.min(root.width - 48, 760)
    height: Math.min(root.height - 48, 540)
    radius: Appearance.rounding.large
    color: Appearance.colors.panel
    border.width: 1
    border.color: Appearance.colors.widgetOutlineSeparate
    focus: root.visible

    // Clicks on the card do not reach the backdrop.
    MouseArea { anchors.fill: parent }

    Keys.onEscapePressed: ShellIpc.settingsOpen = false

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: 20
      spacing: 16

      RowLayout {
        Layout.fillWidth: true

        StyledText {
          Layout.fillWidth: true
          text: "Settings"
          font.pointSize: Appearance.font.size.large
          font.weight: Font.Bold
          color: Appearance.colors.m3onSurface
        }

        Rectangle {
          Layout.preferredWidth: 30
          Layout.preferredHeight: 30
          radius: Appearance.rounding.small
          color: closeHover.containsMouse ? Qt.alpha(Appearance.colors.m3primary, 0.2) : "transparent"
          StyledText {
            anchors.centerIn: parent
            text: "×"
            font.pointSize: Appearance.font.size.large
            color: Appearance.colors.m3onSurface
          }
          MouseArea {
            id: closeHover
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: ShellIpc.settingsOpen = false
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: 10

        SettingTile {
          number: "01"
          title: "Look"
          detail: "Theme, shapes and corners"
          selected: root.page === 0
          onActivated: root.page = 0
        }
        SettingTile {
          number: "02"
          title: "Bar"
          detail: "Height and what it shows"
          selected: root.page === 1
          onActivated: root.page = 1
        }
        SettingTile {
          number: "03"
          title: "About"
          detail: "Shortcuts and commands"
          selected: root.page === 2
          onActivated: root.page = 2
        }
      }

      // Look
      ColumnLayout {
        visible: root.page === 0
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 4

        SettingRow {
          title: "Theme"
          detail: "The colour palette for the whole shell."
          SegmentSwitch {
            width: 360
            height: 30
            options: ThemePresets.names.map(n => ({ id: n, label: ThemePresets.title(n) }))
            current: SettingsService.get("theme.preset") ?? "blend"
            onPicked: id => SettingsService.set("theme.preset", id)
          }
        }
        SettingRow {
          title: "Slanted shapes"
          detail: "The skewed SKWD look on panels and bar."
          SettingToggle { settingKey: "ui.slant" }
        }
        SettingRow {
          title: "Button shadow"
          detail: "A hard shadow under buttons that sinks when pressed."
          SettingToggle { settingKey: "ui.buttonShadow" }
        }
        SettingRow {
          title: "Corner radius"
          detail: "How rounded the cards and buttons are."
          SegmentSwitch {
            width: 240
            height: 30
            options: [
              { id: "0.5", label: "0.5×" },
              { id: "1", label: "1×" },
              { id: "1.5", label: "1.5×" },
              { id: "2", label: "2×" }
            ]
            current: String(SettingsService.get("ui.radiusScale"))
            onPicked: id => SettingsService.set("ui.radiusScale", Number(id))
          }
        }
      }

      // Bar
      ColumnLayout {
        visible: root.page === 1
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 4

        SettingRow {
          title: "Bar height"
          detail: "Pixels, from 32 to 56."
          SettingStepper { settingKey: "bar.height"; min: 32; max: 56; step: 2 }
        }
        SettingRow {
          title: "Workspaces"
          SettingToggle { settingKey: "bar.showWorkspaces" }
        }
        SettingRow {
          title: "Media"
          detail: "The lyrics strip in the centre."
          SettingToggle { settingKey: "bar.showMedia" }
        }
        SettingRow {
          title: "Clock"
          SettingToggle { settingKey: "bar.showClock" }
        }
        SettingRow {
          title: "Tray"
          SettingToggle { settingKey: "bar.showTray" }
        }
      }

      // About
      ColumnLayout {
        visible: root.page === 2
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 4

        SettingRow {
          title: "Open this window"
          detail: "qs ipc call settings open"
        }
        SettingRow {
          title: "Cycle the theme"
          detail: "qs ipc call theme cycle"
        }
        SettingRow {
          title: "Toggle a setting"
          detail: "qs ipc call settings toggle ui.slant"
        }
        SettingRow {
          title: "Set a value"
          detail: "qs ipc call settings set bar.height 44"
        }
        Item { Layout.fillHeight: true }
      }
    }
  }
}
