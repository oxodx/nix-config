# Encore

Encore is a third panel family, alongside `ii` and `waffle`. It has its own desktop, side rails, launcher, controls, notifications, OSD, palette and primitives. SekaiPop inspired the playful hardware and stationery aesthetic; no SekaiPop source or assets are copied.

## Select it

After reloading the updated shell, choose **Settings → Interface → Shell family → Encore**, or run:

```sh
qs ipc call panelFamily set encore
```

`qs ipc call panelFamily cycle` cycles `ii → waffle → encore`. Fresh configurations default to Encore; existing configurations keep their saved family. Switching families closes transient panels.

The saved config is `~/.config/illogical-impulse/config.json`:

```json
{
  "panelFamily": "encore",
  "encore": {
    "darkMode": false,
    "desktopWidgets": true
  }
}
```

These options are available in Settings. The moon button in the phone changes Encore's palette independently of the other families.

## Everyday surfaces

- Narrow deep-purple side rails on each monitor: workspace keys and status on the left; search, controls, clipboard, notifications, settings and lock on the right. Scrolling the workspace rail changes workspace. The system tray is available in the control phone (right-click for menus).
- Phone launcher: apps, existing advanced search providers, clipboard, emoji and calculations. Arrow keys select, Enter runs, Escape or the scrim dismisses. Tap `Super` or use `Super+Alt+D`; the existing `search` IPC endpoint continues to work.
- Phone controls: Wi-Fi, Bluetooth, notification silence, idle inhibitor, volume, brightness, network settings, night light, media and notification history with actions. Header and footer stay available while the middle scrolls.
- Scrapbook desktop over the configured wallpaper: outlined purple frame, striped tape, slightly crooked card stacks, Pride ribbons, heart/star stickers, a month calendar, clock, to-do list, palette swatches and media. A sticky note is editable and persists as `encore.note`; the to-do widget uses the existing Todo service. On smaller displays secondary cards are hidden to avoid overlap. Video wallpapers use the existing thumbnail.
- Notification cards and volume/brightness OSD use Encore's own styling.

Encore uses a purple/lilac palette with pink accents and small inclusive Pride ribbons. This is confined to Encore.

Encore has an opaque lock background with the configured wallpaper (or bundled wallpaper if unset), a purple fallback while loading, and its own clock. Its taped keycap clock and purple password card match the desktop. It reuses the shared password/fingerprint authentication context and session-lock protocol; it does not switch workspaces to manufacture a background. Video wallpapers use their thumbnail.

Existing services supply data and device control. Authentication, session actions, screenshot/region selection, cheatsheet, on-screen keyboard, translation and wallpaper selection reuse the existing system surfaces. Encore does not load either family's bar, dock, overview or sidebars.

## Hyprland shortcuts

The Nix Hyprland bindings use illogical-impulse's upstream shortcut layout and target the active family's registered Quickshell globals. `ShellShortcuts.qml` routes controls to Waffle's action center or the ii/Encore right panel, and switches Encore's own palette without touching ii's theme. No Pop styling is applied to shared widgets or ii.

| Keys | Action |
| --- | --- |
| Tap Super / Super+Alt+D | Launcher |
| Super+A / Super+B / Super+O | Assistant |
| Super+D / Super+F | Maximize / fullscreen |
| Super+N | Quick controls |
| Super+Tab | Workspace overview |
| Super+I | Settings |
| Super+/ | Cheatsheet |
| Super+K | On-screen keyboard |
| Super+V / Super+. | Clipboard / emoji |
| Super+L / Ctrl+Alt+L | Lock |
| Super+Escape | Session menu |
| Ctrl+Super+T | Wallpaper picker |
| Ctrl+Alt+Super+T | Random wallpaper |
| Ctrl+Shift+Super+D | Light/dark palette |
| Ctrl+Super+R | Reload shell |
| Ctrl+Super+P / Ctrl+Shift+Super+P | Cycle shell family |
| Shift+Super+S | Screen snip |
| Shift+Super+X | OCR |
| Shift+Super+A | Image search |
| Shift+Super+R | Record region |
| Ctrl+Shift+Super+S | Record with audio |

