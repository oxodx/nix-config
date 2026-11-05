pragma Singleton

import QtQuick
import Quickshell

// The colour themes the shell can switch between. `base` is the default palette. Each preset
// overrides only the colours that give it its look, and everything else comes from `base`.
// Appearance reads the active one, and SettingsService stores which one is chosen.
Singleton {
  id: root

  readonly property var base: {
    "m3background": "#09090b",
    "m3onBackground": "#fafafa",
    "m3surface": "#09090b",
    "m3surfaceDim": "#09090b",
    "m3surfaceBright": "#3f3f46",
    "m3surfaceContainerLowest": "#09090b",
    "m3surfaceContainerLow": "#09090b",
    "m3surfaceContainer": "#18181b",
    "m3surfaceContainerHigh": "#27272a",
    "m3surfaceContainerHighest": "#3f3f46",
    "m3onSurface": "#fafafa",
    "m3surfaceVariant": "#27272a",
    "m3onSurfaceVariant": "#a1a1aa",
    "m3inverseSurface": "#fafafa",
    "m3inverseOnSurface": "#18181b",
    "m3outline": "#52525b",
    "m3outlineVariant": "#27272a",
    "m3shadow": "#000000",
    "m3scrim": "#000000",
    "m3surfaceTint": "#fafafa",
    "m3primary": "#c4a7ff",
    "m3onPrimary": "#1f1333",
    "m3primaryContainer": "#2e2146",
    "m3onPrimaryContainer": "#ead9ff",
    "m3inversePrimary": "#18181b",
    "m3secondary": "#a1a1aa",
    "m3onSecondary": "#18181b",
    "m3secondaryContainer": "#27272a",
    "m3onSecondaryContainer": "#fafafa",
    "m3tertiary": "#f2b8d8",
    "m3onTertiary": "#18181b",
    "m3tertiaryContainer": "#3f3f46",
    "m3onTertiaryContainer": "#fafafa",
    "m3error": "#ef4444",
    "m3onError": "#fafafa",
    "m3errorContainer": "#7f1d1d",
    "m3onErrorContainer": "#fecaca",
    "m3primaryFixed": "#fafafa",
    "m3primaryFixedDim": "#c4a7ff",
    "m3onPrimaryFixed": "#18181b",
    "m3onPrimaryFixedVariant": "#3f3f46",
    "m3secondaryFixed": "#e4e4e7",
    "m3secondaryFixedDim": "#d4d4d8",
    "m3onSecondaryFixed": "#18181b",
    "m3onSecondaryFixedVariant": "#3f3f46",
    "m3tertiaryFixed": "#e4e4e7",
    "m3tertiaryFixedDim": "#a1a1aa",
    "m3onTertiaryFixed": "#18181b",
    "m3onTertiaryFixedVariant": "#3f3f46",
    "bar": "#e609090b",
    "barOutline": "#27272a",
    "widget": "#18181b",
    "widgetActive": "#27272a",
    "widgetOutline": "#0b0a10",
    "widgetOutlineSeparate": "#0b0a10",
    "separator": "#27272a",
    "panel": "#ee09090b",
    "panelTranslucent": "#c209090b",
    "overlayPanel": "#f209090b",
    "alert": "#ef4444",
    "alertOutline": "#66ef4444",
    "sliderFill": "#fafafa",
    "sliderGroove": "#27272a",
    "neutralShadow": "#33000000",
    "elevatedShadow": "#66000000",
    "ink": "#09090b",
    "cream": "#fafafa",
    "cardRing": "#00000000",
    "inkShadow": "#00000000",
    "keycapShadow": "#99000000",
  }

  readonly property var presets: ({
    shadcn: {
    "m3primary": "#fafafa",
    "m3onPrimary": "#18181b",
    "m3primaryContainer": "#27272a",
    "m3onPrimaryContainer": "#fafafa",
    "m3tertiary": "#a1a1aa",
    "m3primaryFixedDim": "#d4d4d8",
    "keycapShadow": "#66000000",
  },
    plum: {
    "m3background": "#17111f",
    "m3surface": "#17111f",
    "m3surfaceContainerLow": "#1c1527",
    "m3surfaceContainer": "#231b30",
    "m3surfaceContainerHigh": "#2c2339",
    "m3surfaceContainerHighest": "#372d46",
    "m3onSurface": "#f6ecdf",
    "m3onBackground": "#f6ecdf",
    "m3onSurfaceVariant": "#cbbfd3",
    "m3outline": "#8f8099",
    "m3primary": "#d7b8ff",
    "m3onPrimary": "#3d1f63",
    "m3primaryContainer": "#55377f",
    "m3onPrimaryContainer": "#f0e2ff",
    "m3tertiary": "#ffb0cf",
    "bar": "#e6171127",
    "panel": "#f2171127",
    "widget": "#2c2339",
    "widgetActive": "#3a2f48",
    "widgetOutline": "#0d0812",
    "widgetOutlineSeparate": "#0d0812",
    "keycapShadow": "#99000000",
  },
    pastel: {
    "m3background": "#161a2b",
    "m3surface": "#161a2b",
    "m3surfaceContainerLow": "#1d2238",
    "m3surfaceContainer": "#242a45",
    "m3surfaceContainerHigh": "#2d3554",
    "m3surfaceContainerHighest": "#384165",
    "m3onSurface": "#fff4fa",
    "m3onBackground": "#fff4fa",
    "m3onSurfaceVariant": "#c9cde3",
    "m3outline": "#7c84a8",
    "m3primary": "#f6a8d4",
    "m3onPrimary": "#3d1030",
    "m3primaryContainer": "#5c2a4f",
    "m3onPrimaryContainer": "#ffe0f1",
    "m3tertiary": "#8fd8ff",
    "m3secondary": "#b8f2dc",
    "bar": "#e6161a2b",
    "panel": "#f2161a2b",
    "widget": "#2d3554",
    "widgetActive": "#384165",
    "widgetOutline": "#0b0d18",
    "widgetOutlineSeparate": "#0b0d18",
    "keycapShadow": "#99000000",
  },
  })

  readonly property var names: ["blend", "shadcn", "plum", "pastel"]

  readonly property var titles: ({
    blend: "Blend",
    shadcn: "Shadcn",
    plum: "End-4 plum",
    pastel: "Pastel",
  })

  function palette(name: string): var {
    const over = root.presets[name] ?? {};
    return Object.assign({}, root.base, over);
  }

  function title(name: string): string {
    return root.titles[name] ?? "Blend";
  }

  function nextName(current: string): string {
    const i = root.names.indexOf(current);
    return root.names[(i + 1) % root.names.length];
  }
}
