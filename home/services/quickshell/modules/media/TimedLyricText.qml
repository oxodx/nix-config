import QtQuick
import qs.components
import qs.theme

StyledText {
  id: root
  property string lineText: ""
  property var words: []
  property real position: 0
  property bool highlighting: false
  property color highlightColor: Appearance.colors.m3primary
  textFormat: Text.RichText

  function escapeHtml(value): string {
    return value.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
  }

  text: {
    if (!highlighting || !words.length) return escapeHtml(lineText);
    let result = "";
    let offset = 0;
    for (const word of words) {
      result += escapeHtml(lineText.slice(offset, word.offset));
      const fraction = word.end > word.start ? Math.max(0, Math.min(1, (position - word.start) / (word.end - word.start))) : (position >= word.start ? 1 : 0);
      const tint = Appearance.interpolateColors(fraction, color, highlightColor);
      result += '<span style="color:' + tint + '">' + escapeHtml(lineText.slice(word.offset, word.offset + word.length)) + '</span>';
      offset = word.offset + word.length;
    }
    return result + escapeHtml(lineText.slice(offset));
  }
}
