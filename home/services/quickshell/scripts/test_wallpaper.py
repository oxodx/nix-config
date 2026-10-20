import tempfile
from pathlib import Path
import unittest
from unittest.mock import MagicMock, patch

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

  def session(self, posts, content=b"image fixture", content_type="image/png"):
    api = MagicMock()
    api.json.return_value = posts
    image = MagicMock()
    image.headers = {"Content-Type": content_type}
    image.iter_content.return_value = [content]
    image.__enter__.return_value = image
    session = MagicMock()
    session.get.side_effect = [api, image]
    return session

  def test_download_saved_atomically(self):
    session = self.session([self.post()])
    with tempfile.TemporaryDirectory() as temporary, patch.object(wallpaper.requests,
                                                                  "Session",
                                                                  return_value=session):
      directory = Path(temporary)
      result = wallpaper.fetch(directory)
      self.assertEqual(result["image"], (directory / "konachan-42.png").as_uri())
      self.assertEqual((directory / "konachan-42.png").read_bytes(), b"image fixture")
      self.assertEqual(len(list(directory.iterdir())), 1)
      self.assertIn("rating:safe", session.get.call_args_list[0].kwargs["params"]["tags"])

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
        session = self.session([self.post(**changes)])
        with patch.object(wallpaper.requests, "Session", return_value=session):
          with self.assertRaises(ValueError):
            wallpaper.fetch(Path(temporary))
          self.assertEqual(session.get.call_count, 1)

  def test_previous_image_is_not_repeated(self):
    with tempfile.TemporaryDirectory() as temporary, patch.object(wallpaper.requests,
                                                                  "Session",
                                                                  return_value=self.session(
                                                                    [self.post()])):
      with self.assertRaises(ValueError):
        wallpaper.fetch(Path(temporary), "file:///wallpapers/konachan-42.png")

  def test_invalid_or_oversized_download_is_cleaned_up(self):
    for content_type, limit in (("text/html", 100), ("image/png", 1)):
      with self.subTest(content_type=content_type), tempfile.TemporaryDirectory() as temporary:
        with patch.object(wallpaper.requests,
                          "Session",
                          return_value=self.session([self.post()],
                                                    content_type=content_type)), patch.object(
                                                      wallpaper, "MAX_BYTES", limit):
          with self.assertRaises(ValueError):
            wallpaper.fetch(Path(temporary))
          self.assertEqual(list(Path(temporary).iterdir()), [])

if __name__ == "__main__":
  unittest.main()
