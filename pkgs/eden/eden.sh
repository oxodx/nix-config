if [[ ${1:-} == --help ]]; then
  echo "Usage: eden [ROM_DIRECTORY_OR_GAME [KEYS_DIRECTORY]]"
  echo "ROM folder: \${EDEN_ROM_DIR:-\$HOME/Games/roms/switch} (shown as /home/eden/roms inside Eden)."
  echo "Overrides: EDEN_ROM_DIR, EDEN_GAME, EDEN_KEYS_DIR, EDEN_SANDBOX_DIR."
  exit 0
fi
if (( $# > 2 )); then
  echo "Usage: eden [ROM_DIRECTORY_OR_GAME [KEYS_DIRECTORY]]" >&2
  exit 2
fi

target=${1:-${EDEN_GAME:-}}
roms=${EDEN_ROM_DIR:-$HOME/Games/roms/switch}
game=""
keys=${2:-${EDEN_KEYS_DIR:-$HOME/Downloads/switch-key-check}}
host_data=${XDG_DATA_HOME:-$HOME/.local/share}
base=${EDEN_SANDBOX_DIR:-$host_data/eden-sandbox}
runtime=${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}
host_config=${XDG_CONFIG_HOME:-$HOME/.config}
wayland=${WAYLAND_DISPLAY:-wayland-0}
if [[ $wayland == /* ]]; then
  wayland_socket=$wayland
else
  wayland_socket=$runtime/$wayland
fi

fail() { echo "Eden: $*" >&2; exit 1; }
if [[ -n $target ]]; then
  if [[ -d $target ]]; then
    roms=$target
  elif [[ -f $target ]]; then
    game=$(realpath -- "$target")
  else
    fail "ROM directory or game file missing: $target"
  fi
fi
[[ -f $keys/prod.keys ]] || fail "prod.keys missing in $keys"
[[ -f $keys/title.keys ]] || fail "title.keys missing in $keys"
[[ -S $wayland_socket ]] || fail "Wayland socket missing: $wayland_socket"
[[ -S $runtime/pulse/native ]] || fail "PulseAudio socket missing: $runtime/pulse/native"
keys=$(realpath -- "$keys")
mkdir -p -- "$roms" "$base/config" "$base/data/eden/keys" "$base/cache" "$base/tmp"
roms=$(realpath -- "$roms")
base=$(realpath -- "$base")

# Synchronize non-secret desktop defaults into the isolated XDG config. Eden
# keeps its own writable settings under $base; it does not gain access to the
# host's complete configuration directory or D-Bus session.
for relative in \
  mimeapps.list \
  user-dirs.dirs \
  user-dirs.locale \
  kdeglobals \
  gtk-3.0/settings.ini \
  gtk-4.0/settings.ini; do
  source_file=$host_config/$relative
  if [[ -f $source_file ]]; then
    destination=$base/config/$relative
    mkdir -p -- "${destination%/*}"
    install -m 0644 -- "$(realpath -- "$source_file")" "$destination"
  fi
done

args=(
  --die-with-parent --new-session --cap-drop ALL
  --unshare-pid --unshare-net --unshare-ipc
  --ro-bind /nix/store /nix/store
  --ro-bind /run/current-system /run/current-system
  --ro-bind /run/opengl-driver /run/opengl-driver
  --ro-bind /etc /etc
  --ro-bind /sys /sys
  --ro-bind-try /run/udev /run/udev
  --dev /dev
  --dev-bind-try /dev/dri /dev/dri
  --dir /dev/input
  --proc /proc
  --tmpfs /tmp
  --dir /home/eden
  --bind "$base/config" /home/eden/config
  --bind "$base/data" /home/eden/data
  --bind "$base/cache" /home/eden/cache
  --bind "$base/tmp" /tmp/eden
  --ro-bind "$roms" /home/eden/roms
  --ro-bind "$keys/prod.keys" /home/eden/prod.keys
  --ro-bind "$keys/title.keys" /home/eden/title.keys
  --ro-bind "$keys/prod.keys" /home/eden/data/eden/keys/prod.keys
  --ro-bind "$keys/title.keys" /home/eden/data/eden/keys/title.keys
  --ro-bind "$wayland_socket" "$wayland_socket"
  --ro-bind "$runtime/pulse" "$runtime/pulse"
  --ro-bind-try "$runtime/pipewire-0" "$runtime/pipewire-0"
  --chdir /home/eden
  --setenv HOME /home/eden
  --setenv XDG_CONFIG_HOME /home/eden/config
  --setenv XDG_DATA_HOME /home/eden/data
  --setenv XDG_CACHE_HOME /home/eden/cache
  --setenv XDG_RUNTIME_DIR "$runtime"
  --setenv WAYLAND_DISPLAY "$wayland"
  --setenv QT_QPA_PLATFORM wayland
  --setenv PULSE_SERVER "unix:$runtime/pulse/native"
  --setenv PIPEWIRE_REMOTE pipewire-0
  --setenv SDL_VIDEODRIVER wayland
  --unsetenv DISPLAY --unsetenv DBUS_SESSION_BUS_ADDRESS
  --unsetenv VK_DRIVER_FILES --unsetenv VK_ICD_FILENAMES
)

if [[ -n $game ]]; then
  args+=(--ro-bind "$game" "/home/eden/game.${game##*.}")
fi

for device in /dev/nvidia0 /dev/nvidiactl /dev/nvidia-modeset /dev/nvidia-uvm /dev/nvidia-uvm-tools; do
  [[ ! -c $device ]] || args+=(--dev-bind "$device" "$device")
done

# Only expose the selected controller, not every input device (e.g. keyboards).
if [[ -d /dev/input/by-id ]]; then
  while IFS= read -r -d '' link; do
    device=$(readlink -f -- "$link")
    [[ ! -c $device ]] || args+=(--dev-bind "$device" "$device")
  done < <(find /dev/input/by-id -maxdepth 1 -name '*Turtle_Beach*joystick' -print0)
fi

if [[ -e /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json && -c /dev/nvidia0 ]]; then
  args+=(
    --setenv VK_DRIVER_FILES /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json
    --setenv VK_ICD_FILENAMES /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json
  )
fi

echo "Eden ROM library: $roms (inside sandbox: /home/eden/roms)"
if [[ -n $game ]]; then
  echo "Additional game: /home/eden/game.${game##*.}"
fi
echo "Launching Eden sandbox..."
exec "$BWRAP_BINARY" "${args[@]}" "$EDEN_BINARY"
