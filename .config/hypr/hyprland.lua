-- Dracula / Hyprland 0.55+ / KDE applications
local terminal = "alacritty" -- Change to "konsole" if preferred.
local browser = "firefox"
local reaper_compat = true -- Popup/focus workaround; see README before changing.
local scripts = '"' .. (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. '/hypr/scripts/'
local function script(name) return "bash " .. scripts .. name .. '"' end
local function launch(keys, command) hl.bind(keys, hl.dsp.exec_cmd(command)) end

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
-- Optional old monitor arrangement; inspect names with `hyprctl monitors` first:
-- for i = 1, 9 do hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" }) end
-- hl.workspace_rule({ workspace = "10", monitor = "eDP-1" })

hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("XCURSOR_THEME", "Dracula-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.config({
    cursor = { enable_hyprcursor = false }, -- Installed Dracula theme uses Xcursor.
    general = {
        layout = "dwindle", gaps_in = 6, gaps_out = 12, border_size = 2,
        resize_on_border = true,
        col = { active_border = { colors = { "rgba(bd93f9ff)", "rgba(ff79c6ff)" }, angle = 45 },
                inactive_border = "rgba(44475aaa)" },
    },
    decoration = {
        rounding = 14,
        blur = { enabled = true, size = 6, passes = 2 },
        shadow = { enabled = true, range = 18, render_power = 3, color = "rgba(191a2188)" },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    input = {
        -- Win/Meta/Super + Space cycles English (US) → Russian → Ukrainian.
        kb_layout = "us,ru,ua", kb_options = "grp:win_space_toggle",
        follow_mouse = 1, mouse_refocus = true, accel_profile = "flat",
        touchpad = { natural_scroll = true, tap_to_click = true, disable_while_typing = true },
    },
    misc = { disable_hyprland_logo = true, force_default_wallpaper = 0, background_color = "rgba(282a36ff)" },
})
hl.curve("dracula", { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })
for _, leaf in ipairs({ "windows", "workspaces", "fade", "border" }) do
    hl.animation({ leaf = leaf, enabled = true, speed = 4, bezier = "dracula" })
end
hl.window_rule({ name = "music", match = { class = "[Ss]potify" }, workspace = "10 silent" })
hl.window_rule({ name = "dialogs", match = { class = "(org.kde.polkit-kde-authentication-agent-1|pavucontrol|nm-connection-editor)" }, float = true })
if reaper_compat then
    dofile((os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. "/hypr/reaper.lua")
end

hl.on("hyprland.start", function() hl.exec_cmd(script("session.sh")) end)
launch("SUPER + Return", terminal)
launch("SUPER + D", "wofi --show drun")
launch("SUPER + F1", "dolphin")
launch("SUPER + F2", browser)
launch("SUPER + SHIFT + R", "hyprctl reload")
launch("SUPER + SHIFT + E", script("power.sh"))
launch("SUPER + N", "swaync-client -t -sw")
launch("SUPER + CTRL + L", "hyprlock")
launch("Print", script("screenshot.sh") .. " area")
launch("SHIFT + Print", script("screenshot.sh") .. " full")
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + E", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + W", hl.dsp.group.toggle())
hl.bind("SUPER + Tab", hl.dsp.group.next())
hl.bind("SUPER + minus", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.move({ workspace = "special:scratchpad" }))
for key, direction in pairs({ H = "left", J = "down", K = "up", L = "right", left = "left", down = "down", up = "up", right = "right" }) do
    hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end
for workspace = 1, 10 do
    local key = tostring(workspace % 10)
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
for key, command in pairs({
    XF86AudioRaiseVolume = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+",
    XF86AudioLowerVolume = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",
    XF86AudioMute = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    XF86AudioMicMute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    XF86MonBrightnessUp = "brightnessctl set +5%",
    XF86MonBrightnessDown = "brightnessctl --min-value=1 set 5%-",
}) do hl.bind(key, hl.dsp.exec_cmd(command), { repeating = true, locked = true }) end
launch("SUPER + I", "brightnessctl set +5%")
launch("SUPER + O", "brightnessctl --min-value=1 set 5%-")
for key, command in pairs({ XF86AudioPlay = "play-pause", XF86AudioPause = "play-pause", XF86AudioNext = "next", XF86AudioPrev = "previous" }) do
    launch(key, "playerctl " .. command)
end
