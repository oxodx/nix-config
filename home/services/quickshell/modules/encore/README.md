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
- Phone launcher: apps, existing advanced search providers, clipboard, emoji and calculations. Arrow keys select, Enter runs, Escape or the scrim dismisses. `Super+D` and the existing `search` IPC endpoint continue to work.
- Phone controls: Wi-Fi, Bluetooth, notification silence, idle inhibitor, volume, brightness, network settings, night light, media and notification history with actions. Header and footer stay available while the middle scrolls.
- Scrapbook desktop over the configured wallpaper: outlined purple frame, striped tape, slightly crooked card stacks, Pride ribbons, heart/star stickers, a month calendar, clock, to-do list, palette swatches and media. A sticky note is editable and persists as `encore.note`; the to-do widget uses the existing Todo service. On smaller displays secondary cards are hidden to avoid overlap. Video wallpapers use the existing thumbnail.
- Notification cards and volume/brightness OSD use Encore's own styling.

Encore uses a purple/lilac palette with pink accents and small inclusive Pride ribbons. This is confined to Encore.

Encore has an opaque lock background with the configured wallpaper (or bundled wallpaper if unset), a purple fallback while loading, and its own clock. It reuses the shared password/fingerprint authentication surface and session-lock protocol; it does not switch workspaces to manufacture a background. Video wallpapers use their thumbnail.

Existing services supply data and device control. Authentication, session actions, screenshot/region selection, cheatsheet, on-screen keyboard, translation and wallpaper selection reuse the existing system surfaces. Encore does not load either family's bar, dock, overview or sidebars.

## Hyprland shortcuts

The Nix Hyprland bindings use SekaiPop's main shortcut layout and target the active family's registered Quickshell globals. `ShellShortcuts.qml` routes controls to Waffle's action center or the ii/Encore right panel, and switches Encore's own palette without touching ii's theme. No Pop styling is applied to shared widgets or ii.

| Keys | Action |
| --- | --- |
| Super+A / Super+D | Launcher |
| Super+N | Quick controls |
| Super+Tab | Overview (ii/Waffle) or launcher (Encore) |
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
| Ctrl+Shift+Super+P | Cycle shell family |
| Shift+Super+S | Screen snip |
| Shift+Super+X | OCR |
| Shift+Super+A | Image search |
| Shift+Super+R | Record region |
| Ctrl+Shift+Super+S | Record with audio |

Volume/mute keys use guarded shell audio actions; brightness keys use the shared brightness service. Both feed each family's OSD. Media playback keys retain `playerctl`.

Conflicting window shortcuts moved: focus with Super+Alt+H/J/K/L (arrows still work), floating with Super+Shift+V, and swap split with Ctrl+Shift+Super+R. Use Super+PageUp/PageDown for previous/next workspace; bracket keys still move windows into/out of groups. Super+Shift+D retains the fallback launcher.

Rebuild/switch your Nix configuration to install the generated Hyprland bindings, then reload Hyprland and the updated shell. Merely editing these Nix sources does not install the bindings in the running compositor.

The bottom dock has been removed; the side rails provide launcher, clipboard and controls access.
