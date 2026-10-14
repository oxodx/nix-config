import QtQuick
import QtQuick.Effects
import qs.components
import qs.shaders as Shaders

Item {
  id: root
  property list<Item> notifications: []
  property list<Item> heightStack: []

  property alias stack: stack
  property alias topNotification: stack.topNotification

  function addNotificationInert(notification: TrackedNotification): Item {
    const harness = stack._harnessComponent.createObject(stack, {
      backer: notification,
      view: root
    });

    harness.contentItem = notification.renderComponent.createObject(harness);

    notifications = [...notifications, harness];
    heightStack = [harness, ...heightStack];

    return harness;
  }

  function addNotification(notification: TrackedNotification) {
    const harness = root.addNotificationInert(notification);
    harness.playEntry(0);
  }

  function dismissAll() {
    let delay = 0;

    for (const notification of root.notifications) {
      if (!notification.canDismiss)
        continue;
      notification.playDismiss(delay);
      notification.dismissed();
      delay += 0.025;
    }
  }

  function discardAll() {
    let delay = 0;

    for (const notification of root.notifications) {
      if (!notification.canDismiss)
        continue;
      notification.playDismiss(delay);
      notification.discarded();
      delay += 0.025;
    }
  }

  function addSet(notifications: list<TrackedNotification>) {
    let delay = 0;

    for (const notification of notifications) {
      if (notification.visualizer) {
        notification.visualizer.playReturn(delay);
      } else {
        const harness = root.addNotificationInert(notification);
        harness.playEntry(delay);
      }

      delay += 0.025;
    }
  }

  Item {
    id: compositedStack
    anchors.fill: parent

    layer.enabled: stack.topNotification != null
    layer.effect: Shaders.MaskedOverlay {
      overlayItem: overlaySource
      overlaySize: Qt.size(overlaySource.width, overlaySource.height)
      overlayPos: Qt.point(stack.x + (stack.topNotification?.x ?? 0) + (stack.topNotification?.displayContainer.x ?? 0), stack.y + (stack.topNotification?.y ?? 0) + (stack.topNotification?.displayContainer.y ?? 0))
    }

    ShaderEffectSource {
      id: overlaySource
      sourceItem: stack.topNotification?.displayContainer ?? null
      hideSource: false
      live: true
      recursive: true
      smooth: true
      width: sourceItem?.width ?? 0
      height: sourceItem?.height ?? 0
      opacity: 0
    }

    ZHVStack {
      id: stack

      property Item topNotification: {
        return root.heightStack[0] ?? null;
      }

      property Component _harnessComponent: FlickableNotification {
        id: notification
        required property TrackedNotification backer

        // Dismiss once the card itself has left the screen. The sidebar used
        // -stack.x here, which makes a top-right notification traverse almost
        // the entire monitor before it is destroyed.
        edgeXOffset: 0

        onDismissed: backer.handleDismiss()
        onDiscarded: backer.handleDiscard()

        onLeftViewBounds: {
          root.notifications = root.notifications.filter(n => n != this);
          root.heightStack = root.heightStack.filter(n => n != this);
          this.destroy();
        }

        onStartedFlick: {
          root.heightStack = [this, ...root.heightStack.filter(n => n != this)];
        }

        Component.onCompleted: backer.visualizer = this

        Connections {
          target: backer

          function onDismiss() {
            notification.playDismiss(0);
            notification.dismissed();
          }

          function onDiscard() {
            notification.playDismiss(0);
            notification.discarded();
          }
        }
      }
    }
  }
}
