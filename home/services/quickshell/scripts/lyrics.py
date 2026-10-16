"""One-shot lyric lookup; Quickshell owns player selection and playback timing."""

import contextlib
import hashlib
import json
import multiprocessing
import os
import queue
import re
import signal
import sys
import time
import unicodedata
from pathlib import Path

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
        end = (markers[index + 1].start() if index + 1 < len(markers) else len(rest))
        word = rest[marker.end():end]
        if word:
          words.append({
            "start": seconds(marker.groups()) + offset,
            "offset": text_length(text),
            "length": text_length(word),
            "word": word,
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
        "end_hint": end_hint + shift if end_hint else 0,
      })
  lines.sort(key=lambda line: line["time"])
  for index, line in enumerate(lines):
    following = lines[index + 1]["time"] if index + 1 < len(lines) else duration
    # A final empty enhanced timestamp can provide a real ending.
    hint = line.pop("end_hint")
    end = (hint if hint > line["time"] else following if following > line["time"] else max(
      line["time"] + 3,
      line["words"][-1]["start"] + 0.3 if line["words"] else 0,
    ))
    if following > line["time"]:
      end = min(end, following)
    line["end"] = end
    for wi, word in enumerate(line["words"]):
      next_start = (line["words"][wi + 1]["start"] if wi + 1 < len(line["words"]) else end)
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
  title = re.sub(
    r"\s*[\[(](?:official\s+)?(?:music\s+)?(?:video|audio|lyrics?|visuali[sz]er)[\])]",
    "",
    title,
    flags=re.I,
  ).strip()
  return dict(track, artist=artist, title=title)

def cache_key(track):
  identity = {
    "artist": normalize(track["artist"]),
    "title": normalize(track["title"]),
  }
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

def matches(track, artist, title, duration=0):
  if normalize(artist) != normalize(track["artist"]) or normalize(title) != normalize(
      track["title"]):
    return False
  expected = track.get("duration", 0)
  return not (expected and duration and abs(expected - duration) > max(3, expected * 0.02))

def candidate(track, lrc, plain, duration, source, instrumental=False):
  lines = parse_lrc(lrc or "", duration or track.get("duration", 0))
  return {
    "lines": lines,
    "enhanced": any(line["words"] for line in lines),
    "plainLyrics": plain or "",
    "duration": duration or track.get("duration", 0),
    "instrumental": instrumental,
    "source": source,
    "schema": 3,
  }

def quality(result):
  if not result:
    return (0, 0)
  lines = result.get("lines", [])
  return (
    3 if result.get("enhanced") else
    2 if lines else 1 if result.get("plainLyrics") or result.get("instrumental") else 0,
    len([line for line in lines if line["text"].strip()]),
  )

def provider_lookup(provider, track, output):
  try:
    with deadline(18):
      for result in provider(track):
        output.put(result)
  except (Exception, ProviderTimeout) as error:
    print(f"{provider.__name__}: {error}", file=sys.stderr)
  finally:
    output.put(None)

def lrclib(track):
  import requests

  session = requests.Session()
  session.headers["User-Agent"] = "oxod-quickshell-lyrics/3.0"
  params = {"artist_name": track["artist"], "track_name": track["title"]}
  for endpoint in ("get", "search"):
    try:
      query = dict(params)
      if endpoint == "get" and track.get("duration"):
        query["duration"] = track["duration"]
      response = session.get("https://lrclib.net/api/" + endpoint, params=query, timeout=5)
      response.raise_for_status()
      results = [response.json()] if endpoint == "get" else response.json()
      for result in results:
        if matches(
            track,
            result.get("artistName", ""),
            result.get("trackName", ""),
            result.get("duration", 0),
        ):
          yield candidate(
            track,
            result.get("syncedLyrics"),
            result.get("plainLyrics"),
            result.get("duration", 0),
            "LRCLIB",
            bool(result.get("instrumental")),
          )
    except Exception as error:
      print(f"LRCLIB {endpoint}: {error}", file=sys.stderr)

