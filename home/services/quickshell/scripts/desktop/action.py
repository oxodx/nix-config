#!/usr/bin/env python3
"""Small, argument-safe Hyprland utilities for the Nix configuration."""
import json
import os
from pathlib import Path
import subprocess
import sys

def run(*args):
    return subprocess.run(args, check=True, capture_output=True, text=True).stdout

def main(action):
    if action in ("zoom-in", "zoom-out", "zoom-reset"):
        current = json.loads(run("hyprctl", "getoption", "cursor:zoom_factor", "-j"))["float"]
        value = 1 if action == "zoom-reset" else min(3, max(1, current + (0.25 if action == "zoom-in" else -0.25)))
        run("hyprctl", "keyword", "cursor:zoom_factor", str(value))
    elif action == "screenshot-file":
        from datetime import datetime
        folder = Path(run("xdg-user-dir", "PICTURES").strip()) / "Screenshots"
        folder.mkdir(parents=True, exist_ok=True)
        target = folder / (datetime.now().strftime("Screenshot_%Y-%m-%d_%H-%M-%S_%f") + ".png")
        monitor = next(m["name"] for m in json.loads(run("hyprctl", "monitors", "-j")) if m["focused"])
        run("grim", "-o", monitor, str(target))
        with target.open("rb") as image:
            subprocess.run(["wl-copy", "--type", "image/png"], stdin=image, check=True)
    elif action == "launcher":
        if subprocess.run(["qs", "ipc", "call", "search", "toggle"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL).returncode:
            subprocess.Popen(["fuzzel"])
    else:
        raise ValueError(f"Unknown action: {action}")

if __name__ == "__main__":
    try:
        main(sys.argv[1])
    except (IndexError, ValueError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
