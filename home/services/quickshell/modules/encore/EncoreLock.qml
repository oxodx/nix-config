import QtQuick
import qs.modules.common.panels.lock

// Authentication, session-lock protocol and keyring handling stay shared.
// Encore supplies its own opaque surface instead of relying on ii's desktop.
LockScreen {
    id: root
    lockSurface: EncoreLockSurface { context: root.context }
}
