# oxod shell

A Niri-first Quickshell with Caelestia-inspired fluid composition, iNiR-style
information density, and Skwd-inspired angled surfaces.

The center music island shows the current synced lyric underneath the title.
Lyrics are fetched from LRCLIB using the playing track's artist and title;
the last 32 results are cached in memory only. Tracks without synced lyrics
or position support show the artist instead. Left-click toggles playback;
right-click opens the dashboard.

The sidebar has Dashboard and Notifications tabs. Its dashboard scrolls on
short screens and includes media controls and a live volume slider.

Scroll over the bar's volume pill to adjust output in 5% steps (capped at
100%); click to mute. The media card includes a playback timeline with
seeking when supported by the player. Battery, network and Bluetooth use
the shell's Material icon font, with charging and low-battery accents.
Do not disturb keeps incoming notifications in history without replaying
their popups when it is disabled.

## Layout

```text
shell.qml                 # composition root only
components/               # reusable visual primitives
  PanelCard.qml           # rounded dashboard surface
  SkewPanel.qml           # angled bar/OSD surface
  StatusPill.qml          # compact interactive status control
modules/
  bar/
    TopBar.qml            # panel window and island composition
    widgets/              # launcher, audio and date controls
  notifications/         # popup notification presentation
  osd/                    # volume, microphone and brightness OSD
  sidebar/                # dashboard, calendar and notification centre
bar/                      # focused status widgets and system-tray adapters
utils/                    # singleton state and external-service adapters
```

State belongs in `utils/`, complete shell surfaces belong in `modules/`, and
small reusable visual building blocks belong in `components/`. Bar status
adapters remain deliberately small and contain no window-management code.

## IPC

```sh
quickshell ipc call bar toggle
quickshell ipc call bar show
quickshell ipc call bar hide
quickshell ipc call notifications toggle
```

## Theme

`utils/Colors.qml` provides both Material color roles and stable semantic shell
roles. If present, `$XDG_CACHE_HOME/oxod/quickshell/colors.json` overrides the
palette at runtime. Geometry, typography and animation timings live in
`utils/Config.qml`.

For local development, point Quickshell at this directory:

```sh
quickshell -p ./home/services/quickshell
```
