pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.modules.common

// Nix owns hyprland.conf. Keep shell overrides in the existing JSON settings
// and reapply native keywords after a compositor reload; no foreign Lua file.
Singleton {
    id: root
    signal reloaded()

    function apply(entries) {
        for (const item of entries)
            Quickshell.execDetached(["hyprctl", "keyword", item.key, String(item.value)])
    }
    function reapply() {
        if (Config.ready) apply(Config.options.hyprlandOverrides)
    }
    function set(key: string, value: var) {
        const entries = {}; entries[key] = value; setMany(entries)
    }
    function setMany(entries: var) {
        const next = Config.options.hyprlandOverrides.filter(item => !(item.key in entries))
        for (const key in entries) next.push({key: key, value: entries[key]})
        Config.options.hyprlandOverrides = next
        apply(next.filter(item => item.key in entries))
    }
    function reset(key: string) { resetMany([key]) }
    function resetMany(keys: list<string>) {
        Config.options.hyprlandOverrides = Config.options.hyprlandOverrides.filter(item => !keys.includes(item.key))
        Quickshell.execDetached(["hyprctl", "reload"])
    }
    Component.onCompleted: reapply()
    Connections { target: Config; function onReadyChanged() { root.reapply() } }
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "configreloaded") { root.reapply(); root.reloaded() }
        }
    }
}
