#!/usr/bin/env bash
set -euo pipefail
pictures=$(xdg-user-dir PICTURES 2>/dev/null || printf '%s/Pictures' "$HOME")
mkdir -p "$pictures/Screenshots"
file=$(mktemp "$pictures/Screenshots/shot-$(date +%Y%m%d-%H%M%S)-XXXXXX.png")
trap 'rm -f "$file"' EXIT
case "${1:-area}" in
    area) geometry=$(slurp) || exit 0; grim -g "$geometry" "$file" ;;
    full) grim "$file" ;;
    *) exit 2 ;;
esac
trap - EXIT
wl-copy --type image/png < "$file"
notify-send 'Screenshot saved and copied' "$file"
