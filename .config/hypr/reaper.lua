-- Native Linux REAPER. Deliberately excludes unrelated Wine/plugin windows.
-- Inspect `hyprctl clients -j` if a plugin uses its own class/title.
-- Disable with `local reaper_compat = false` in hyprland.lua.
local reaper_class = "(?i)reaper"

-- REAPER context menus can disappear as the pointer crosses to the popup.
-- Upstream workaround: follow_mouse=1 plus mouse_refocus=false (issue #2278).
-- This input option is compositor-wide; the rules below remain REAPER-only.
hl.config({ input = { mouse_refocus = false } })

-- Clicking still focuses REAPER; moving over its windows does not steal focus.
-- This is a scoped workaround, not a change to global mouse focus behavior.
hl.window_rule({
    name = "reaper-click-focus",
    match = { class = reaper_class },
    no_follow_mouse = true,
})

hl.window_rule({
    name = "reaper-modal-dialogs",
    match = { class = reaper_class, modal = true },
    float = true,
})

-- Match recognizable auxiliary titles at creation, never the main project window.
-- Do not force sizes: plugins have different minimum/fixed dimensions.
hl.window_rule({
    name = "reaper-fx-dialogs",
    match = {
        class = reaper_class,
        title = "^(FX:.*|FX Browser.*|Add FX.*|Routing for track.*|REAPER Preferences|Preferences)$",
    },
    float = true,
})
