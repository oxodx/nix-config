#!/usr/bin/env python3
"""Run actual Encore QML with a fake player/lookup; no music is controlled."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

SOURCE = Path(__file__).resolve().parents[1]


def main():
    with tempfile.TemporaryDirectory(prefix="encore-lyrics-test-") as directory:
        folder = Path(directory)
        shell = folder / "shell"
        shutil.copytree(SOURCE, shell, symlinks=True)
        config = folder / "config/illogical-impulse"
        config.mkdir(parents=True)
        (config / "config.json").write_text(json.dumps({"lock": {"launchOnStartup": False}}))
        binaries = folder / "bin"
        binaries.mkdir()
        for name, content in {"brightnessctl": '#!/bin/sh\ncase "$1" in g) echo 61;; m) echo 100;; esac\n', "ddcutil": "#!/bin/sh\nexit 0\n"}.items():
            path = binaries / name
            path.write_text(content)
            path.chmod(0o755)
        (shell / "scripts/lyrics/fetch.py").write_text('''import json,os,time
from pathlib import Path
with (Path(os.environ["ENCORE_LYRIC_TEST_DIR"])/"requests").open("a") as f:f.write("request\\n")
time.sleep(.5)
print(json.dumps({"status":"plain","plainLyrics":"[Verse]\\nFirst line\\nSecond line"} if os.environ.get("ENCORE_LYRIC_MODE")=="estimated" else {"status":"synced","syncedLyrics":"[00:01.00]First line\\n[00:07.00]Second line"}))
''')
        (shell / "shell.qml").write_text('''//@ pragma UseQApplication
import QtQuick
import Quickshell
import "modules/encore"
ShellRoot {
    property var snapshot
    EncoreLyricWords { id: timingProbe; width:400; height:68; text:"Timing check"; current:true; playing:true }
    QtObject { id: fake; property string trackTitle:"Song"; property string trackArtist:"Artist"; property string trackAlbum:"Album"; property real length:200; property real position:3; property bool isPlaying:true }
    FloatingWindow { visible:true; implicitWidth:400; implicitHeight:240; EncoreLyrics { id: lyrics; width:400; height:240; player:fake } }
    Timer { interval:100; running:true; repeat:true; onTriggered:{ fake.length+=.4; fake.position+=.1 } }
    Timer { interval:1600; running:true; onTriggered:{ timingProbe.progress=.2; console.log("NO_FILL_DELAY",timingProbe.smoothProgress===timingProbe.progress); snapshot=lyrics.lines; console.log("LOADED",lyrics.lines.length===2); console.log("ESTIMATED",lyrics.estimated); console.log("ORDERED_TIMES",lyrics.lines.length===2 && lyrics.lines[1].t>lyrics.lines[0].t) } }
    Timer { interval:2500; running:true; onTriggered:{ console.log("STABLE",snapshot===lyrics.lines); fake.trackTitle="Another song" } }
    Timer { interval:4200; running:true; onTriggered:{ console.log("NEW_TRACK",lyrics.lines.length===2); Qt.quit() } }
}
''')
        env = {**os.environ, "QT_QPA_PLATFORM": "wayland", "ENCORE_LYRIC_TEST_DIR": str(folder), "XDG_CONFIG_HOME": str(folder / "config"), "XDG_STATE_HOME": str(folder / "state"), "XDG_CACHE_HOME": str(folder / "cache"), "PATH": str(binaries) + os.pathsep + os.environ["PATH"]}
        for mode in ("synced", "estimated"):
            requests = folder / "requests"
            requests.unlink(missing_ok=True)
            env["ENCORE_LYRIC_MODE"] = mode
            result = subprocess.run(["dbus-run-session", "quickshell", "-p", str(shell)], env=env, text=True, capture_output=True, timeout=15)
            output = result.stdout + result.stderr
            for marker in ("NO_FILL_DELAY true", "LOADED true", "STABLE true", "NEW_TRACK true", "ORDERED_TIMES true", "ESTIMATED " + ("true" if mode == "estimated" else "false")):
                assert marker in output, output
            assert requests.read_text().splitlines() == ["request", "request"], output
            assert result.returncode == 0, output
            assert "TypeError:" not in output and "ReferenceError:" not in output, output
            print(f"PASS ({mode}): duration/position updates keep lyrics stable; one lookup per song")



if __name__ == "__main__":
    main()
