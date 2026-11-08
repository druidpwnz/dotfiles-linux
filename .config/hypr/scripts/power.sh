#!/usr/bin/env bash
set -euo pipefail
choice=$(printf '%s\n' 'Lock' 'Suspend' 'Log out' 'Reboot' 'Power off' | wofi --dmenu --prompt 'Session' --width 300 --height 300) || exit 0
case "$choice" in
    Lock) exec hyprlock ;;
    Suspend) exec systemctl suspend ;; # hypridle locks before sleep.
    'Log out'|Reboot|'Power off')
        confirm=$(printf '%s\n' Cancel "Confirm $choice" | wofi --dmenu --prompt "$choice?" --width 300 --height 160) || exit 0
        [[ $confirm == "Confirm $choice" ]] || exit 0
        case "$choice" in
            'Log out') exec hyprctl dispatch 'hl.dsp.exit()' ;;
            Reboot) exec systemctl reboot ;;
            'Power off') exec systemctl poweroff ;;
        esac ;;
esac
