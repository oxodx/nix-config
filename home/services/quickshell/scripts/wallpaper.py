"""Download one safe-rated, landscape Konachan wallpaper."""

import json
from pathlib import Path
import random
import re
import sys
import subprocess
import tempfile
from urllib.parse import urlencode, urlparse

MAX_BYTES = 32 * 1024 * 1024

def request(address, output=None):
  # Prefer QUIC/HTTP3, with curl's automatic TCP fallback on other networks.
  command = [
    "curl", "--http3", "--fail", "--location", "--silent", "--show-error", "--proto", "=https",
    "--proto-redir", "=https", "--connect-timeout", "4", "--max-time", "15" if output else "8",
    "--max-filesize",
    str(MAX_BYTES), "--user-agent", "oxod-quickshell-wallpaper/1.0"
  ]
  if output is not None:
    command += ["--output", str(output), "--write-out", "%{content_type}"]
  command.append(address)
  response = subprocess.run(command, capture_output=True, text=True, timeout=17)
  if response.returncode:
    if response.returncode == 28:
      raise ValueError("Konachan timed out; try again")
    raise ValueError("Konachan request failed: " + response.stderr.strip())
  return response.stdout

def fetch(directory, current=""):
  query = urlencode({"limit": 20, "tags": "rating:safe order:random width:>=1920 height:>=1080"})
  posts = json.loads(request("https://konachan.net/post.json?" + query))
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
        with tempfile.NamedTemporaryFile(dir=directory, prefix=".download-",
                                         delete=False) as output:
          temporary = Path(output.name)
        content_type = request(address, temporary)
        if not content_type.startswith("image/"):
          raise ValueError("Konachan did not return an image")
        size = temporary.stat().st_size
        if size > MAX_BYTES:
          raise ValueError("Wallpaper exceeds the 32 MB download limit")
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
  except subprocess.TimeoutExpired:
    result = {"error": "Konachan timed out; try again"}
  except (ValueError, OSError) as error:
    result = {"error": str(error)}
  print(json.dumps(result), flush=True)
