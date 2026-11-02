pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  // Whether a screen should drop its expensive effects (video, blends) because
  // a focused window is covering it. No focus-mode integration exists yet.
  function effectsReducedOn(screenName: string): bool {
    return false;
  }
}
