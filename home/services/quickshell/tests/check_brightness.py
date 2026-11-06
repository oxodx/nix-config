#!/usr/bin/env python3
"""Exercise real QML startup/reload with fake hardware, on a running Wayland session.

Run: python3 home/services/quickshell/tests/check_brightness.py
No actual brightness command is executed; all writes go to temporary files.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

SOURCE = Path(__file__).resolve().parents[1]

def main():
    if not os.environ.get("WAYLAND_DISPLAY"):
        raise SystemExit("A running Wayland session is required (Quickshell panels have no offscreen backend).")
    with tempfile.TemporaryDirectory(prefix="encore-brightness-test-") as directory:
        folder = Path(directory)
        shell = folder / "shell"
        shutil.copytree(SOURCE, shell, symlinks=True)
        config = folder / "config" / "illogical-impulse"
        config.mkdir(parents=True)
        (config / "config.json").write_text(json.dumps({"light": {"antiFlashbang": {"enable": False}}, "lock": {"launchOnStartup": False}}))
        binaries = folder / "bin"
        binaries.mkdir()
        level = folder / "level"
        writes = folder / "writes"
        level.write_text("61")
        controller = binaries / "brightnessctl"
        controller.write_text('''#!/usr/bin/env python3
import os, pathlib, sys
root = pathlib.Path(os.environ["ENCORE_TEST_DIR"])
args = sys.argv[1:]
if args == ["g"]: print((root / "level").read_text())
elif args == ["m"]: print(100)
elif "s" in args:
 value = args[args.index("s") + 1].removesuffix("%")
 with (root / "writes").open("a") as file: file.write(value + "\\n")
 (root / "level").write_text(value)
''')
        controller.chmod(0o755)
        ddc = binaries / "ddcutil"
        ddc.write_text("#!/bin/sh\nexit 0\n")
        ddc.chmod(0o755)
        environment = dict(os.environ, ENCORE_TEST_DIR=str(folder), XDG_CONFIG_HOME=str(folder / "config"), XDG_STATE_HOME=str(folder / "state"), XDG_CACHE_HOME=str(folder / "cache"), QT_QPA_PLATFORM="wayland", QSG_RHI_BACKEND="software", PATH=str(binaries) + os.pathsep + os.environ["PATH"])

        def exercise(change=False):
            action = "Brightness.monitors[0].setBrightness(0.62)" if change else ""
            (shell / "shell.qml").write_text('''//@ pragma UseQApplication
import QtQuick
import Quickshell
import "services"
ShellRoot {
 property var monitors: Brightness.monitors
 Timer { interval: 700; running: true; onTriggered: { console.log("READY", Brightness.monitors[0].ready); ACTION } }
 Timer { interval: 1200; running: true; onTriggered: Qt.quit() }
}
'''.replace("ACTION", action))
            result = subprocess.run(["dbus-run-session", "quickshell", "-p", str(shell)], env=environment, capture_output=True, text=True, timeout=10)
            output = result.stdout + result.stderr
            assert result.returncode == 0 and "READY true" in output, output

        exercise()
        assert not writes.exists(), "Startup wrote to the backlight"
        exercise()
        assert not writes.exists(), "Reload wrote to the backlight"
        exercise(True)
        values = [int(value) for value in writes.read_text().splitlines()]
        assert values and min(values) >= 61 and int(level.read_text()) == 62, values
        print("PASS: startup/reload perform no hardware writes; explicit adjustment stays between 61% and 62%")

if __name__ == "__main__":
    main()
