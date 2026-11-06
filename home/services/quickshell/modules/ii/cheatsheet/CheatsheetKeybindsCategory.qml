pragma ComponentBehavior: Bound

import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell

// Notes:
// We deal with keybinds being numbered 1, 2, etc by discarding 2+, keeping 1 and replacing it with a generic "<Number>"
Column {
    id: root
    required property string categoryName
    readonly property bool isCategorized: categoryName?.length > 0
    property int maxBindWidth: 0
    property real columnSpacing: 40
    property real titleSpacing: 7

    // Excellent symbol explaination and source :
    // http://xahlee.info/comp/unicode_computing_symbols.html
    // https://www.nerdfonts.com/cheat-sheet
    property var macSymbolMap: ({
        "Ctrl": "󰘴",
        "Alt": "󰘵",
        "Shift": "󰘶",
        "Space": "󱁐",
        "Tab": "↹",
        "Equal": "󰇼",
        "Minus": "",
        "Print": "",
        "BackSpace": "󰭜",
        "Delete": "⌦",
        "Return": "󰌑",
        "Period": ".",
        "Escape": "⎋"
      })
    property var functionSymbolMap: ({
        "F1":  "󱊫",
        "F2":  "󱊬",
        "F3":  "󱊭",
        "F4":  "󱊮",
        "F5":  "󱊯",
        "F6":  "󱊰",
        "F7":  "󱊱",
        "F8":  "󱊲",
        "F9":  "󱊳",
        "F10": "󱊴",
        "F11": "󱊵",
        "F12": "󱊶",
    })

    property var mouseSymbolMap: ({
        "mouse_up": "󱕐",
        "mouse_down": "󱕑",
        "mouse:272": "L󰍽",
        "mouse:273": "R󰍽",
        "Scroll ↑/↓": "󱕒",
        "Page_↑/↓": "⇞/⇟",
    })

    property var keyBlacklist: ["SUPER_L", "SUPER_R"]
    property var keySubstitutions: Object.assign({
        "Super": "",
        "mouse_up": "Scroll ↓",    // ikr, weird
        "mouse_down": "Scroll ↑",  // trust me bro
        "mouse:272": "LMB",
        "mouse:273": "RMB",
        "mouse:275": "MouseBack",
        "Slash": "/",
        "Hash": "#",
        "Return": "Enter",
        // "Shift": "",
      },
      !!Config.options.cheatsheet.superKey ? {
          "Super": Config.options.cheatsheet.superKey,
      }: {},
      Config.options.cheatsheet.useMacSymbol ? macSymbolMap : {},
      Config.options.cheatsheet.useFnSymbol ? functionSymbolMap : {},
      Config.options.cheatsheet.useMouseSymbol ? mouseSymbolMap : {},
    )

    function modMaskToStringList(modMask: int): list<string> {
        var list = [];
        // Funny mathematical order but we wanna have this natural user-facing order
        if (modMask & (1 << 2)) { list.push("Ctrl"); }
        if (modMask & (1 << 6)) { list.push("Super"); }
        if (modMask & (1 << 0)) { list.push("Shift"); }
        if (modMask & (1 << 3)) { list.push("Alt"); }
        if (modMask & (1 << 1)) { list.push("Caps"); }
        if (modMask & (1 << 4)) { list.push("Mod2"); }
        if (modMask & (1 << 5)) { list.push("Mod3"); }
        if (modMask & (1 << 7)) { list.push("Mod5"); }
        return list;
    }

    visible: repeater.model.length > 0
    spacing: titleSpacing

    StyledText {
        text: root.isCategorized ? root.categoryName : "Uncategorized"
        font.pixelSize: Appearance.font.pixelSize.title
    }

    function hasDescription(bind) {
        return bind.description?.length > 0;
    }

    function isCategory(bind, categoryName) {
        return bind.description.substring(0, bind.description.indexOf(":")) === categoryName;
    }

    function isUncategorized(bind) {
        return bind.description.indexOf(":") === -1;
    }

    function containsNonFirstRepetitive(bind) {
        const key = bind.key;
        if (key.includes("mouse") || key.includes("page")) return false;
        // Contains non-1 number
        if (/^[0-9]$/.test(key) && key !== "1") return true;
        // Contains non-left direction
        if (/^(right|up|down)\b/i.test(key)) return true;
        return false;
    }

    function containsFirstRepetitive(bind) {
        const key = bind.key;
        return key === "1" || /^left$/i.test(key);
    }

    function transformKey(key) {
        const replaced = root.keySubstitutions[key] || key;
        const denumbered = key === "1" ? "<Number>" : replaced;
        const dedirectioned = /^left$/i.test(key) ? "<Direction>" : denumbered;
        return dedirectioned;
    }

    function transformDescription(bind, categoryName) {
        const description = bind.description
        const regex = new RegExp("\\s*" + categoryName + "\\s*:\\s*");
        const decategorized = description.replace(regex, "");
        if (!containsFirstRepetitive(bind)) return decategorized;
        const denumbered = bind.key === "1" ? decategorized.replace(/\b1\b/, "<Number>") : decategorized;
        const dedirectioned = denumbered.replace(/ \b(left|right|up|down)\b/i, " <Direction>");
        return dedirectioned;
    }

    Column {
        width: root.width
        spacing: 8
        Repeater {
            id: repeater
            model: {
                if (!root.isCategorized) {
                    return HyprlandKeybinds.keybinds.filter(bind => root.hasDescription(bind) && root.isUncategorized(bind) && !root.containsNonFirstRepetitive(bind));
                }
                return HyprlandKeybinds.keybinds.filter(bind => root.hasDescription(bind) && root.isCategory(bind, root.categoryName) && !root.containsNonFirstRepetitive(bind));
            }
            delegate: BindLine {
                required property var modelData
                keyData: modelData
                categoryName: root.categoryName
            }
        }
    }

    component BindLine: Item {
        id: bindLine
        required property var keyData
        property string categoryName: ""
        width: root.width
        implicitHeight: Math.max(keyFlow.implicitHeight, commentText.implicitHeight)

        Flow {
            id: keyFlow
            width: Math.min(350, bindLine.width * 0.55)
            spacing: 4
            Repeater {
                model: {
                    const mods = root.modMaskToStringList(bindLine.keyData.modmask).map(mod => root.keySubstitutions[mod] || mod)
                    const parts = Config.options.cheatsheet.splitButtons ? mods : (mods.length ? [mods.join(" ")] : [])
                    if (!root.keyBlacklist.includes(bindLine.keyData.key)) parts.push(root.transformKey(bindLine.keyData.key))
                    return parts
                }
                delegate: Item {
                    required property var modelData
                    readonly property real fitScale: Math.min(1, keyFlow.width / keycap.implicitWidth)
                    width: keycap.implicitWidth * fitScale
                    height: keycap.implicitHeight * fitScale
                    KeyboardKey {
                        id: keycap
                        key: parent.modelData
                        pixelSize: Config.options.cheatsheet.fontSize.key
                        scale: parent.fitScale
                        transformOrigin: Item.TopLeft
                    }
                }
            }
        }
        StyledText {
            id: commentText
            anchors.left: keyFlow.right
            anchors.leftMargin: 16
            anchors.right: parent.right
            font.pixelSize: Config.options.cheatsheet.fontSize.comment || Appearance.font.pixelSize.smaller
            text: root.transformDescription(bindLine.keyData, bindLine.categoryName)
            wrapMode: Text.Wrap
        }
    }
}
