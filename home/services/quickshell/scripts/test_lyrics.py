import json
import os
from pathlib import Path
import sys
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import lyrics

class LyricsTests(unittest.TestCase):

  def test_regular_lrc_offsets_repeats_and_gaps(self):
    lines = lyrics.parse_lrc(
      "[offset:+250]\n[00:02.50][00:04]Repeat\n[00:01]First\n[00:03]\n[ar:Metadata]", 8)
    self.assertEqual([line["time"] for line in lines], [1.25, 2.75, 3.25, 4.25])
    self.assertEqual(lines[2]["text"], "")
    self.assertEqual(lines[-1]["end"], 8)

  def test_enhanced_words_preserve_text_and_actual_end(self):
    line = lyrics.parse_lrc("[00:01]<00:01>Hello <00:02>world<00:02.50>", 10)[0]
    self.assertEqual(line["text"], "Hello world")
    self.assertEqual(line["end"], 2.5)
    self.assertEqual(line["words"][0]["end"], 2)
    self.assertEqual(line["words"][1]["offset"], 6)
    self.assertEqual(line["words"][1]["end"], 2.5)

  def test_unicode_offsets_match_qml_utf16(self):
    line = lyrics.parse_lrc("[00:01]<00:01>🎵 <00:02>café", 4)[0]
    self.assertEqual(line["words"][1]["offset"], 3)
    self.assertEqual(line["words"][1]["length"], 4)

  def test_repeated_enhanced_line_shifts_words(self):
    lines = lyrics.parse_lrc("[00:01][00:06]<00:01>One <00:02>two", 10)
    self.assertEqual(lines[1]["words"][0]["start"], 6)
    self.assertEqual(lines[1]["words"][1]["start"], 7)

  def test_browser_metadata_normalization(self):
    track = lyrics.clean_track({
      "artist": "Unknown Artist",
      "title": "Artist - Song (Official Video)",
      "duration": 0
    })
    self.assertEqual((track["artist"], track["title"]), ("Artist", "Song"))

  def test_cache_survives_invocations_and_retry_bypasses_it(self):
    result = {
      "lines": [{
        "time": 0,
        "text": "test",
        "words": [],
        "end": 2
      }],
      "plainLyrics": "",
      "instrumental": False
    }
    with tempfile.TemporaryDirectory() as directory:
      with patch.dict(os.environ, {"XDG_CACHE_HOME": directory}), patch.object(
          sys, "argv", ["lyrics", json.dumps({
            "artist": "Artist",
            "title": "Song"
          })]), patch.object(lyrics, "lookup",
                             return_value=result) as lookup, patch("builtins.print"):
        lyrics.main()
        lyrics.main()
        self.assertEqual(lookup.call_count, 1)
        sys.argv.append("--refresh")
        lyrics.main()
        self.assertEqual(lookup.call_count, 2)
        self.assertEqual(len(list(Path(directory).rglob("*.json"))), 1)

  def test_cache_identity_ignores_duration_album_and_case(self):
    before = lyrics.clean_track({
      "artist": "Daft Punk",
      "title": "One More Time",
      "album": "Discovery",
      "duration": 320
    })
    after = lyrics.clean_track({
      "artist": "DAFT PUNK",
      "title": "One More Time (Official Video)",
      "duration": 0
    })
    self.assertEqual(lyrics.cache_key(before), lyrics.cache_key(after))
    remix = dict(before, title="One More Time (Remix)")
    self.assertNotEqual(lyrics.cache_key(before), lyrics.cache_key(remix))

  def test_cached_lyrics_reused_when_restart_metadata_changes(self):
    result = {
      "lines": [{
        "time": 0,
        "text": "test",
        "words": [],
        "end": 2
      }],
      "plainLyrics": "",
      "instrumental": False
    }
    with tempfile.TemporaryDirectory() as directory:
      with patch.dict(os.environ, {"XDG_CACHE_HOME": directory}), patch.object(
          lyrics, "lookup", return_value=result) as lookup, patch("builtins.print"):
        with patch.object(sys, "argv", [
            "lyrics",
            json.dumps({
              "artist": "Artist",
              "title": "Song",
              "album": "Album",
              "duration": 243
            })
        ]):
          lyrics.main()
        with patch.object(
            sys, "argv",
          ["lyrics", json.dumps({
            "artist": "Artist",
            "title": "Song",
            "duration": 0
          })]):
          lyrics.main()
        self.assertEqual(lookup.call_count, 1)

  def test_cache_survives_separate_processes(self):
    script_dir = str(Path(__file__).resolve().parent)
    result = {
      "lines": [{
        "time": 0,
        "text": "cached",
        "words": [],
        "end": 2
      }],
      "plainLyrics": "",
      "instrumental": False
    }
    with tempfile.TemporaryDirectory() as directory:
      environment = dict(os.environ, XDG_CACHE_HOME=directory)
      first = "import lyrics; lyrics.lookup = lambda track: " + repr(result) + "; lyrics.main()"
      second = "import lyrics; lyrics.lookup = lambda track: (_ for _ in ()).throw(AssertionError('Unexpected provider lookup')); lyrics.main()"
      for code, duration in ((first, 243), (second, 0)):
        track = json.dumps({"artist": "Artist", "title": "Song", "duration": duration})
        process = subprocess.run([sys.executable, "-B", "-c", code, track],
                                 cwd=script_dir,
                                 env=environment,
                                 capture_output=True,
                                 text=True,
                                 check=True)
        self.assertEqual(json.loads(process.stdout)["lines"][0]["text"], "cached")

  def test_failed_refresh_preserves_cached_success(self):
    result = {
      "lines": [{
        "time": 0,
        "text": "cached",
        "words": [],
        "end": 2
      }],
      "plainLyrics": "",
      "instrumental": False
    }
    empty = {"lines": [], "plainLyrics": "", "instrumental": False}
    with tempfile.TemporaryDirectory() as directory:
      with patch.dict(os.environ, {"XDG_CACHE_HOME": directory}), patch.object(
          sys, "argv", ["lyrics", json.dumps({
            "artist": "Artist",
            "title": "Song"
          })]), patch.object(lyrics, "lookup",
                             side_effect=[result, empty]), patch("builtins.print") as output:
        lyrics.main()
        sys.argv.append("--refresh")
        lyrics.main()
        self.assertEqual(json.loads(output.call_args.args[0]), result)

if __name__ == "__main__":
  unittest.main()
