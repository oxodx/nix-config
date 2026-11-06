#!/usr/bin/env python3
"""Audit rendered Hyprland bindings; optionally compare upstream keybinds.lua.

Usage: check_keybinds.py /tmp/binds.conf [/tmp/upstream-keybinds.lua]
"""
from collections import defaultdict
from pathlib import Path
import re
import sys


def chord(modifiers, key):
    aliases = {"page_up": "prior", "page_down": "next", "super": "SUPER"}
    return tuple(sorted(modifiers.upper().replace("$MOD", "SUPER").split())), aliases.get(key.lower(), key.lower())


def main():
    bindings = defaultdict(list)
    submap = "reset"
    for line in Path(sys.argv[1]).read_text().splitlines():
        if line.strip().startswith("submap = "):
            submap = line.split(" = ")[1].strip()
        match = re.match(r"\s*bind\S* = ([^,]*), ([^,]*), (.*)", line)
        if not match:
            continue
        modifiers, key, action = match.groups()
        if action.endswith("quickshell:searchToggleReleaseInterrupt"):
            continue
        bindings[(submap, *chord(modifiers, key))].append(action)
    duplicates = {key: actions for key, actions in bindings.items() if len(actions) > 1 and key[2] not in ("super_l", "super_r")}
    assert not duplicates, f"Conflicting action chords: {duplicates}"
    required = set()
    if len(sys.argv) > 2:
        for value in re.findall(r'hl\.bind\("([^"]+)"', "\n".join(line for line in Path(sys.argv[2]).read_text().splitlines() if not line.lstrip().startswith("--"))):
            if value.endswith((" + ", "Page_", "mouse_", "code:")):
                continue  # Loops are expanded explicitly below.
            pieces = value.split(" + ")
            required.add(chord(" ".join(pieces[:-1]), pieces[-1]))
    for number, keypad, raw in zip(range(1, 11), (87, 88, 89, 83, 84, 85, 79, 80, 81, 90), range(10, 20)):
        for key, mods in ((str(number % 10), "SUPER"), (str(number % 10), "SUPER ALT"), (f"code:{keypad}", "SUPER"), (f"code:{keypad}", "SUPER ALT"), (f"code:{raw}", "SUPER")):
            required.add(chord(mods, key))
    for key in ("left", "right", "up", "down"):
        for mods in ("SUPER", "SUPER SHIFT", "SUPER CTRL"):
            required.add(chord(mods, key))
    for key in ("left", "right"):
        for mods in ("SUPER CTRL ALT", "SUPER CTRL SHIFT"):
            required.add(chord(mods, key))
    for key in ("prior", "next", "mouse_up", "mouse_down"):
        for mods in ("SUPER", "SUPER CTRL", "SUPER SHIFT", "SUPER ALT"):
            required.add(chord(mods, key))
    for key in ("bracketleft", "bracketright"):
        for mods in ("SUPER", "SUPER CTRL"):
            required.add(chord(mods, key))
    actual = {(modifiers, key) for (submap, modifiers, key) in bindings if submap == "reset"}
    missing = required - actual
    assert not missing, f"Missing upstream shortcuts: {sorted(missing)}"
    for modifiers, key, dispatcher in (("SUPER", "D", "fullscreen, 1"), ("SUPER", "F", "fullscreen, 0"), ("SUPER", "A", "global, quickshell:sidebarLeftToggle"), ("SUPER SHIFT", "left", "movewindow, l"), ("SUPER CTRL", "left", "workspace, r-1")):
        assert any(action.endswith(dispatcher) for action in bindings[("reset", *chord(modifiers, key))]), (modifiers, key, dispatcher)
    print(f"PASS: {len(bindings)} action chords, {len(required)} required upstream chords, no conflicting actions")


if __name__ == "__main__":
    main()
