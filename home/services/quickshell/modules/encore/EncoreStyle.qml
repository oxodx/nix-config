pragma Singleton
import QtQuick
import Quickshell
import qs.modules.common

Singleton {
    readonly property bool dark: Config.options.encore.darkMode
    readonly property color ink: "#210c32"
    readonly property color outline: dark ? "#c49be8" : "#210c32"
    readonly property color cream: "#f0e1fc"
    readonly property color paper: dark ? "#291438" : "#f0e1fc"
    readonly property color surface: dark ? "#3c2051" : "#dbc4ef"
    readonly property color text: dark ? "#f0e1fc" : "#210c32"
    readonly property color muted: dark ? "#d5c0e5" : "#756080"
    readonly property color lavender: Config.options.encore.accentColor
    readonly property color pink: "#f3afce"
    readonly property color yellow: "#edc8ed"
    readonly property string font: Appearance.font.family.main
    readonly property int radius: 15
    readonly property int barHeight: 24
}
