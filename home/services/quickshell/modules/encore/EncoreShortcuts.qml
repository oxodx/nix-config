import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs
import qs.services
import qs.modules.common

Scope {
    id: root
    function search() {
        GlobalStates.sidebarRightOpen = false;
        GlobalStates.searchOpen = !GlobalStates.searchOpen;
    }
    function controls() {
        GlobalStates.searchOpen = false;
        GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen;
    }
    function prefix(value) {
        GlobalStates.sidebarRightOpen = false;
        GlobalStates.searchOpen = true;
        LauncherSearch.query = value;
    }
    Connections {
        target: GlobalStates
        function onScreenLockedChanged() {
            if (GlobalStates.screenLocked) {
                GlobalStates.searchOpen = false;
                GlobalStates.sidebarRightOpen = false;
            }
        }
    }
    IpcHandler {
        target: "search"
        function toggle(): void {
            root.search();
        }
        function open(): void {
            GlobalStates.sidebarRightOpen = false;
            GlobalStates.searchOpen = true;
        }
        function close(): void {
            GlobalStates.searchOpen = false;
        }
        function clipboardToggle(): void {
            Cliphist.refresh();
            root.prefix(Config.options.search.prefix.clipboard);
        }
        function workspacesToggle(): void {
            GlobalStates.overviewOpen = !GlobalStates.overviewOpen;
        }
        function toggleReleaseInterrupt(): void {
            GlobalStates.superReleaseMightTrigger = false;
        }
    }
    IpcHandler {
        target: "sidebarRight"
        function toggle(): void {
            root.controls();
        }
        function open(): void {
            GlobalStates.searchOpen = false;
            GlobalStates.sidebarRightOpen = true;
        }
        function close(): void {
            GlobalStates.sidebarRightOpen = false;
        }
    }
    IpcHandler {
        target: "bar"
        function toggle(): void {
            GlobalStates.barOpen = !GlobalStates.barOpen;
        }
        function open(): void {
            GlobalStates.barOpen = true;
        }
        function close(): void {
            GlobalStates.barOpen = false;
        }
    }
    GlobalShortcut {
        name: "searchToggle"
        description: "Toggle Encore launcher"
        onPressed: root.search()
    }
    GlobalShortcut {
        name: "searchToggleRelease"
        description: "Open Encore on Super release"
        onPressed: GlobalStates.superReleaseMightTrigger = true
        onReleased: {
            if (GlobalStates.superReleaseMightTrigger)
            root.search();
            GlobalStates.superReleaseMightTrigger = true;
        }
    }
    GlobalShortcut {
        name: "searchToggleReleaseInterrupt"
        description: "Cancel launcher on Super release"
        onPressed: GlobalStates.superReleaseMightTrigger = false
    }
    GlobalShortcut {
        name: "overviewClipboardToggle"
        description: "Encore clipboard"
        onPressed: {
            Cliphist.refresh();
            root.prefix(Config.options.search.prefix.clipboard);
        }
    }
    GlobalShortcut {
        name: "overviewEmojiToggle"
        description: "Encore emoji"
        onPressed: root.prefix(Config.options.search.prefix.emojis)
    }
    GlobalShortcut {
        name: "sidebarRightToggle"
        description: "Toggle Encore controls"
        onPressed: root.controls()
    }
    GlobalShortcut {
        name: "sidebarRightOpen"
        description: "Open Encore controls"
        onPressed: {
            GlobalStates.searchOpen = false;
            GlobalStates.sidebarRightOpen = true;
        }
    }
    GlobalShortcut {
        name: "sidebarRightClose"
        description: "Close Encore controls"
        onPressed: GlobalStates.sidebarRightOpen = false
    }
    GlobalShortcut {
        name: "overviewWorkspacesToggle"
        description: "Toggle Encore workspace overview"
        onPressed: {
            GlobalStates.searchOpen = false
            GlobalStates.sidebarRightOpen = false
            GlobalStates.overviewOpen = !GlobalStates.overviewOpen
        }
    }
    GlobalShortcut {
        name: "barToggle"
        description: "Toggle Encore bar"
        onPressed: GlobalStates.barOpen = !GlobalStates.barOpen
    }
}
