"""Download one safe-rated, landscape Konachan wallpaper."""

import json
from pathlib import Path
import random
import re
import sys
import tempfile
from urllib.parse import urlparse

import requests

MAX_BYTES = 32 * 1024 * 1024

def fetch(directory, current=""):
  session = requests.Session()
  session.headers["User-Agent"] = "oxod-quickshell-wallpaper/1.0"
  response = session.get("https://konachan.net/post.json",
                         params={
                           "limit": 20,
                           "tags": "rating:safe order:random width:>=1920 height:>=1080"
                         },
                         timeout=(10, 20))
  response.raise_for_status()
  posts = response.json()
  if not isinstance(posts, list):
    raise ValueError("Konachan returned an unexpected response")
  random.shuffle(posts)
  previous = re.search(r"konachan-(\d+)\.", current)
  for post in posts:
    post_id = int(post.get("id", 0))
    if post.get("rating") != "s" or post.get("width", 0) < post.get("height", 1):
      continue
    if post_id <= 0 or (previous and str(post_id) == previous[1]):
      continue
    address = post.get("file_url", "")
    parsed = urlparse(address)
    host = parsed.hostname or ""
    if parsed.scheme != "https" or not any(host == domain or host.endswith("." + domain)
                                           for domain in ("konachan.net", "konachan.com")):
      continue
    extension = Path(parsed.path).suffix.lower()
    if extension not in (".jpg", ".jpeg", ".png", ".webp"):
      continue
    directory.mkdir(parents=True, exist_ok=True)
    destination = directory / f"konachan-{post_id}{extension}"
    if not destination.is_file():
      temporary = None
      try:
        with session.get(address, stream=True, timeout=(10, 30)) as image:
          image.raise_for_status()
          if not image.headers.get("Content-Type", "").startswith("image/"):
            raise ValueError("Konachan did not return an image")
          with tempfile.NamedTemporaryFile(dir=directory, prefix=".download-",
                                           delete=False) as output:
            temporary = Path(output.name)
            size = 0
            for chunk in image.iter_content(64 * 1024):
              size += len(chunk)
              if size > MAX_BYTES:
                raise ValueError("Wallpaper exceeds the 32 MB download limit")
              output.write(chunk)
          if not size:
            raise ValueError("Konachan returned an empty image")
          temporary.replace(destination)
      finally:
        if temporary is not None:
          temporary.unlink(missing_ok=True)
    return {"image": destination.as_uri(), "directory": directory.as_uri()}
  raise ValueError("No matching safe landscape wallpapers found; try again")

if __name__ == "__main__":
  try:
    result = fetch(Path.home() / "Pictures" / "Wallpapers" / "Konachan",
                   sys.argv[1] if len(sys.argv) > 1 else "")
  except requests.Timeout:
    result = {"error": "Konachan timed out; try again"}
  except requests.ConnectionError:
    result = {"error": "Could not reach Konachan; check your connection and try again"}
  except (requests.RequestException, ValueError, OSError) as error:
    result = {"error": str(error)}
  print(json.dumps(result), flush=True)
