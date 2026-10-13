import QtQuick
import QtQuick.Controls
import Quickshell
import qs

Scope {
  id: root
  required property var bar

  property TooltipItem activeTooltip: null
  property TooltipItem activeMenu: null
  readonly property TooltipItem activeItem: activeMenu ?? activeTooltip
  property TooltipItem lastActiveItem: null
  readonly property TooltipItem shownItem: activeItem ?? lastActiveItem
  property Item tooltipItem: null
  property real scaleMul: shownItem && shownItem.targetVisible ? 1 : 0
  property bool popupHovered: false
  property bool popupWasHovered: false

  function closeActiveMenu() {
    const menu = activeMenu;
    if (!menu)
      return;

    menuLeaveTimer.stop();
    activeMenu = null;
    popupWasHovered = false;
    menu.targetVisible = false;
  }

  function setItem(item: TooltipItem) {
    // Detail menus own the popup until explicitly closed. Hover hints from
    // controls inside them must not replace (and therefore hide) the menu.
    if (activeMenu && !item.isMenu && item !== activeMenu) {
      activeTooltip = item;
      return;
    }

    const previous = lastActiveItem;
    if (previous && previous !== item)
      previous.targetVisible = false;

    if (item.isMenu) {
      activeMenu = item;
      popupWasHovered = false;
    } else
      activeTooltip = item;

    hangTimer.stop();
    item.targetVisible = true;
    lastActiveItem = item;
    if (tooltipItem)
      item.parent = tooltipItem;
  }

  function removeItem(item: TooltipItem) {
    if (!item)
      return;
    if (item.isMenu && activeMenu === item) {
      activeMenu = null;

      // A hover tooltip may have remained logically active while the menu was
      // covering it. Restore it explicitly instead of showing its hidden,
      // detached content when the menu closes.
      if (activeTooltip && activeTooltip.show) {
        item.targetVisible = false;
        lastActiveItem = activeTooltip;
        activeTooltip.targetVisible = true;
        if (tooltipItem)
          activeTooltip.parent = tooltipItem;
        return;
      }
    } else if (!item.isMenu && activeTooltip === item) {
      activeTooltip = null;

      // Leaving the button also removes its small hover hint. If a detail menu
      // is open, that event belongs only to the hint and must never start the
      // shared timer that would close the menu.
      if (activeMenu) {
        item.targetVisible = false;
        return;
      }
    }

    if (item.hangTime > 0)
      hangTimer.restart();
    else
      hideLast();
  }

  function hideLast() {
    if (lastActiveItem?.hoverable && popupHovered)
      return;
    if (lastActiveItem)
      lastActiveItem.targetVisible = false;
  }

  function onHidden(item: TooltipItem) {
    item.parent = null;
    if (item === lastActiveItem)
      lastActiveItem = null;
  }

  onShownItemChanged: {
    if (shownItem && tooltipItem)
      shownItem.parent = tooltipItem;
  }

  Timer {
    id: hangTimer
    interval: root.lastActiveItem?.hangTime ?? 0
    onTriggered: root.hideLast()
  }

  // Once the pointer has reached a detail popup, leaving it means the user is
  // done with it. The short delay keeps movement across rounded edges smooth;
  // clicking elsewhere also moves outside and closes the popup immediately.
  Timer {
    id: menuLeaveTimer
    interval: 140
    onTriggered: {
      if (root.activeMenu && !root.popupHovered)
        root.closeActiveMenu();
    }
  }

  LazyLoader {
    activeAsync: root.shownItem != null

    PopupWindow {
      id: popup
      visible: true
      color: "transparent"

      anchor {
        window: root.bar
        rect.x: {
          if (!root.shownItem)
            return 0;
          const center = root.bar.contentItem.mapFromItem(root.shownItem.owner, root.shownItem.owner.width / 2, 0).x;
          return Math.max(4, Math.min(root.bar.width - popup.implicitWidth - 4, center - popup.implicitWidth / 2));
        }
        rect.y: root.bar.height + 4
        adjustment: PopupAdjustment.None
      }

      implicitWidth: Math.max(1, root.shownItem?.implicitWidth ?? 1)
      implicitHeight: Math.max(1, root.shownItem?.implicitHeight ?? 1)

      mask: Region {
        item: (root.shownItem?.hoverable ?? false) ? host : null
      }

      Control {
        id: host
        anchors.fill: parent
        padding: 0
        palette.windowText: "#f4f6fb"
        palette.text: "#f4f6fb"
        palette.buttonText: "#f4f6fb"
        palette.base: "#20232d"
        palette.window: "#20232d"

        HoverHandler {
          onHoveredChanged: {
            root.popupHovered = hovered;
            if (hovered) {
              menuLeaveTimer.stop();
              if (root.activeMenu)
                root.popupWasHovered = true;
            } else if (root.activeMenu && root.popupWasHovered) {
              menuLeaveTimer.restart();
            } else if (root.shownItem && !root.shownItem.show) {
              hangTimer.restart();
            }
          }
        }

        Component.onCompleted: {
          root.tooltipItem = popupContent;
          if (root.shownItem)
            root.shownItem.parent = popupContent;
        }

        background: Rectangle {
          color: root.shownItem?.customBackground ? "transparent" : "#f220232d"
          border.color: root.shownItem?.customBackground ? "transparent" : "#40ffffff"
          border.width: 1
          radius: root.shownItem?.customBackground ? 0 : 8
        }

        contentItem: Item {
          id: popupContent
        }
      }
    }
  }
}
