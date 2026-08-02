pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root
  property string filePath: Directories.shellConfigPath
  property alias options: configOptionsJsonAdapter
  property bool ready: false
  property int readWriteDelay: 50 // milliseconds
  property bool blockWrites: false

  property var preferredMonitor: {
    const screens = [...Quickshell.screens].filter(e => !e.name.startsWith("FALLBACK"));
    if (screens.length == 1)
      return screens[0];
    return [...Quickshell.screens].find(e => e.name == "HDMI-A-1");
  }
  property bool showSidebar: false
  property bool doNotDisturb: false

  readonly property int notificationExpireTimeout: 5000
  readonly property int notificationIconSize: 48
  readonly property int notificationWidth: 360
  readonly property int hoverTimeoutMs: 500

  readonly property int barHeight: 32
  readonly property int osdWidth: 200

  readonly property int textSize: 9
  readonly property int iconSize: 14
  readonly property real spacing: padding * 3
  readonly property int radius: padding * 4
  readonly property int padding: 4
  readonly property real roundingPower: 2.5

  readonly property int blurMax: 16
  readonly property real shadowOpacity: 0.1
  readonly property int shadowVerticalOffset: 2
  readonly property bool shadowEnabled: true

  readonly property int osdTimeout: 1000

  function setNestedValue(nestedKey, value) {
    let keys = nestedKey.split(".");
    let obj = root.options;
    let parents = [obj];

    // Traverse and collect parent objects
    for (let i = 0; i < keys.length - 1; ++i) {
      if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
        obj[keys[i]] = {};
      }
      obj = obj[keys[i]];
      parents.push(obj);
    }

    // Convert value to correct type using JSON.parse when safe
    let convertedValue = value;
    if (typeof value === "string") {
      let trimmed = value.trim();
      if (trimmed === "true" || trimmed === "false" || !isNaN(Number(trimmed))) {
        try {
          convertedValue = JSON.parse(trimmed);
        } catch (e) {
          convertedValue = value;
        }
      }
    }

    obj[keys[keys.length - 1]] = convertedValue;
  }

  Timer {
    id: fileReloadTimer
    interval: root.readWriteDelay
    repeat: false
    onTriggered: {
      configFileView.reload();
    }
  }

  Timer {
    id: fileWriteTimer
    interval: root.readWriteDelay
    repeat: false
    onTriggered: {
      configFileView.writeAdapter();
    }
  }

  FileView {
    id: configFileView
    path: root.filePath
    watchChanges: true
    blockWrites: root.blockWrites
    onFileChanged: fileReloadTimer.restart()
    onAdapterUpdated: fileWriteTimer.restart()
    onLoaded: root.ready = true
    onLoadFailed: error => {
      if (error == FileViewError.FileNotFound) {
        writeAdapter();
      }
    }

    JsonAdapter {
      id: configOptionsJsonAdapter

      property JsonObject wallpaper: JsonObject {
        property string path: Directories.pictures + "/wallpapers/current.png"
      }

      property JsonObject bar: JsonObject {
        property JsonObject autoHide: JsonObject {
          property bool enable: false
          property int hoverRegionWidth: 2
          property bool pushWindows: false
          property JsonObject showWhenPressingSuper: JsonObject {
            property bool enable: true
            property int delay: 140
          }
        }
        property bool bottom: false // Instead of top
        property int cornerStyle: 0 // 0: Hug | 1: Float | 2: Plain rectangle
        property bool floatStyleShadow: true // Show shadow behind bar when cornerStyle == 1 (Float)
        property bool borderless: false // true for no grouping of items
        property string topLeftIcon: "spark" // Options: "distro" or any icon name in ~/.config/quickshell/ii/assets/icons
        property bool showBackground: true
        property bool verbose: true
        property bool vertical: false
        property JsonObject resources: JsonObject {
          property bool alwaysShowSwap: true
          property bool alwaysShowCpu: true
          property int memoryWarningThreshold: 95
          property int swapWarningThreshold: 85
          property int cpuWarningThreshold: 90
        }
        property list<string> screenList: [] // List of names, like "eDP-1", find out with 'hyprctl monitors' command
        property JsonObject utilButtons: JsonObject {
          property bool showScreenSnip: true
          property bool showColorPicker: false
          property bool showMicToggle: false
          property bool showKeyboardToggle: true
          property bool showDarkModeToggle: true
          property bool showPerformanceProfileToggle: false
          property bool showScreenRecord: false
        }
        property JsonObject workspaces: JsonObject {
          property bool monochromeIcons: true
          property int shown: 10
          property bool showAppIcons: true
          property bool alwaysShowNumbers: false
          property int showNumberDelay: 300 // milliseconds
          property list<string> numberMap: ["1", "2"] // Characters to show instead of numbers on workspace indicator
          property bool useNerdFont: false
        }
        property JsonObject weather: JsonObject {
          property bool enable: false
          property bool enableGPS: true // gps based location
          property string city: "" // When 'enableGPS' is false
          property bool useUSCS: false // Instead of metric (SI) units
          property int fetchInterval: 10 // minutes
        }
        property JsonObject indicators: JsonObject {
          property JsonObject notifications: JsonObject {
            property bool showUnreadCount: false
          }
        }
        property JsonObject tooltips: JsonObject {
          property bool clickToShow: false
        }
      }
    }
  }
}
