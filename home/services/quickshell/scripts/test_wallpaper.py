import tempfile
import json
from pathlib import Path
import unittest
from unittest.mock import patch

import wallpaper

class WallpaperTests(unittest.TestCase):

  def post(self, **changes):
    return dict(
      {
        "id": 42,
        "rating": "s",
        "width": 2560,
        "height": 1440,
        "file_url": "https://konachan.net/image/test.png"
      }, **changes)

  def transport(self, posts, content=b"image fixture", content_type="image/png"):

    def transfer(address, output=None):
      if output is None:
        return json.dumps(posts)
      output.write_bytes(content)
      return content_type

    return transfer

  def test_download_saved_atomically(self):
    with tempfile.TemporaryDirectory() as temporary, patch.object(wallpaper,
                                                                  "request",
                                                                  side_effect=self.transport(
                                                                    [self.post()])) as request:
      directory = Path(temporary)
      result = wallpaper.fetch(directory)
      self.assertEqual(result["image"], (directory / "konachan-42.png").as_uri())
      self.assertEqual((directory / "konachan-42.png").read_bytes(), b"image fixture")
      self.assertEqual(len(list(directory.iterdir())), 1)
      self.assertIn("rating%3Asafe", request.call_args_list[0].args[0])

  def test_unsafe_or_untrusted_results_are_rejected(self):
    for changes in ({
        "rating": "e"
    }, {
        "rating": "q"
    }, {
        "file_url": "https://example.com/test.png"
    }, {
        "file_url": "http://konachan.net/test.png"
    }, {
        "width": 1080,
        "height": 1920
    }):
      with self.subTest(changes=changes), tempfile.TemporaryDirectory() as temporary:
        with patch.object(wallpaper, "request",
                          side_effect=self.transport([self.post(**changes)])) as request:
          with self.assertRaises(ValueError):
            wallpaper.fetch(Path(temporary))
          self.assertEqual(request.call_count, 1)

  def test_previous_image_is_not_repeated(self):
    with tempfile.TemporaryDirectory() as temporary, patch.object(wallpaper,
                                                                  "request",
                                                                  side_effect=self.transport(
                                                                    [self.post()])):
      with self.assertRaises(ValueError):
        wallpaper.fetch(Path(temporary), "file:///wallpapers/konachan-42.png")

  def test_invalid_or_oversized_download_is_cleaned_up(self):
    for content_type, limit in (("text/html", 100), ("image/png", 1)):
      with self.subTest(content_type=content_type), tempfile.TemporaryDirectory() as temporary:
        with patch.object(wallpaper,
                          "request",
                          side_effect=self.transport([self.post()],
                                                     content_type=content_type)), patch.object(
                                                       wallpaper, "MAX_BYTES", limit):
          with self.assertRaises(ValueError):
            wallpaper.fetch(Path(temporary))
          self.assertEqual(list(Path(temporary).iterdir()), [])

if __name__ == "__main__":
  unittest.main()
