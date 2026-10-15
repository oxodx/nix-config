"""One-shot lyric lookup; Quickshell owns player selection and playback timing."""

import contextlib
import hashlib
import json
import os
from pathlib import Path
import re
import signal
import sys
import unicodedata

STAMP = r"(\d+):(\d+(?:\.\d+)?)"

class ProviderTimeout(BaseException):
  """Escape provider libraries that catch every Exception internally."""

def text_length(text):
  return len(text.encode("utf-16-le")) // 2

def seconds(match):
  return int(match[0]) * 60 + float(match[1])

def parse_lrc(source, duration=0):
  """Normalize regular/enhanced LRC to seconds, preserving character offsets."""
  offset_match = re.search(r"\[offset:([+-]?\d+)\]", source, re.I)
  offset = int(offset_match[1]) / 1000 if offset_match else 0
  lines = []
  for raw in source.splitlines():
    stamps = list(re.finditer(r"\[" + STAMP + r"\]", raw))
    if not stamps:
      continue
    rest = raw[stamps[-1].end():].strip()
    markers = list(re.finditer(r"<" + STAMP + r">", rest))
    words, text, end_hint = [], "", 0
    if markers:
      text = rest[:markers[0].start()]
      for index, marker in enumerate(markers):
        end = markers[index + 1].start() if index + 1 < len(markers) else len(rest)
        word = rest[marker.end():end]
        if word:
          words.append({
            "start": seconds(marker.groups()) + offset,
            "offset": text_length(text),
            "length": text_length(word),
            "word": word
          })
          text += word
        elif index == len(markers) - 1:
          end_hint = seconds(marker.groups()) + offset
      # Keep exact spaces: glyph highlighting uses these offsets.
    else:
      text = rest
    for stamp in stamps:
      shift = seconds(stamp.groups()) - seconds(stamps[0].groups())
      line_words = [dict(word, start=max(0, word["start"] + shift)) for word in words]
      lines.append({
        "time": max(0,
                    seconds(stamp.groups()) + offset),
        "text": text,
        "words": line_words,
        "end_hint": end_hint + shift if end_hint else 0
      })
  lines.sort(key=lambda line: line["time"])
  for index, line in enumerate(lines):
    following = lines[index + 1]["time"] if index + 1 < len(lines) else duration
    # A final empty enhanced timestamp can provide a real ending.
    hint = line.pop("end_hint")
    end = hint if hint > line["time"] else following if following > line["time"] else max(
      line["time"] + 3, line["words"][-1]["start"] + 0.3 if line["words"] else 0)
    if following > line["time"]:
      end = min(end, following)
    line["end"] = end
    for wi, word in enumerate(line["words"]):
      next_start = line["words"][wi + 1]["start"] if wi + 1 < len(line["words"]) else end
      word["end"] = max(word["start"], min(end, next_start))
  return lines

def normalize(value):
  return re.sub(r"[^\w]+", "", unicodedata.normalize("NFKC", value).casefold())

def clean_track(track):
  artist, title = track.get("artist", "").strip(), track.get("title", "").strip()
  if artist.casefold() in ("unknown artist", "") and " - " in title:
    artist, title = title.split(" - ", 1)
  elif title.casefold().startswith(artist.casefold() + " - "):
    title = title[len(artist) + 3:]
  title = re.sub(r"\s*[\[(](?:official\s+)?(?:music\s+)?(?:video|audio|lyrics?|visuali[sz]er)[\])]",
                 "",
                 title,
                 flags=re.I).strip()
  return dict(track, artist=artist, title=title)

def cache_key(track):
  identity = {"artist": normalize(track["artist"]), "title": normalize(track["title"])}
  return hashlib.sha256(json.dumps(identity, sort_keys=True).encode()).hexdigest()

@contextlib.contextmanager
def deadline(seconds_limit):

  def expired(*_):
    raise ProviderTimeout("Lyric provider timed out")

  previous = signal.signal(signal.SIGALRM, expired)
  signal.alarm(seconds_limit)
  try:
    yield
  finally:
    signal.alarm(0)
    signal.signal(signal.SIGALRM, previous)

