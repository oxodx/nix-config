pragma Singleton

import QtQuick
import Quickshell
import qs.services

Singleton {
  id: root

  // The palette in use: the default unless the chosen theme (SettingsService: theme.preset) is another.
  readonly property var pal: ThemePresets.palette(SettingsService.get("theme.preset") ?? "blend")

  readonly property var popoutXCurve: EasingCurve {
    curve.type: Easing.OutQuint
  }

  readonly property var popoutYCurve: EasingCurve {
    curve.type: Easing.InQuart
  }

  function interpolateColors(x: real, a: color, b: color): color {
    const xa = 1.0 - x;
    return Qt.rgba(a.r * xa + b.r * x, a.g * xa + b.g * x, a.b * xa + b.b * x, a.a * xa + b.a * x);
  }

  // 0 draws every skewed shape as a flat rounded rectangle; 1 draws the skewed look.
  readonly property real slantScale: SettingsService.flag("ui.slant") ? 1 : 0

  // Horizontal cut per pixel of height. Nested skewed panels use this same slope, so their
  // edges run parallel at any size.
  readonly property real skew: 0.04

  readonly property QtObject colors: QtObject {
    // shadcn neutrals: zinc surfaces, zinc borders, and near-white text. No gradients.
    readonly property color m3background: root.pal.m3background
    readonly property color m3onBackground: root.pal.m3onBackground
    readonly property color m3surface: root.pal.m3surface
    readonly property color m3surfaceDim: root.pal.m3surfaceDim
    readonly property color m3surfaceBright: root.pal.m3surfaceBright
    readonly property color m3surfaceContainerLowest: root.pal.m3surfaceContainerLowest
    readonly property color m3surfaceContainerLow: root.pal.m3surfaceContainerLow
    readonly property color m3surfaceContainer: root.pal.m3surfaceContainer
    readonly property color m3surfaceContainerHigh: root.pal.m3surfaceContainerHigh
    readonly property color m3surfaceContainerHighest: root.pal.m3surfaceContainerHighest
    readonly property color m3onSurface: root.pal.m3onSurface
    readonly property color m3surfaceVariant: root.pal.m3surfaceVariant
    readonly property color m3onSurfaceVariant: root.pal.m3onSurfaceVariant
    readonly property color m3inverseSurface: root.pal.m3inverseSurface
    readonly property color m3inverseOnSurface: root.pal.m3inverseOnSurface
    readonly property color m3outline: root.pal.m3outline
    readonly property color m3outlineVariant: root.pal.m3outlineVariant
    readonly property color m3shadow: root.pal.m3shadow
    readonly property color m3scrim: root.pal.m3scrim
    readonly property color m3surfaceTint: root.pal.m3surfaceTint
    readonly property color m3primary: root.pal.m3primary
    readonly property color m3onPrimary: root.pal.m3onPrimary
    readonly property color m3primaryContainer: root.pal.m3primaryContainer
    readonly property color m3onPrimaryContainer: root.pal.m3onPrimaryContainer
    readonly property color m3inversePrimary: root.pal.m3inversePrimary
    readonly property color m3secondary: root.pal.m3secondary
    readonly property color m3onSecondary: root.pal.m3onSecondary
    readonly property color m3secondaryContainer: root.pal.m3secondaryContainer
    readonly property color m3onSecondaryContainer: root.pal.m3onSecondaryContainer
    readonly property color m3tertiary: root.pal.m3tertiary
    readonly property color m3onTertiary: root.pal.m3onTertiary
    readonly property color m3tertiaryContainer: root.pal.m3tertiaryContainer
    readonly property color m3onTertiaryContainer: root.pal.m3onTertiaryContainer
    readonly property color m3error: root.pal.m3error
    readonly property color m3onError: root.pal.m3onError
    readonly property color m3errorContainer: root.pal.m3errorContainer
    readonly property color m3onErrorContainer: root.pal.m3onErrorContainer
    readonly property color m3primaryFixed: root.pal.m3primaryFixed
    readonly property color m3primaryFixedDim: root.pal.m3primaryFixedDim
    readonly property color m3onPrimaryFixed: root.pal.m3onPrimaryFixed
    readonly property color m3onPrimaryFixedVariant: root.pal.m3onPrimaryFixedVariant
    readonly property color m3secondaryFixed: root.pal.m3secondaryFixed
    readonly property color m3secondaryFixedDim: root.pal.m3secondaryFixedDim
    readonly property color m3onSecondaryFixed: root.pal.m3onSecondaryFixed
    readonly property color m3onSecondaryFixedVariant: root.pal.m3onSecondaryFixedVariant
    readonly property color m3tertiaryFixed: root.pal.m3tertiaryFixed
    readonly property color m3tertiaryFixedDim: root.pal.m3tertiaryFixedDim
    readonly property color m3onTertiaryFixed: root.pal.m3onTertiaryFixed
    readonly property color m3onTertiaryFixedVariant: root.pal.m3onTertiaryFixedVariant

    readonly property color bar: root.pal.bar
    readonly property color barOutline: root.pal.barOutline
    readonly property color widget: root.pal.widget
    readonly property color widgetActive: root.pal.widgetActive
    readonly property color widgetOutline: root.pal.widgetOutline
    readonly property color widgetOutlineSeparate: root.pal.widgetOutlineSeparate
    readonly property color separator: root.pal.separator
    readonly property color panel: root.pal.panel
    readonly property color panelTranslucent: root.pal.panelTranslucent
    readonly property color overlayPanel: root.pal.overlayPanel
    readonly property color alert: root.pal.alert
    readonly property color alertOutline: root.pal.alertOutline
    readonly property color sliderFill: root.pal.sliderFill
    readonly property color sliderGroove: root.pal.sliderGroove
    readonly property color neutralShadow: root.pal.neutralShadow
    readonly property color elevatedShadow: root.pal.elevatedShadow

    // The keycap finish, in neutrals: a near-black outline and edge, a zinc ring, and a hard shadow.
    readonly property color ink: root.pal.ink
    readonly property color cream: root.pal.cream
    readonly property color cardRing: root.pal.cardRing
    readonly property color inkShadow: root.pal.inkShadow
    readonly property color keycapShadow: SettingsService.flag("ui.buttonShadow") ? root.pal.keycapShadow : "#00000000"
  }

  readonly property QtObject rounding: QtObject {
    readonly property int small: Math.round(8 * SettingsService.get("ui.radiusScale"))
    readonly property int normal: Math.round(12 * SettingsService.get("ui.radiusScale"))
    readonly property int large: Math.round(16 * SettingsService.get("ui.radiusScale"))
    readonly property int full: 1000
  }

  readonly property QtObject spacing: QtObject {
    readonly property int small: 7
    readonly property int smaller: 10
    readonly property int normal: 12
    readonly property int larger: 15
    readonly property int large: 20
  }

  readonly property QtObject padding: QtObject {
    readonly property int small: 5
    readonly property int smaller: 7
    readonly property int normal: 10
    readonly property int larger: 12
    readonly property int large: 15
  }

  readonly property QtObject font: QtObject {
    readonly property QtObject family: QtObject {
      readonly property string sans: "Inter"
      readonly property string mono: "JetBrains Mono NF"
      readonly property string material: "Material Symbols Rounded"
    }

    readonly property QtObject size: QtObject {
      readonly property int small: 11
      readonly property int smaller: 12
      readonly property int normal: 13
      readonly property int larger: 15
      readonly property int large: 18
      readonly property int extraLarge: 28
    }
  }

  readonly property QtObject anim: QtObject {
    readonly property QtObject curves: QtObject {
      readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
      readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
      readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
      readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
      readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
      readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
      readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
      readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
      readonly property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
    }

    readonly property QtObject durations: QtObject {
      readonly property int small: 200
      readonly property int normal: 400
      readonly property int large: 600
      readonly property int extraLarge: 1000
      readonly property int expressiveFastSpatial: 350
      readonly property int expressiveDefaultSpatial: 500
      readonly property int expressiveEffects: 200
    }
  }
}
