#!/bin/bash
AGE=/nix/store/g0s4hagmrgnz8bw5c3ra9dhiw211cazh-age-1.3.1/bin/age
SECRETS_DIR=/home/oxod/dev/nix-config/secrets

for f in "$SECRETS_DIR"/*.age; do
  name=$(basename "$f")
  echo "Re-encrypting $name..."
  sudo $AGE -d -i /root/.config/age/keys.txt "$f" | $AGE -R "$SECRETS_DIR/recipients.txt" -o "$f.tmp" && mv "$f.tmp" "$f"
done
echo "Done!"
