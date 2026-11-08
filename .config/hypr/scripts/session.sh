#!/usr/bin/env bash
set -u
config_root=${XDG_CONFIG_HOME:-$HOME/.config}
# This script is launched only by Hyprland, never by Plasma autostart.
[[ -n ${HYPRLAND_INSTANCE_SIGNATURE:-} ]] || exit 0
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME
start() {
    if command -v "$1" >/dev/null 2>&1; then
        "$@" &
    else
        printf 'Hyprland startup: missing %s\n' "$1" >&2
    fi
}
start waybar -c "$config_root/waybar/hyprland/config.jsonc" -s "$config_root/waybar/hyprland/style.css"
start swaync -c "$config_root/swaync-hyprland/config.json" -s "$config_root/swaync-hyprland/style.css"
start hypridle
# Relative image paths in hyprpaper.conf resolve from this working directory.
# Until an image is supplied, Hyprland draws the Dracula background color.
wallpaper="$config_root/hypr/wallpaper.jpg"
if [[ -f $wallpaper ]]; then
    (cd "$config_root/hypr" && start hyprpaper -c "$config_root/hypr/hyprpaper.conf")
fi
# KDE's agent lives in different directories on different distributions.
if ! pgrep -f '^(/usr/[^ ]*/)?polkit-kde-authentication-agent-1( |$)' >/dev/null; then
    for agent in /usr/libexec/kf6/polkit-kde-authentication-agent-1 /usr/lib/polkit-kde-authentication-agent-1 /usr/libexec/polkit-kde-authentication-agent-1 /usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1; do
        if [[ -x $agent ]]; then "$agent" & break; fi
    done
fi
# NetworkManager's tray agent handles Wi-Fi password prompts outside Plasma.
start nm-applet --indicator
