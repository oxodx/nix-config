# quickshell config

One Quickshell process provides the bar, launcher, lock screen, notifications,
wallpaper, screenshot overlay, and OSD.

Click the bar clock to open the skewed control center: Wi-Fi, microphone,
focus mode, launcher, capture, lock, volume, media controls, month calendar,
and live CPU/memory usage. Calendar arrows change months; click the month
heading to return to today. Focus mode keeps notifications in history while
suppressing new popups.

The launcher remembers app launch frequency across restarts and promotes
frequent apps when the search is empty. Search still prioritizes text matches;
prefix a query with `>` to run a command.

Design and feature inspiration: [SKWD legacy](https://github.com/liixini/skwd/tree/legacy).
The implementation uses the existing shell components and services.

To get this config working, run this command in this directory:

```sh
ln -s $(pwd) ~/.config/quickshell
```