def musixmatch(track):
  from syncedlyrics.providers import Musixmatch

  provider = Musixmatch()
  response = provider._get(
    "track.search",
    [
      ("q", f"{track['artist']} {track['title']}"),
      ("page_size", "5"),
      ("page", "1"),
    ],
  )
  for item in response.json()["message"]["body"]["track_list"]:
    song = item["track"]
    if not matches(
        track,
        song.get("artist_name", ""),
        song.get("track_name", ""),
        song.get("track_length", 0),
    ):
      continue
    for fetch in (provider.get_lrc_by_id, provider.get_lrc_word_by_word):
      result = fetch(song["track_id"])
      if result:
        yield candidate(
          track,
          result.synced,
          result.unsynced,
          song.get("track_length", 0),
          "Musixmatch",
        )

def netease(track):
  from syncedlyrics.providers import NetEase

  provider = NetEase()
  response = provider.session.get(
    "https://music.163.com/api/search/pc",
    params={
      "limit": 10,
      "type": 1,
      "offset": 0,
      "s": f"{track['artist']} {track['title']}",
    },
    timeout=5,
  )
  response.raise_for_status()
  for song in response.json().get("result", {}).get("songs", []):
    duration = song.get("duration", 0) / 1000
    if not any(
        matches(track, artist["name"], song["name"], duration)
        for artist in song.get("artists", [])):
      continue
    result = provider.get_lrc_by_id(song["id"])
    if result:
      yield candidate(track, result.synced, result.unsynced, duration, "NetEase")

def lookup(track):
  context = multiprocessing.get_context("fork")
  output = context.Queue()
  workers = [
    context.Process(target=provider_lookup, args=(provider, track, output), daemon=True)
    for provider in (lrclib, musixmatch, netease)
  ]
  for worker in workers:
    worker.start()
  finished, expires = 0, time.monotonic() + 20
  try:
    while finished < len(workers) and time.monotonic() < expires:
      try:
        result = output.get(timeout=min(0.5, max(0.01, expires - time.monotonic())))
      except queue.Empty:
        continue
      if result is None:
        finished += 1
      else:
        yield result
  finally:
    for worker in workers:
      if worker.is_alive():
        worker.terminate()
      worker.join()
    output.close()

def save_cache(cache_file, result):
  try:
    cache_file.parent.mkdir(parents=True, exist_ok=True)
    temp = cache_file.with_suffix(f".{os.getpid()}.tmp")
    temp.write_text(json.dumps(result, ensure_ascii=False))
    temp.replace(cache_file)
  except OSError as error:
    print(f"Lyrics cache: {error}", file=sys.stderr)

def main():
  track = clean_track(json.loads(sys.argv[1]))
  key = cache_key(track)
  cache_dir = (Path(os.environ.get("XDG_CACHE_HOME", str(Path.home() / ".cache"))) / "quickshell" /
               "lyrics-v2")
  cache_file = cache_dir / (key + ".json")
  cached = None
  if cache_file.exists():
    try:
      cached = json.loads(cache_file.read_text())
      if not isinstance(cached.get("lines"), list) or cached.get("schema") != 3:
        cached = None
      if (cached is not None and cached.get("complete") and "--refresh" not in sys.argv):
        print(json.dumps(cached, ensure_ascii=False), flush=True)
        return
    except (ValueError, OSError, AttributeError):
      cached = None
  if cached is not None:
    print(json.dumps(cached, ensure_ascii=False), flush=True)
  best = cached
  results = lookup(track)
  # Also allow a single result for small offline fixtures.
  if isinstance(results, dict):
    results = [results]
  for result in results:
    if quality(result) <= quality(best):
      continue
    result = dict(result, schema=3, complete=False)
    best = result
    print(json.dumps(result, ensure_ascii=False), flush=True)
    save_cache(cache_file, result)
  if best:
    save_cache(cache_file, dict(best, complete=True))

if __name__ == "__main__":
  main()
