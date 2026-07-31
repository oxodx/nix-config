//@ pragma UseQApplication
//@ pragma DropExpensiveFonts
import Quickshell
import qs.bar
import qs.notifications
import qs.osd
import qs.sidebar

ShellRoot {
  Bar {}
  NotificationOverlay {}
  OSD {}
  Sidebar {}
}
