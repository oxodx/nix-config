pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  // Per-monitor UI scale used by Edit Desktop to size its design pixels.
  // There is no scale setting yet, so every monitor draws at 1:1.
  function forScreen(screen: var): real {
    return 1.0;
  }
}
