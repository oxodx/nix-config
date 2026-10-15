import qs.theme
import qs.components

ActionButton {
  property bool prominent: false
  property real buttonSize: prominent ? 48 : 40
  implicitWidth: prominent ? buttonSize + 14 : buttonSize
  implicitHeight: buttonSize
  active: prominent
  iconSize: prominent ? Appearance.font.size.extraLarge : Appearance.font.size.large
  disabledOpacity: 0.35
  transitionDuration: 0
}
