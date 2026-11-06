import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs
import qs.modules.common
import qs.services

// Family-independent actions used by Hyprland. Family-specific surfaces retain
// their existing shortcut names, so switching families needs no compositor edits.
Scope {
    id: root

    function controls() {
        Hyprland.dispatch("global quickshell:" + (Config.options.panelFamily === "waffle" ? "sidebarLeftToggle" : "sidebarRightToggle"))
    }
    function overview() {
        Hyprland.dispatch("global quickshell:overviewWorkspacesToggle")
    }
    function settings() {
        GlobalStates.searchOpen = false
        GlobalStates.overviewOpen = false
        GlobalStates.sidebarLeftOpen = false
        GlobalStates.sidebarRightOpen = false
        Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("settings.qml")])
    }
    function theme() {
        if (Config.options.panelFamily === "encore") Config.options.encore.darkMode = !Config.options.encore.darkMode
        else MaterialThemeLoader.toggleLightDark()
    }

    GlobalShortcut { name: "shellDetachSidebar"; description: "Detach assistant or open action center"; onPressed: Hyprland.dispatch("global quickshell:" + (Config.options.panelFamily === "waffle" ? "sidebarLeftToggle" : "sidebarLeftToggleDetach")) }
    GlobalShortcut { name: "shellEditDesktop"; description: "Edit Encore desktop or show overlay"; onPressed: { if (Config.options.panelFamily === "encore") GlobalStates.encoreEditMode = !GlobalStates.encoreEditMode; else GlobalStates.overlayOpen = !GlobalStates.overlayOpen } }
    GlobalShortcut { name: "shellCustomize"; description: "Customize active shell"; onPressed: { if (Config.options.panelFamily === "encore") GlobalStates.encoreCustomizeOpen = !GlobalStates.encoreCustomizeOpen; else root.settings() } }
    GlobalShortcut { name: "shellControls"; description: "Open active family's controls"; onPressed: root.controls() }
    GlobalShortcut { name: "shellOverview"; description: "Open workspace overview"; onPressed: root.overview() }
    GlobalShortcut { name: "shellSettings"; description: "Open shell settings"; onPressed: root.settings() }
    GlobalShortcut { name: "shellTheme"; description: "Toggle active family's light/dark palette"; onPressed: root.theme() }
    GlobalShortcut { name: "shellReload"; description: "Reload shell"; onPressed: Quickshell.reload(true) }

    IpcHandler {
        target: "shell"
        function ping(): string { return "ok" }
        function controls(): void { root.controls() }
        function overview(): void { root.overview() }
        function settings(): void { root.settings() }
        function theme(): void { root.theme() }
        function reload(): void { Quickshell.reload(true) }
        function volumeUp(): void { if (Audio.ready && Audio.sink?.audio) Audio.incrementVolume() }
        function volumeDown(): void {
            if (Audio.ready && Audio.sink?.audio) Audio.sink.audio.volume = Math.max(0, Audio.value - (Audio.value < 0.1 ? 0.01 : 0.02))
        }
        function mute(): void { if (Audio.ready && Audio.sink?.audio) Audio.toggleMute() }
        function micMute(): void { if (Audio.source?.ready && Audio.source?.audio) Audio.toggleMicMute() }
    }
}