Volume/mute keys use guarded shell audio actions; brightness keys use the shared brightness service. Both feed each family's OSD. Media playback keys retain `playerctl`.

Upstream defaults now win conflicting chords: `Super+Shift+arrows` move windows, `Ctrl+Super+Left/Right` switch workspaces, `Super+Minus/Equal` zoom, `Super+W` opens the browser, `Super+C` opens the code editor, and `Super+X` opens the text editor. `Super+Shift+L` suspends. Grouping moved to `Ctrl+Super+W` and centering to `Super+Alt+C`. `Super+Shift+D` retains the fallback launcher. Physical number keys, keypad shortcuts, mouse media/selection shortcuts, VM passthrough and upstream notification tests are included. See [the integration notes](../../HYPRLAND.md) for validation and installation details.

Rebuild/switch your Nix configuration to install the generated Hyprland bindings, then reload Hyprland and the updated shell. Merely editing these Nix sources does not install the bindings in the running compositor.

The bottom dock has been removed; the side rails provide launcher, clipboard and controls access.

## Reference widgets and customization

The desktop now has equivalents of the visible SekaiPop reference widgets: weather with hourly temperatures/humidity/wind/UV, calendar, an interactive palette, user card with uptime/shell/desktop/day progress, a keycap clock, to-do list, synced lyric overlay, picture frame and sticky note. The palette samples the wallpaper or playing track's cover art, shuffles accents and supports undo. Lyrics use LRCLIB's line-synced data and gracefully handle offline/instrumental/missing results; this is not SekaiPop's multi-provider word-level lyrics engine. Fetching lyrics sends the playing track's artist/title/album/duration to LRCLIB. Weather uses the city/GPS preference already configured in the shell.

- **Super+Shift+E**: move/resize cards. Drag their title strips, resize from the lower-right handle, or use × to hide a card. Escape or Done leaves edit mode. Edit mode lifts the desktop above apps temporarily.
- **Ctrl+Shift+Super+T**: customize card visibility, pictures, purple/wallpaper/random accents, wallpaper dimming, rounding, and card tilt. The same screen is available from the control phone's settings button and Settings → Interface.
- Card positions and sizes persist separately for each monitor. Reset layout restores both positions and visibility. Hiding a card keeps its contents.
- Each task in **Little victories** has its own × delete button, independently of completion. The card itself can also be hidden through customization.
- Click the picture frame or avatar to choose a local picture. The sticky note edits directly on the desktop and persists in the shell config.

Rounded corners are a mask over the complete desktop rendering; the corner tape no longer covers the outer curve. Verified all four outer corner pixels are fully transparent. Separate input-transparent layer-shell surfaces reserve top/bottom frame margins, with side margins retained even when the rails are hidden. Tiled and maximized windows respect this area; true fullscreen intentionally uses the whole monitor and floating windows can still be dragged manually.

The strong decorative wallpaper tint was replaced by configurable dimming (5% default). This does not change hardware brightness. The initialization/reload regression test for real brightness control is `python3 home/services/quickshell/tests/check_brightness.py`; it requires Wayland and mocks every brightness/DDC command.

Lyrics now use a vertically scrolling stack with the current timed line centered, a restrained rebound, scale/opacity transitions for neighboring lines, a pink line-progress sweep, and gently floating/twirling star accents while playing. Backward seeks recenter correctly; long seeks snap directly instead of flying through an entire verse. The larger lyric card keeps all three visible lines clear of the caption. Playback position notifications also update lyrics when seeking while paused.

Desktop stickers gently float and cards lift on hover without changing saved positions. Turn off **Gentle desktop motion** in customization for a still desktop; motion pauses while locked or editing.
