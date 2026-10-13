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

  readonly property QtObject colors: QtObject {
    readonly property color m3background: "#141318"
    readonly property color m3onBackground: "#E5E1E9"
    readonly property color m3surface: "#141318"
    readonly property color m3surfaceDim: "#141318"
    readonly property color m3surfaceBright: "#3A383E"
    readonly property color m3surfaceContainerLowest: "#0E0D13"
    readonly property color m3surfaceContainerLow: "#1C1B20"
    readonly property color m3surfaceContainer: "#201F25"
    readonly property color m3surfaceContainerHigh: "#2B292F"
    readonly property color m3surfaceContainerHighest: "#35343A"
    readonly property color m3onSurface: "#E5E1E9"
    readonly property color m3surfaceVariant: "#48454E"
    readonly property color m3onSurfaceVariant: "#C9C5D0"
    readonly property color m3inverseSurface: "#E5E1E9"
    readonly property color m3inverseOnSurface: "#312F36"
    readonly property color m3outline: "#938F99"
    readonly property color m3outlineVariant: "#48454E"
    readonly property color m3shadow: "#000000"
    readonly property color m3scrim: "#000000"
    readonly property color m3surfaceTint: "#C8BFFF"
    readonly property color m3primary: "#C8BFFF"
    readonly property color m3onPrimary: "#30285F"
    readonly property color m3primaryContainer: "#473F77"
    readonly property color m3onPrimaryContainer: "#E5DEFF"
    readonly property color m3inversePrimary: "#5F5791"
    readonly property color m3secondary: "#C9C3DC"
    readonly property color m3onSecondary: "#312E41"
    readonly property color m3secondaryContainer: "#484459"
    readonly property color m3onSecondaryContainer: "#E5DFF9"
    readonly property color m3tertiary: "#ECB8CD"
    readonly property color m3onTertiary: "#482536"
    readonly property color m3tertiaryContainer: "#B38397"
    readonly property color m3onTertiaryContainer: "#000000"
    readonly property color m3error: "#EA8DC1"
    readonly property color m3onError: "#690005"
    readonly property color m3errorContainer: "#93000A"
    readonly property color m3onErrorContainer: "#FFDAD6"
    readonly property color m3primaryFixed: "#E5DEFF"
    readonly property color m3primaryFixedDim: "#C8BFFF"
    readonly property color m3onPrimaryFixed: "#1B1149"
    readonly property color m3onPrimaryFixedVariant: "#473F77"
    readonly property color m3secondaryFixed: "#E5DFF9"
    readonly property color m3secondaryFixedDim: "#C9C3DC"
    readonly property color m3onSecondaryFixed: "#1C192B"
    readonly property color m3onSecondaryFixedVariant: "#484459"
    readonly property color m3tertiaryFixed: "#FFD8E7"
    readonly property color m3tertiaryFixedDim: "#ECB8CD"
    readonly property color m3onTertiaryFixed: "#301121"
    readonly property color m3onTertiaryFixedVariant: "#613B4C"

    readonly property color bar: "#e611131a"
    readonly property color barOutline: "#24ffffff"
    readonly property color widget: "#12ffffff"
    readonly property color widgetActive: "#38ffffff"
    readonly property color widgetOutline: "#18ffffff"
    readonly property color widgetOutlineSeparate: "#12ffffff"
    readonly property color separator: "#24ffffff"
  }

  readonly property QtObject rounding: QtObject {
    readonly property int small: 12
    readonly property int normal: 17
    readonly property int large: 25
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
      readonly property string sans: "IBM Plex Sans"
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
