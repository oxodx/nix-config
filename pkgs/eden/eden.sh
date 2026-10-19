if [[ ${1:-} == --help ]]; then
  echo "Usage: eden [GAME_FILE [KEYS_DIRECTORY]]"
  echo "Defaults: EDEN_GAME, EDEN_KEYS_DIR, EDEN_SANDBOX_DIR, or the original local paths."
  exit 0
fi
if (( $# > 2 )); then
  echo "Usage: eden [GAME_FILE [KEYS_DIRECTORY]]" >&2
  exit 2
fi

game=${1:-${EDEN_GAME:-$HOME/Downloads/totk-inspect/TOTK [0100F2C0115B6000][v0].xci}}
keys=${2:-${EDEN_KEYS_DIR:-$HOME/Downloads/switch-key-check}}
base=${EDEN_SANDBOX_DIR:-$HOME/.local/share/eden-sandbox}
runtime=${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}
wayland=${WAYLAND_DISPLAY:-wayland-0}
if [[ $wayland == /* ]]; then
  wayland_socket=$wayland
else
  wayland_socket=$runtime/$wayland
fi

fail() { echo "Eden: $*" >&2; exit 1; }
[[ -f $game ]] || fail "Game file missing: $game"
[[ -f $keys/prod.keys ]] || fail "prod.keys missing in $keys"
[[ -f $keys/title.keys ]] || fail "title.keys missing in $keys"
[[ -S $wayland_socket ]] || fail "Wayland socket missing: $wayland_socket"
[[ -S $runtime/pulse/native ]] || fail "PulseAudio socket missing: $runtime/pulse/native"
game=$(realpath -- "$game")
keys=$(realpath -- "$keys")
mkdir -p -- "$base/config" "$base/data/eden/keys" "$base/cache" "$base/tmp"
base=$(realpath -- "$base")

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
  --ro-bind "$game" "/home/eden/game.${game##*.}"
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

echo "Launching Eden sandbox; game: /home/eden/game.${game##*.}"
exec "$BWRAP_BINARY" "${args[@]}" "$EDEN_BINARY"
