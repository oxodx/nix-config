import QtQuick
import qs.modules.common

Item {
    id: root
    property string text: ""
    property int fontSize: 29
    property bool current: false
    property bool playing: false
    property real progress: 0
    property real smoothProgress: progress
    readonly property bool animate: Config.options.encore.motion && visible && current && playing
    Behavior on smoothProgress {
        enabled: root.current && root.playing && Math.abs(root.progress - root.smoothProgress) < 0.3
        NumberAnimation { duration: 210; easing.type: Easing.Linear }
    }
    FontMetrics { id: metrics; font.family: EncoreStyle.font; font.pixelSize: root.fontSize; font.bold: true }
    readonly property var words: {
        let tokens = text.trim().split(/\s+/).filter(word => word.length)
        const characters = tokens.length === 1 && /[\u3040-\u30ff\u3400-\u9fff\uac00-\ud7af]/.test(text)
        if (characters) tokens = Array.from(text.trim())
        if (!tokens.length) return []
        const gap = characters ? 0 : metrics.advanceWidth(" ")
        const lines = [[]]
        const widths = [0]
        let weight = 0
        for (const token of tokens) {
            const width = Math.min(root.width, metrics.advanceWidth(token) + 2)
            let line = lines.length - 1
            if (widths[line] && widths[line] + gap + width > root.width) {
                lines.push([]); widths.push(0); line++
            }
            const word = {text:token, width:width, x:widths[line] ? widths[line]+gap : 0, line:line, start:weight, weight:token.length+1}
            lines[line].push(word)
            widths[line] = word.x + width
            weight += word.weight
        }
        const lineHeight = metrics.height + 1
        const top = Math.max(0, (root.height - lines.length * lineHeight) / 2)
        const positioned = []
        for (let index = 0; index < lines.length; index++) {
            for (const word of lines[index]) positioned.push(Object.assign(word, {x:word.x+(root.width-widths[index])/2,y:top+index*lineHeight,total:weight}))
        }
        return positioned
    }
    Item {
        width: root.width
        height: Math.max(root.height, ...root.words.map(word => word.y + metrics.height))
        anchors.centerIn: parent
        scale: Math.min(1, root.height / height)
    Repeater {
        model: root.words
        Item {
            id: word
            required property var modelData
            required property int index
            x: modelData.x; y: modelData.y
            width: modelData.width; height: metrics.height
            readonly property real phase: root.current ? Math.max(0,Math.min(1,(root.smoothProgress*modelData.total-modelData.start)/modelData.weight)) : 0
            readonly property bool lit: phase > 0
            property real bounce: 0
            scale: 1 + bounce * 0.065
            rotation: (index % 2 ? 1 : -1) * bounce * 2
            transform: Translate { y: -3 * word.bounce }
            onLitChanged: if (lit && phase < 1 && root.animate) spring.restart()
            SequentialAnimation {
                id: spring
                NumberAnimation { target: word; property: "bounce"; to: 1; duration: 130; easing.type: Easing.OutCubic }
                NumberAnimation { target: word; property: "bounce"; to: 0; duration: 390; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
            }
            EncoreText {
                x: 2; y: 3; width: word.width; height: word.height
                text: word.modelData.text; font.pixelSize: root.fontSize; font.bold: true
                color: "#491b61"; style: Text.Outline; styleColor: "#250b35"
            }
            EncoreText {
                text: word.modelData.text; font.pixelSize: root.fontSize; font.bold: true
                color: root.current ? "#fff0fc" : "#ddb4eb"; style: Text.Outline; styleColor: "#703d91"
            }
            Item {
                width: word.width * word.phase; height: word.height + 3; clip: true
                EncoreText {
                    text: word.modelData.text; font.pixelSize: root.fontSize; font.bold: true
                    color: "#d4a0ff"; style: Text.Outline; styleColor: "#854bb1"
                }
            }
        }
    }
    }
}
