import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.services
import qs.theme
import qs.modules.editMode

PanelWindow {
  id: win

  readonly property bool wallpaperEnabled: SettingsService.flag("wallpaper.enabled")
  onWallpaperEnabledChanged: {
    if (wallpaperEnabled)
      restoreWallpaperResources();
    else
      releaseWallpaperResources();
  }
  required property var modelData
  screen: modelData

  WlrLayershell.layer: WlrLayer.Background
  WlrLayershell.namespace: "oxod-wallpaper"
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  exclusionMode: ExclusionMode.Ignore
  color: "transparent"

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  readonly property real outputPixelRatio: {
    if (!win.screen)
      return 1;
    const logicalW = Math.max(1, width);
    const logicalH = Math.max(1, height);
    const geometry = win.screen.geometry;
    const geometryRatio = geometry ? Math.max(geometry.width / logicalW, geometry.height / logicalH) : 1;
    return Math.max(1, Math.min(win.screen.devicePixelRatio || 1, geometryRatio || 1));
  }
  readonly property size sourceSize: Qt.size(Math.ceil(width * win.parallaxZoom * win.outputPixelRatio), Math.ceil(height * win.parallaxZoom * win.outputPixelRatio))

  readonly property bool parallaxOn: SettingsService.flag("wallpaper.parallax")
  readonly property real parallaxZoom: parallaxOn ? 1 + SettingsService.get("wallpaper.parallaxAmount") / 100 : 1
  readonly property var hyprMonitor: win.screen ? Hyprland.monitorFor(win.screen) : null
  readonly property int workspaceId: hyprMonitor && hyprMonitor.activeWorkspace ? hyprMonitor.activeWorkspace.id : 1
  readonly property int workspaceCount: Math.max(2, SettingsService.get("wallpaper.parallaxWorkspaces"))
  readonly property real parallaxFraction: Math.max(0, Math.min(1, (win.workspaceId - 1) / (win.workspaceCount - 1)))

  readonly property var activeWs: win.hyprMonitor ? win.hyprMonitor.activeWorkspace : null
  readonly property var wsInfo: win.activeWs && win.activeWs.lastIpcObject ? win.activeWs.lastIpcObject : null
  readonly property bool fullscreenCovered: !!(win.wsInfo && win.wsInfo.hasfullscreen)
  readonly property bool hasWindows: !!(win.wsInfo && win.wsInfo.windows > 0)
  readonly property string pauseMode: SettingsService.get("wallpaper.videoPause")
  readonly property bool focusReduced: FocusService.effectsReducedOn(win.screenName)
  readonly property bool videoCovered: win.focusReduced || (win.pauseMode === "windows" ? (win.hasWindows || win.fullscreenCovered) : win.pauseMode === "never" ? false : win.fullscreenCovered)

  property bool mpvpaperFailed: false
  readonly property bool useMpvpaper: SettingsService.flag("wallpaper.mpvpaper") && !win.mpvpaperFailed
  readonly property bool restartOnPause: SettingsService.get("wallpaper.videoResume") === "restart"
  readonly property bool videoEditing: EditMode.editing(win.screenName)
  readonly property bool videoPausedBase: LockService.locked || win.videoCovered
  readonly property bool videoPaused: win.videoPausedBase || win.videoEditing

  Connections {
    target: Hyprland

    function onRawEvent(event) {
      if (event.name === "fullscreen" || event.name === "workspace" || event.name === "workspacev2" || event.name === "focusedmon" || event.name === "openwindow" || event.name === "closewindow" || event.name === "movewindow" || event.name === "movewindowv2")
        fullscreenRefresh.restart();
    }
  }

  Timer {
    id: fullscreenRefresh
    interval: 150
    onTriggered: {
      if (videoLayer.active)
        Hyprland.refreshWorkspaces();
    }
  }

  readonly property string wantedPath: WallpaperService.pathFor(win.screenName)
  readonly property string wantedImage: WallpaperService.imageFor(win.wantedPath)
  property string shownImage: ""
  property real progress: 1.0
  readonly property bool transitioning: win.previousSlot !== null

  property Item previousSlot: null
  property Item currentSlot: null

  Component {
    id: textureSlotComponent
    WallpaperTextureSlot {}
  }

  function createSlot(image) {
    const obj = textureSlotComponent.createObject(pic, {
      sourceSize: win.sourceSize,
      source: image ? ("file://" + image) : ""
    });
    obj.sourceSize = Qt.binding(() => win.sourceSize);
    obj.statusChanged.connect(() => {
      const done = obj.status === Image.Ready || obj.status === Image.Error;
      if (done)
        obj.sourceSize = Qt.size(obj.sourceSize.width, obj.sourceSize.height);
      if (obj === win.currentSlot && done)
        win.slotReady();
    });
    win.bindRole(obj);
    return obj;
  }

  // Crossfade: the outgoing picture stays opaque underneath while the incoming
  // one fades in over it as progress runs from 0 to 1.
  function bindRole(obj) {
    obj.visible = Qt.binding(() => obj === win.currentSlot || obj === win.previousSlot);
    obj.opacity = Qt.binding(() => obj === win.currentSlot && win.previousSlot !== null ? win.progress : 1.0);
  }

  property Item freshSlot: null

  function dropFresh() {
    freshTimer.stop();
    if (win.freshSlot) {
      win.freshSlot.destroy();
      win.freshSlot = null;
    }
  }

  function releaseWallpaperResources() {
    fullscreenRefresh.stop();
    resizeTimer.stop();
    freshTimer.stop();
    readyTimeout.stop();
    warmup.stop();
    blendAnim.stop();

    dropFresh();

    if (win.previousSlot) {
      win.previousSlot.destroy();
      win.previousSlot = null;
    }

    if (win.currentSlot) {
      win.currentSlot.destroy();
      win.currentSlot = null;
    }

    win.progress = 1.0;
    win.shownImage = "";
  }

  function restoreWallpaperResources() {
    if (!win.wallpaperEnabled)
      return;

    const image = WallpaperService.imageFor(WallpaperService.pathFor(win.screenName));

    if (image === "")
      return;

    win.shownImage = image;
    win.currentSlot = win.createSlot(image);
  }

  function redecode() {
    const cur = win.currentSlot;
    if (!cur || win.shownImage === "" || cur.status === Image.Error)
      return;
    if (win.previousSlot || cur.status !== Image.Ready || win.freshSlot) {
      resizeTimer.restart();
      return;
    }
    const want = win.sourceSize;
    if (want.width <= 0 || want.height <= 0)
      return;
    if (cur.sourceSize.width >= want.width && cur.sourceSize.height >= want.height)
      return;
    const obj = textureSlotComponent.createObject(pic, {
      sourceSize: want,
      source: "file://" + win.shownImage,
      visible: false
    });
    win.freshSlot = obj;
    obj.statusChanged.connect(() => {
      if (obj !== win.freshSlot)
        return;
      if (obj.status === Image.Error) {
        win.dropFresh();
      } else if (obj.status === Image.Ready) {
        obj.visible = true;
        freshTimer.restart();
      }
    });
  }

  onSourceSizeChanged: resizeTimer.restart()

  Timer {
    id: resizeTimer
    interval: 250
    onTriggered: win.redecode()
  }

  Timer {
    id: freshTimer
    interval: 100
    onTriggered: {
      const f = win.freshSlot;
      const old = win.currentSlot;
      if (!f)
        return;
      if (!old || win.previousSlot) {
        win.dropFresh();
        return;
      }
      win.freshSlot = null;
      win.currentSlot = f;
      win.bindRole(f);
      old.destroy();
      // The size may have changed again while the copy was decoding.
      resizeTimer.restart();
    }
  }

  function swapTo(image) {
    if (win.currentSlot && win.currentSlot.status !== Image.Ready) {
      // Switched again before the last wallpaper finished
      // decoding, so it was never on screen. Drop it; what is
      // actually showing is the outgoing slot (if there is one),
      // and that stays the thing we blend out of. Fading out of
      // the unfinished slot would be fading out of black.
      win.currentSlot.destroy();
      win.currentSlot = null;
      win.currentSlot = win.createSlot(image);
      return;
    }
    if (win.previousSlot) {
      // A switch landed mid-transition (fast picker navigation,
      // a short slideshow tick) — there's already an outgoing
      // slot nobody finished blending out. destroy() it now
      // instead of leaking it forward.
      win.previousSlot.destroy();
    }
    win.previousSlot = win.currentSlot;
    win.currentSlot = win.createSlot(image);
  }

  function finishLocalTransition() {
    if (win.previousSlot) {
      win.previousSlot.destroy();
      win.previousSlot = null;
    }
    win.progress = 1.0;
  }

  // This monitor's wallpaper changed.
  function show(image) {
    if (!win.wallpaperEnabled)
      return;
    if (image === "" || image === win.shownImage)
      return;
    win.shownImage = image;
    win.dropFresh();
    // A new switch cancels a blend that was waiting or running.
    // (stop() doesn't fire onFinished, so this can't end the
    // transition by accident.)
    blendAnim.stop();
    warmup.stop();
    win.progress = 0.0;
    win.swapTo(image);
    // Nothing more happens here: the blend starts from slotReady()
    // once the incoming wallpaper has decoded. Until then the
    // ShaderEffect sits at progress 0, which shows the outgoing
    // wallpaper as-is (and with no outgoing slot the incoming one
    // just appears when it is ready).
    readyTimeout.restart();
  }

  onWantedImageChanged: win.show(win.wantedImage)

  function slotReady() {
    readyTimeout.stop();
    // One short beat so the first texture upload / mipmap pass
    // of the new wallpaper lands while progress is still 0
    // instead of stuttering the first frames of the wipe.
    warmup.restart();
  }

  readonly property string screenName: win.modelData ? win.modelData.name : ""

  Component.onCompleted: {
    if (win.wallpaperEnabled && win.wantedImage !== "") {
      win.shownImage = win.wantedImage;
      win.currentSlot = win.createSlot(win.wantedImage);
    }
  }

  // A file that never reports (corrupt, unreadable) mustn't leave the
  // switch hanging forever.
  Timer {
    id: readyTimeout
    interval: 5000
    onTriggered: win.slotReady()
  }

  Timer {
    id: warmup
    interval: 50
    onTriggered: {
      // No outgoing picture (the first wallpaper): nothing to blend from.
      if (win.previousSlot)
        blendAnim.restart();
    }
  }

  NumberAnimation {
    id: blendAnim
    target: win
    property: "progress"
    from: 0.0
    to: 1.0
    duration: 900
    easing.type: Easing.OutCubic
    onFinished: win.finishLocalTransition()
  }

  // This monitor's UI scale (scale.json / services/ShellScale.qml), for the
  // sizes Edit Desktop draws in design pixels.
  readonly property real uiScale: ShellScale.forScreen(win.screen)

  // ===== Edit Desktop =====
  Loader {
    anchors.fill: parent
    active: EditMode.editing(win.screenName)

    sourceComponent: EditBackdrop {
      screenObj: win.screen
      uiScale: win.uiScale
    }
  }

  // The picture itself. Out of edit mode it is the whole window, exactly
  // as before; in it, it is scaled about the top-left corner and moved to
  // where the card sits (the same numbers the widget windows use, see
  // EditStage.qml), and the ring in EditFrame hides its square corners.
  Item {
    id: stage
    visible: win.wallpaperEnabled
    width: parent.width
    height: parent.height
    x: EditMode.xFor(win.screenName, win.width, win.height, win.uiScale)
    y: EditMode.yFor(win.screenName, win.width, win.height, win.uiScale)
    scale: EditMode.scaleFor(win.screenName, win.width, win.height, win.uiScale)
    transformOrigin: Item.TopLeft
    // Parallax draws the picture past the window's edge: cut it off there
    // (in Edit Desktop that is the card's edge).
    clip: win.parallaxOn

    // The pictures and the transition, as one thing that parallax can slide.
    // (Without parallax it is exactly the stage.)
    Item {
      id: pic
      width: stage.width * win.parallaxZoom
      height: stage.height * win.parallaxZoom
      x: -(width - stage.width) * win.parallaxFraction
      y: -(height - stage.height) / 2

      Behavior on x {
        enabled: win.parallaxOn
        NumberAnimation {
          duration: 480
          easing.type: Easing.OutCubic
        }
      }

      // Fallback under the pictures, visible until one has loaded.
      Rectangle {
        anchors.fill: parent
        gradient: Gradient {
          GradientStop {
            position: 0.0
            color: Appearance.colors.m3surfaceContainerHigh
          }
          GradientStop {
            position: 1.0
            color: Appearance.colors.m3surfaceContainerLowest
          }
        }
      }

      // The last frame of the video, saved by mpvpaper when Edit Desktop opened. It shrinks
      // with the card. It stays up a moment after editing ends, until mpvpaper is back.
      Image {
        id: frozen
        anchors.fill: parent
        sourceSize: win.sourceSize
        z: 4
        visible: source !== "" && !win.transitioning
        cache: false
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
      }

      Timer {
        id: hideFrozen
        interval: 900
        onTriggered: frozen.source = ""
      }

      Connections {
        target: win

        function onVideoEditingChanged() {
          if (win.videoEditing)
            hideFrozen.stop();
          else
            hideFrozen.restart();
        }

        function onWantedPathChanged() {
          hideFrozen.stop();
          frozen.source = "";
        }
      }

      // The video, over the first-frame picture once the transition is
      // done. Not while a transition runs (it blends pictures). It keeps
      // playing through Edit Desktop (the card just shows it smaller):
      // unloading it for the mode stopped the video and swapped it for
      // its first frame at the moment the mode started. Built only for a
      // video wallpaper.
      Loader {
        id: videoLayer
        anchors.fill: parent
        z: 5
        active: win.wallpaperEnabled && WallpaperService.videoFor(win.screenName) && !win.transitioning && win.currentSlot !== null && win.currentSlot.status === Image.Ready
        source: active ? Qt.resolvedUrl(win.useMpvpaper ? "MpvpaperWallpaper.qml" : "VideoWallpaper.qml") : ""
        onLoaded: {
          item.hidden = win.videoEditing;
          item.screenName = win.screenName;
          item.restartOnPause = win.restartOnPause;
          item.path = win.wantedPath;
        }
        onStatusChanged: {
          if (status === Loader.Error)
            console.warn("WallpaperLayer: video wallpapers need qt6-multimedia (and a backend such as qt6-multimedia-ffmpeg); showing the first frame instead");
        }

        Binding {
          target: videoLayer.item
          property: "path"
          value: win.wantedPath
          when: videoLayer.item !== null
        }

        Connections {
          target: videoLayer.item
          ignoreUnknownSignals: true

          function onFailed() {
            win.mpvpaperFailed = true;
          }

          function onFrameReady(path) {
            hideFrozen.stop();
            frozen.source = "file://" + path;
          }
        }

        Binding {
          target: videoLayer.item
          property: "restartOnPause"
          value: win.restartOnPause
          when: videoLayer.item !== null
        }

        Binding {
          target: videoLayer.item
          property: "hidden"
          value: win.videoEditing
          when: videoLayer.item !== null
        }

        Binding {
          target: videoLayer.item
          property: "paused"
          value: win.useMpvpaper ? win.videoPausedBase : win.videoPaused
          when: videoLayer.item !== null
        }
      }

    } // pic
  }

  // Over the picture: the card's frame.
  Loader {
    anchors.fill: parent
    active: EditMode.editing(win.screenName)

    sourceComponent: EditFrame {
      screenObj: win.screen
      uiScale: win.uiScale
    }
  }

  // Edit Desktop: a click on the bare card (nothing but wallpaper under it)
  // stops editing the selected widget. Widgets, the bar and the dock are
  // all above this layer, so only a click that really lands on the
  // wallpaper gets here.
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.LeftButton
    enabled: EditMode.active
    onClicked: EditMode.select("")
  }

  // Right-click on the bare desktop: the Edit Desktop menu (DesktopMenu.qml).
  // Windows, the bar and the widgets are all above this layer, so only a
  // click that really lands on the wallpaper gets here.
  MouseArea {
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    enabled: !EditMode.active
    onClicked: mouse => EditMode.openMenu(win.screenName, mouse.x, mouse.y)
  }
}
