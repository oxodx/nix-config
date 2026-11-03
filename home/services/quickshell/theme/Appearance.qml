pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

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
  readonly property real slantScale: 1

  // Horizontal cut per pixel of height. Nested skewed panels use this same slope, so their
  // edges run parallel at any size.
  readonly property real skew: 0.04

  readonly property QtObject colors: QtObject {
    // shadcn neutrals: zinc surfaces, zinc borders, and near-white text. No gradients.
    readonly property color m3background: "#09090b"
    readonly property color m3onBackground: "#fafafa"
    readonly property color m3surface: "#09090b"
    readonly property color m3surfaceDim: "#09090b"
    readonly property color m3surfaceBright: "#3f3f46"
    readonly property color m3surfaceContainerLowest: "#09090b"
    readonly property color m3surfaceContainerLow: "#09090b"
    readonly property color m3surfaceContainer: "#18181b"
    readonly property color m3surfaceContainerHigh: "#27272a"
    readonly property color m3surfaceContainerHighest: "#3f3f46"
    readonly property color m3onSurface: "#fafafa"
    readonly property color m3surfaceVariant: "#27272a"
    readonly property color m3onSurfaceVariant: "#a1a1aa"
    readonly property color m3inverseSurface: "#fafafa"
    readonly property color m3inverseOnSurface: "#18181b"
    readonly property color m3outline: "#52525b"
    readonly property color m3outlineVariant: "#27272a"
    readonly property color m3shadow: "#000000"
    readonly property color m3scrim: "#000000"
    readonly property color m3surfaceTint: "#fafafa"
    readonly property color m3primary: "#fafafa"
    readonly property color m3onPrimary: "#18181b"
    readonly property color m3primaryContainer: "#27272a"
    readonly property color m3onPrimaryContainer: "#fafafa"
    readonly property color m3inversePrimary: "#18181b"
    readonly property color m3secondary: "#a1a1aa"
    readonly property color m3onSecondary: "#18181b"
    readonly property color m3secondaryContainer: "#27272a"
    readonly property color m3onSecondaryContainer: "#fafafa"
    readonly property color m3tertiary: "#a1a1aa"
    readonly property color m3onTertiary: "#18181b"
    readonly property color m3tertiaryContainer: "#3f3f46"
    readonly property color m3onTertiaryContainer: "#fafafa"
    readonly property color m3error: "#ef4444"
    readonly property color m3onError: "#fafafa"
    readonly property color m3errorContainer: "#7f1d1d"
    readonly property color m3onErrorContainer: "#fecaca"
    readonly property color m3primaryFixed: "#fafafa"
    readonly property color m3primaryFixedDim: "#d4d4d8"
    readonly property color m3onPrimaryFixed: "#18181b"
    readonly property color m3onPrimaryFixedVariant: "#3f3f46"
    readonly property color m3secondaryFixed: "#e4e4e7"
    readonly property color m3secondaryFixedDim: "#d4d4d8"
    readonly property color m3onSecondaryFixed: "#18181b"
    readonly property color m3onSecondaryFixedVariant: "#3f3f46"
    readonly property color m3tertiaryFixed: "#e4e4e7"
    readonly property color m3tertiaryFixedDim: "#a1a1aa"
    readonly property color m3onTertiaryFixed: "#18181b"
    readonly property color m3onTertiaryFixedVariant: "#3f3f46"

    readonly property color bar: "#e609090b"
    readonly property color barOutline: "#27272a"
    readonly property color widget: "#18181b"
    readonly property color widgetActive: "#27272a"
    readonly property color widgetOutline: "#27272a"
    readonly property color widgetOutlineSeparate: "#27272a"
    readonly property color separator: "#27272a"
    readonly property color panel: "#ee09090b"
    readonly property color panelTranslucent: "#c209090b"
    readonly property color overlayPanel: "#f209090b"
    readonly property color alert: "#ef4444"
    readonly property color alertOutline: "#66ef4444"
    readonly property color sliderFill: "#fafafa"
    readonly property color sliderGroove: "#27272a"
    readonly property color neutralShadow: "#33000000"
    readonly property color elevatedShadow: "#66000000"

    // The keycap finish, in neutrals: a near-black outline and edge, a zinc ring, and a hard shadow.
    readonly property color ink: "#09090b"
    readonly property color cream: "#fafafa"
    readonly property color cardRing: "#3f3f46"
    readonly property color inkShadow: "#e609090b"
  }

  readonly property QtObject rounding: QtObject {
    readonly property int small: 6
    readonly property int normal: 8
    readonly property int large: 12
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
