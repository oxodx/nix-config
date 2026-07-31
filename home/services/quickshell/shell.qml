//@ pragma UseQApplication
//@ pragma DropExpensiveFonts
import Quickshell
import qs.modules.bar
import qs.modules.notifications
import qs.modules.osd
import qs.modules.sidebar

ShellRoot {
  Bar {}
  NotificationOverlay {}
  OSD {}
  Sidebar {}
}
