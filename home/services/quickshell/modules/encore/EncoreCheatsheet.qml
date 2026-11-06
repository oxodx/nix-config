import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.modules.common

EncorePopup {
    id: root
    cardWidth: 1160
    cardHeight: 900
    property string query: ""
    function keys(bind) {
        if (bind.key === "Super_L" || bind.key === "Super_R") return "Tap Super"
        const parts = [];
        if (bind.modmask & 4)
            parts.push("Ctrl");
        if (bind.modmask & 64)
            parts.push("Super");
        if (bind.modmask & 1)
            parts.push("Shift");
        if (bind.modmask & 8)
            parts.push("Alt");
        parts.push(bind.key || "code:" + bind.keycode);
        return parts.join(" + ");
    }
    readonly property var groups: {
        const groups = {};
        const filter = query.toLowerCase().trim();
        for (const bind of HyprlandKeybinds.keybinds) {
            if (!bind.description?.length)
                continue;
            if (filter && !(keys(bind) + " " + bind.description).toLowerCase().includes(filter))
                continue;
            const split = bind.description.indexOf(":");
            const category = split >= 0 ? bind.description.slice(0, split) : "Other";
            const description = split >= 0 ? bind.description.slice(split + 1).trim() : bind.description;
            if (!groups[category])
                groups[category] = [];
            // Physical-key aliases do the same thing; keep described regular keys.
            if (!bind.key && HyprlandKeybinds.keybinds.some(other => other.key && other.modmask === bind.modmask
                                                                     && other.dispatcher === bind.dispatcher
                                                                     && other.arg === bind.arg))
                continue;
            groups[category].push({
                                      keys: keys(bind),
                                      description: description
                                  });
        }
        return Object.keys(groups).filter(name => groups[name].length).map(name => ({
            name: name,
            rows: groups[name]
        }));
    }
        ColumnLayout {
        anchors.fill: parent
        spacing: 14
        RowLayout {
        Layout.fillWidth: true
        ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        EncoreText {
        text: "A LITTLE MAP OF YOUR UNIVERSE"
        font.pixelSize: 10
        font.letterSpacing: 2
        color: EncoreStyle.muted
    }
        EncoreText {
        text: "Make yourself at home."
        font.pixelSize: 28
        font.bold: true
        Layout.fillWidth: true
    }
    }
        EncoreButton {
        symbol: "close"
        fill: EncoreStyle.pink
        hint: "Close keybinds"
        onClicked: root.dismissed()
    }
    }
        TextField {
        id: search
        Layout.fillWidth: true
        implicitHeight: 42
        placeholderText: "Find an action or shortcut…"
        color: EncoreStyle.text
        placeholderTextColor: EncoreStyle.muted
        font.family: EncoreStyle.font
        font.pixelSize: 14
        padding: 12
        background: EncoreCard {
        fill: EncoreStyle.surface
        radius: 12
        depth: 2
    }
        onTextChanged: root.query = text
        Accessible.name: "Search keybinds"
    }
        Flickable {
        id: scroll
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        contentHeight: grid.implicitHeight + 8
        contentWidth: width
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar {}
        Row {
        id: grid
        width: scroll.width - 12
        spacing: 20
        readonly property int columns: width >= 700 ? 2 : 1
        readonly property var stacks: {
        const result = Array.from({
        length: columns
    }, () => []);
        const weights = Array(columns).fill(0);
        for (const group of root.groups) {
        const column = weights.indexOf(Math.min(...weights));
        result[column].push(group);
        weights[column] += group.rows.length + 2;
    }
        return result;
    }
        Repeater {
        model: grid.stacks
        Column {
        required property var modelData
        width: (grid.width - (grid.columns - 1) * grid.spacing) / grid.columns
        spacing: 16
        Repeater {
        model: parent.modelData
        Item {
        id: category
        required property var modelData
        width: parent.width
        implicitHeight: rows.implicitHeight
        ColumnLayout {
        id: rows
        width: parent.width
        spacing: 6
        RowLayout {
        Layout.fillWidth: true
        EncoreText {
        text: "✦  " + category.modelData.name
        font.pixelSize: 16
        font.bold: true
        Layout.fillWidth: true
    }
        EncoreText {
        text: category.modelData.rows.length
        color: EncoreStyle.muted
        font.pixelSize: 10
    }
    }
        Rectangle {
        Layout.fillWidth: true
        implicitHeight: 1
        color: EncoreStyle.outline
        opacity: 0.5
    }
        Repeater {
        model: category.modelData.rows
        Item {
        id: line
        required property var modelData
        Layout.fillWidth: true
        implicitHeight: Math.max(keycap.height, description.implicitHeight)
        Rectangle {
        id: keycap
        width: parent.width * 0.48
        height: shortcut.implicitHeight + 10
        radius: 7
        color: EncoreStyle.surface
        border.width: 1
        border.color: EncoreStyle.outline
        EncoreText {
        id: shortcut
        x: 7
        y: 5
        width: parent.width - 14
        text: line.modelData.keys
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 11
        font.bold: true
    }
    }
        EncoreText {
        id: description
        anchors.left: keycap.right
        anchors.leftMargin: 10
        anchors.right: parent.right
        text: line.modelData.description
        font.pixelSize: 12
        wrapMode: Text.Wrap
    }
    }
    }
    }
    }
    }
    }
    }
    }
        EncoreText {
        anchors.centerIn: parent
        visible: root.groups.length === 0
        text: root.query ? "No shortcuts match. Try another word ♡" : "Loading your shortcuts…"
        color: EncoreStyle.muted
    }
    }
        EncoreText {
        text: "SCROLL TO EXPLORE  ♡  ESC TO CLOSE"
        font.pixelSize: 9
        font.letterSpacing: 1
        color: EncoreStyle.muted
        Layout.alignment: Qt.AlignHCenter
    }
    }
    }
