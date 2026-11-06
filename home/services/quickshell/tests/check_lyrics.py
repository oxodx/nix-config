#!/usr/bin/env python3
"""Provider-independent regression tests for lyric fallback and cache behavior."""
import importlib.util
from pathlib import Path
import tempfile
import unittest
from urllib.error import URLError

spec = importlib.util.spec_from_file_location("lyrics", Path(__file__).resolve().parents[1] / "scripts/lyrics/fetch.py")
lyrics = importlib.util.module_from_spec(spec)
spec.loader.exec_module(lyrics)


def record(**overrides):
    return {"trackName": "Song", "artistName": "Artist", "duration": 200, "syncedLyrics": "[00:01.00]Hello", **overrides}


class LookupTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)

    def lookup(self, fetch, **kwargs):
        options = dict(title="Song", artist="Artist", album="Deluxe", duration=200, cache_dir=self.directory.name, fetch=fetch)
        options.update(kwargs)
        return lyrics.lookup(**options)

    def test_relaxes_album_and_duration(self):
        calls = []
        def fetch(endpoint, params):
            calls.append(params)
            return None if "album_name" in params else record()
        self.assertEqual(self.lookup(fetch)["status"], "synced")
        self.assertNotIn("duration", calls[1])
        self.assertNotIn("album_name", calls[1])

    def test_cleans_video_label_and_searches(self):
        calls = []
        def fetch(endpoint, params):
            calls.append((endpoint,params))
            return [record()] if endpoint == "search" else None
        self.assertEqual(self.lookup(fetch, title="Song (Official Music Video)")["status"], "synced")
        self.assertEqual(calls[-1][1]["track_name"], "Song")

    def test_plain_lyrics_are_usable(self):
        result = self.lookup(lambda *args: record(syncedLyrics=None, plainLyrics="Hello\nWorld"))
        self.assertEqual(result["status"], "plain")
        self.assertEqual(result["plainLyrics"], "Hello\nWorld")

    def test_cache_avoids_network_and_survives_offline_refresh(self):
        self.lookup(lambda *args: record())
        def offline(*args):
            raise URLError("offline")
        self.assertEqual(self.lookup(offline)["status"], "synced")
        self.assertEqual(self.lookup(offline, force=True)["status"], "synced")

    def test_missing_cache_and_manual_retry(self):
        self.assertEqual(self.lookup(lambda *args: None)["status"], "missing")
        self.assertEqual(self.lookup(lambda *args: record())["status"], "missing")
        self.assertEqual(self.lookup(lambda *args: record(), force=True)["status"], "synced")

    def test_rejects_unrelated_song_and_wrong_duration(self):
        self.assertEqual(self.lookup(lambda *args: record(trackName="Other song"))["status"], "missing")
        self.assertIsNone(lyrics.choose([record(duration=500)], "Song", "Artist", 200))

    def test_unknown_duration_omitted(self):
        def fetch(endpoint, params):
            self.assertNotIn("duration", params)
            return record()
        self.assertEqual(self.lookup(fetch, duration=0)["status"], "synced")

    def test_network_failure_is_not_cached_as_missing(self):
        def offline(*args):
            raise URLError("offline")
        self.assertEqual(self.lookup(offline)["status"], "offline")
        self.assertEqual(self.lookup(lambda *args: record())["status"], "synced")


if __name__ == "__main__":
    unittest.main()
