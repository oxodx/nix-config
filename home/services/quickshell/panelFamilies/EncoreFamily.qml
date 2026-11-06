import QtQuick
import Quickshell
import qs.modules.encore

// System surfaces remain shared; every everyday desktop surface belongs to Encore.
import qs.modules.ii.overlay
import qs.modules.ii.mediaControls
import qs.modules.ii.sidebarLeft
import qs.modules.ii.polkit
import qs.modules.ii.regionSelector
import qs.modules.ii.sessionScreen
import qs.modules.ii.cheatsheet
import qs.modules.ii.onScreenKeyboard
import qs.modules.ii.screenTranslator
import qs.modules.ii.wallpaperSelector

Scope {
    PanelLoader {
        component: EncoreDesktop {}
    }
    PanelLoader {
        component: EncoreBar {}
    }
    PanelLoader { component: EncoreOverview {} }
    PanelLoader {
        component: EncoreLauncher {}
    }
    PanelLoader {
        component: EncoreControls {}
    }
    PanelLoader {
        component: EncoreNotifications {}
    }
    PanelLoader {
        component: EncoreOsd {}
    }
    PanelLoader {
        component: EncoreShortcuts {}
    }

    PanelLoader {
        component: EncoreLock {}
    }
    PanelLoader { component: Overlay {} }
    PanelLoader { component: MediaControls {} }
    PanelLoader { component: SidebarLeft {} }
    PanelLoader {
        component: Polkit {}
    }
    PanelLoader {
        component: RegionSelector {}
    }
    PanelLoader {
        component: SessionScreen {}
    }
    PanelLoader {
        component: Cheatsheet {}
    }
    PanelLoader {
        component: OnScreenKeyboard {}
    }
    PanelLoader {
        component: ScreenTranslator {}
    }
    PanelLoader {
        component: WallpaperSelector {}
    }
}
