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
        value = 1 if action == "zoom-reset" else min(3, max(1, current + (0.3 if action == "zoom-in" else -0.3)))
        run("hyprctl", "keyword", "cursor:zoom_factor", str(value))
    elif action in ("screenshot-file", "screenshot-clipboard"):
        monitor = next(m["name"] for m in json.loads(run("hyprctl", "monitors", "-j")) if m["focused"])
        if action == "screenshot-clipboard":
            image = subprocess.run(["grim", "-o", monitor, "-"], check=True, capture_output=True).stdout
            subprocess.run(["wl-copy", "--type", "image/png"], input=image, check=True)
            return
        from datetime import datetime
        folder = Path(run("xdg-user-dir", "PICTURES").strip()) / "Screenshots"
        folder.mkdir(parents=True, exist_ok=True)
        target = folder / (datetime.now().strftime("Screenshot_%Y-%m-%d_%H-%M-%S_%f") + ".png")
        monitor = next(m["name"] for m in json.loads(run("hyprctl", "monitors", "-j")) if m["focused"])
        run("grim", "-o", monitor, str(target))
        with target.open("rb") as image:
            subprocess.run(["wl-copy", "--type", "image/png"], stdin=image, check=True)
    elif action == "selection-query":
        # Selection stays on the machine, matching upstream's local Ollama helper.
        import urllib.request
        import urllib.error
        content = run("wl-paste", "--primary", "--no-newline")[:2000]
        try:
            with urllib.request.urlopen("http://localhost:11434/api/ps", timeout=5) as response:
                models = json.load(response).get("models", [])
            model = models[0]["model"] if models else "llama3.2"
            payload = json.dumps({"model": model, "stream": False, "prompt": "Explain or translate the following selection briefly:\n" + content}).encode()
            request = urllib.request.Request("http://localhost:11434/api/generate", data=payload, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(request, timeout=120) as response:
                answer = json.load(response).get("response", "No response available")
        except (urllib.error.URLError, TimeoutError):
            answer = "Start Ollama and load a model to use selected-text queries."
        run("notify-send", "--app-name=Text selection query", "--expire-time=10000", "AI selection summary", answer)
    elif action in ("notification-profile", "notification-wallpaper"):
        image = Path("/var/lib/AccountsService/icons") / os.environ.get("USER", "")
        if action == "notification-wallpaper":
            config = Path(os.environ.get("XDG_CONFIG_HOME", str(Path.home() / ".config"))) / "illogical-impulse/config.json"
            try:
                image = Path(json.loads(config.read_text())["background"]["wallpaperPath"])
            except (OSError, KeyError, ValueError):
                image = Path(__file__).resolve().parents[2] / "assets/images/default_wallpaper.png"
        run("notify-send", "--app-name=Encore preview", "--expire-time=6000", "--icon=preferences-desktop-theme", "--hint=string:image-path:" + str(image), "A little sparkle ♡", "A preview of your shell notifications.")
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
