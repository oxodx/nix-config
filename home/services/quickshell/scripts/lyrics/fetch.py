#!/usr/bin/env python3
"""LRCLIB lookup with conservative matching and an on-disk success cache."""
import argparse
from difflib import SequenceMatcher
import hashlib
import json
import os
from pathlib import Path
import re
import time
import unicodedata
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


def clean_title(value):
    return re.sub(r"\s*(?:\((?:official[^)]*|lyrics?[^)]*|audio|video|visuali[sz]er)\)|\[(?:official[^\]]*|lyrics?[^\]]*|audio|video)\])", "", value, flags=re.I).strip()


def normalized(value):
    return re.sub(r"[^\w]+", " ", unicodedata.normalize("NFKC", value).casefold()).strip()


def choose(records, title, artist, duration):
    matches = []
    for record in records:
        if not (record.get("syncedLyrics") or record.get("plainLyrics") or record.get("instrumental")):
            continue
        title_score = SequenceMatcher(None, normalized(title), normalized(record.get("trackName", ""))).ratio()
        artist_score = SequenceMatcher(None, normalized(artist), normalized(record.get("artistName", ""))).ratio() if artist else 1
        delta = abs(float(record.get("duration") or duration) - duration) if duration else 0
        # Never turn an unrelated search result into somebody else's karaoke.
        if title_score < .85 or artist_score < .65 or (duration and delta > max(15, duration * .08)):
            continue
        score = title_score * 5 + artist_score * 3 - min(delta, 30) / 30 + (.25 if record.get("syncedLyrics") else 0)
        matches.append((score, record))
    return max(matches, key=lambda item: item[0])[1] if matches else None


def request(endpoint, params):
    req = Request("https://lrclib.net/api/" + endpoint + "?" + urlencode(params), headers={"User-Agent": "EncoreQuickshell/1.1 (https://github.com/end-4/dots-hyprland)", "Accept": "application/json"})
    try:
        with urlopen(req, timeout=7) as response:
            return json.load(response)
    except HTTPError as error:
        if error.code in (400, 404):
            return None
        raise


def lookup(title, artist, album, duration, force=False, cache_dir=None, fetch=request):
    folder = Path(cache_dir or Path(os.environ.get("XDG_CACHE_HOME", str(Path.home() / ".cache"))) / "encore/lyrics")
    key = hashlib.sha256(json.dumps([title, artist, album, round(duration)], ensure_ascii=False).encode()).hexdigest()
    path = folder / (key + ".json")
    cached = None
    try:
        cached = json.loads(path.read_text())
        ttl = 30 * 86400 if cached.get("status") != "missing" else 1800
        if not force and time.time() - cached["saved"] < ttl:
            return cached
    except (OSError, ValueError, KeyError):
        pass
    cleaned = clean_title(title)
    candidates = []
    if artist:
        exact = {"track_name": title, "artist_name": artist}
        if album:
            exact["album_name"] = album
        if 1 <= duration <= 3600:
            exact["duration"] = round(duration)
        candidates.append(("get", exact))
        basic = {"track_name": cleaned, "artist_name": artist}
        if basic != exact:
            candidates.append(("get", basic))
        candidates.append(("search", basic))
    else:
        candidates.append(("search", {"q": cleaned}))
    result = None
    try:
        for endpoint, params in candidates:
            raw = fetch(endpoint, params)
            records = raw if isinstance(raw, list) else [raw] if isinstance(raw, dict) else []
            result = choose(records, cleaned, artist, duration)
            if result:
                break
    except (URLError, TimeoutError, OSError, ValueError):
        # Respect rate limiting: stop this lookup rather than immediately retrying.
        if cached and cached.get("status") != "missing":
            return cached
        return {"status": "offline", "syncedLyrics": "", "plainLyrics": ""}
    if result:
        result = {"status": "synced" if result.get("syncedLyrics") else "instrumental" if result.get("instrumental") else "plain", "syncedLyrics": result.get("syncedLyrics") or "", "plainLyrics": result.get("plainLyrics") or ""}
    else:
        result = {"status": "missing", "syncedLyrics": "", "plainLyrics": ""}
    result["saved"] = time.time()
    try:
        folder.mkdir(parents=True, exist_ok=True)
        temporary = path.with_suffix(f".{os.getpid()}.tmp")
        temporary.write_text(json.dumps(result))
        temporary.replace(path)
    except OSError:
        pass  # Cache failures must not hide usable lyrics.
    return result


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    for option in ("title", "artist", "album"):
        parser.add_argument("--" + option, default="")
    parser.add_argument("--duration", type=float, default=0)
    parser.add_argument("--force", action="store_true")
    args = parser.parse_args()
    print(json.dumps(lookup(args.title, args.artist, args.album, args.duration, args.force)))
