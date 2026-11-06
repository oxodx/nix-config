pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs
import qs.services
import qs.modules.common

Singleton {
    id: root
    readonly property var widgets: [
        { id: "weather", name: "Weather & forecast" }, { id: "calendar", name: "Calendar" },
        { id: "palette", name: "Palette" }, { id: "profile", name: "Profile & day progress" },
        { id: "clock", name: "Keycap clock" }, { id: "todo", name: "Little victories" },
        { id: "lyrics", name: "Synced lyrics" }, { id: "image", name: "Custom picture" },
        { id: "note", name: "Sticky note" }, { id: "media", name: "Media player" }
    ]
    function hidden(id) { return Config.options.encore.hiddenWidgets.includes(id) }
    function toggle(id) {
        const list = Config.options.encore.hiddenWidgets
        Config.options.encore.hiddenWidgets = list.includes(id) ? list.filter(item => item !== id) : [...list, id]
    }
    function findLayout(screen, id) { return Config.options.encore.widgetLayouts.find(item => item.screen === screen && item.id === id) ?? null }
    function saveLayout(screen, id, x, y, w, h) {
        Config.options.encore.widgetLayouts = [...Config.options.encore.widgetLayouts.filter(item => !(item.screen === screen && item.id === id)), {screen: screen, id: id, x: x, y: y, w: w, h: h}]
    }
    function resetLayout() { Config.options.encore.widgetLayouts = []; Config.options.encore.hiddenWidgets = [] }
    function accent(color) {
        Config.options.encore.previousAccent = Config.options.encore.accentColor
        const picked = Qt.darker(color, 1)
        // Pastel key fills keep dark labels legible even if the wallpaper is dark.
        Config.options.encore.accentColor = Qt.hsla(picked.hslHue < 0 ? 0.77 : picked.hslHue, Math.max(0.25, picked.hslSaturation), 0.76, 1).toString()
    }
    function undoAccent() {
        const previous = Config.options.encore.previousAccent
        Config.options.encore.previousAccent = Config.options.encore.accentColor
        Config.options.encore.accentColor = previous
    }
    function shuffle() { Config.options.encore.paletteMode = "random"; accent(Qt.hsla(Math.random(), 0.6, 0.76, 1)) }
    function sample(mode) {
        if (mode === "music" && !MprisController.activePlayer?.trackArtUrl) return
        Config.options.encore.paletteMode = mode
        if (quantizer.colors.length) accent(quantizer.colors[0])
    }
    ColorQuantizer {
        id: quantizer
        source: Config.options.encore.paletteMode === "music" ? (MprisController.activePlayer?.trackArtUrl ?? "") : (Config.options.background.wallpaperPath || Quickshell.shellPath("assets/images/default_wallpaper.png"))
        depth: 2; rescaleSize: 40
        onColorsChanged: {
            if (["music", "wallpaper"].includes(Config.options.encore.paletteMode) && colors.length) root.accent(colors[0])
        }
    }
    readonly property var sampledColors: quantizer.colors
    property string pickerKind: "image"
    function chooseImage(kind = "image") {
        pickerKind = kind
        picker.command = ["kdialog", "--getopenfilename", Directories.pictures, "*.png *.jpg *.jpeg *.webp *.gif"]
        picker.running = true
    }
    Process {
        id: picker
        stdout: StdioCollector {
            onStreamFinished: {
                const path = text.trim()
                if (!path) return
                if (root.pickerKind === "profile") Config.options.encore.profileImagePath = path
                else Config.options.encore.imagePath = path
            }
        }
    }
}