def enhanced_lookup(query):
  import syncedlyrics
  with deadline(10):
    result = syncedlyrics.search(query, enhanced=True, providers=["Musixmatch"])
  return result if result and re.search(r"<" + STAMP + r">", result) else None

def lookup(track):
  import requests
  artist, title = track["artist"], track["title"]
  duration = track.get("duration", 0)
  result, enhanced = {}, None
  try:
    enhanced = enhanced_lookup(f"{artist} {title}")
  except (Exception, ProviderTimeout) as error:
    print(f"Enhanced lookup: {error}", file=sys.stderr)
  session = requests.Session()
  session.headers["User-Agent"] = "oxod-quickshell-lyrics/2.0"
  params = {"artist_name": artist, "track_name": title}
  if duration > 0:
    params["duration"] = duration
  try:
    response = session.get("https://lrclib.net/api/get", params=params, timeout=5)
    if response.ok:
      result = response.json()
  except Exception as error:
    print(f"LRCLIB lookup: {error}", file=sys.stderr)
  if not result.get("syncedLyrics") and not result.get("instrumental") and not enhanced:
    try:
      response = session.get("https://lrclib.net/api/search",
                             params={
                               "artist_name": artist,
                               "track_name": title
                             },
                             timeout=5)
      response.raise_for_status()
      candidates = response.json()

      def score(candidate):
        return (100 * (normalize(candidate.get("trackName", "")) == normalize(title)) + 50 *
                (normalize(candidate.get("artistName", "")) == normalize(artist)) +
                10 * bool(candidate.get("syncedLyrics")) -
                (abs(candidate.get("duration", duration) - duration) if duration else 0))

      if candidates:
        result = max(candidates, key=score)
    except Exception as error:
      print(f"LRCLIB search: {error}", file=sys.stderr)
  lrc = enhanced or result.get("syncedLyrics") or ""
  if not lrc and not result.get("plainLyrics") and not result.get("instrumental"):
    try:
      import syncedlyrics
      with deadline(10):
        lrc = syncedlyrics.search(
          f"{artist} {title}", synced_only=True, providers=["NetEase", "Megalobiz"]) or ""
    except (Exception, ProviderTimeout) as error:
      print(f"Fallback lookup: {error}", file=sys.stderr)
  total = float(result.get("duration") or duration or 0)
  lines = parse_lrc(lrc, total)
  return {
    "lines": lines,
    "enhanced": any(line["words"] for line in lines),
    "plainLyrics": result.get("plainLyrics") or "",
    "duration": total,
    "instrumental": bool(result.get("instrumental")),
    "source": "Musixmatch" if enhanced else "LRCLIB" if result else "syncedlyrics"
  }

def main():
  track = clean_track(json.loads(sys.argv[1]))
  key = cache_key(track)
  cache_dir = Path(os.environ.get("XDG_CACHE_HOME", str(
    Path.home() / ".cache"))) / "quickshell" / "lyrics-v2"
  cache_file = cache_dir / (key + ".json")
  cached = None
  if cache_file.exists():
    try:
      cached = json.loads(cache_file.read_text())
      if not isinstance(cached.get("lines"), list):
        cached = None
      if cached is not None and "--refresh" not in sys.argv:
        print(json.dumps(cached, ensure_ascii=False), flush=True)
        return
    except (ValueError, OSError, AttributeError):
      cached = None
  result = lookup(track)
  if result["lines"] or result["plainLyrics"] or result["instrumental"]:
    try:
      cache_dir.mkdir(parents=True, exist_ok=True)
      temp = cache_file.with_suffix(f".{os.getpid()}.tmp")
      temp.write_text(json.dumps(result, ensure_ascii=False))
      temp.replace(cache_file)
    except OSError as error:
      print(f"Lyrics cache: {error}", file=sys.stderr)
  elif cached is not None:
    result = cached
  print(json.dumps(result, ensure_ascii=False), flush=True)

if __name__ == "__main__":
  main()
