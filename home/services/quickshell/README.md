# oxod shell

A Niri-first Quickshell with Caelestia-inspired fluid composition, iNiR-style
information density, and Skwd-inspired angled surfaces.

The center music island shows the current synced lyric underneath the title.
Lyrics are fetched from LRCLIB using the playing track's artist and title;
the last 32 results are cached in memory only. Tracks without synced lyrics
or position support show the artist instead. Left-click toggles playback;
right-click opens the dashboard.

The launcher combines fuzzy desktop-app search with an explicit command mode:
prefix a query with `>` to run it through the user's shell. Search results show
application descriptions and remain fully keyboard navigable.

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
  SkewedPanel.qml         # low-level parallelogram geometry
  SkewedSurface.qml       # shared surface, outline and shadow composition
  SkewedImage.qml         # artwork clipped to the shared geometry
  ProgressBar.qml         # common angular value indicator
bar/                      # top bar, shared popups and status adapters
launcher/                 # fuzzy app search and command runner
notifications/            # daemon, popup stack and notification history
lock/                     # session lock and authentication state
osd/                      # volume, microphone and brightness OSD
background/               # wallpaper and desktop clock
```

Complete shell surfaces stay in their feature directories, state is kept in
singleton controllers, and reusable visual building blocks live in
`components/`. Everything is composed by one `ShellRoot`; unlike upstream
Skwd, no feature launches a second Quickshell process.

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
