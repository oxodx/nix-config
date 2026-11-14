pragma Singleton
import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    readonly property bool dark: Config.options.encore.darkMode
    readonly property color ink: "#1d0b2b"
    readonly property color outline: dark ? "#bfa0dc" : "#3b2050"
    readonly property color cream: dark ? "#f3e8fc" : "#fff8ff"
    readonly property color paper: dark ? "#271535" : "#f7ebff"
    readonly property color surface: dark ? "#3b2450" : "#e5d2f3"
    readonly property color raised: dark ? "#4a2c61" : "#fff8ff"
    readonly property color text: dark ? "#f8eeff" : "#24112f"
    readonly property color muted: dark ? "#ccb9d9" : "#725f7c"
    readonly property color lavender: Config.options.encore.accentColor
    readonly property color pink: dark ? "#f2a9cd" : "#e899bf"
    readonly property color yellow: dark ? "#f2d394" : "#e9bd68"
    readonly property color shadow: dark ? "#14071d" : "#2a1238"
    readonly property color softOutline: Qt.rgba(outline.r, outline.g, outline.b, dark ? 0.38 : 0.28)
    readonly property color highlight: Qt.rgba(cream.r, cream.g, cream.b, dark ? 0.11 : 0.72)
    readonly property string font: Appearance.font.family.main
    readonly property int radius: 17
    readonly property int barHeight: 24
}
