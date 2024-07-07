local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

-- helpful:
-- https://www.youtube.com/watch?v=I3ipo8NxsjY


config.color_scheme = 'Monokai'
config.colors = {
    selection_fg = 'black',
    selection_bg = '#fffacd',
}
config.default_prog = { 'zsh' }
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.window_background_opacity = 0.8
config.hide_tab_bar_if_only_one_tab = false
config.hide_mouse_cursor_when_typing = false
config.use_fancy_tab_bar = true  -- default true

config.status_update_interval = 1000  -- what's the default?
wezterm.on("update-right-status", function(window, pane)
    local basename = function(s)
        return string.gsub(tostring(s) or "", "(.*[/\\])(.*)", "%2")
    end
    local cwd = pane:get_current_working_dir()
    if cwd == nil then
        window:set_right_status(wezterm.format({
            { Text = "" },
        }))
    else
        local cwd_basename = basename(cwd)
        window:set_right_status(wezterm.format({
            { Text = wezterm.nerdfonts.md_folder .. " " .. cwd_basename },
        }))
    end
end)

-- leave with defaults for now
-- config.font = wezterm.font_with_fallback {
--   "FiraCode",
--   "Deja Vu Sans Mono",
--   "Menlo",              -- mac fallback
--   "Consola",            -- windows fallback
--   "Liberation Mono",    -- linux fallback?
-- };
config.font_size = 12.0;
config.inactive_pane_hsb = {
  -- hue = 0.8,
  saturation = 0.9,
  brightness = 0.4,
}

local mod_key = 'ALT|SUPER'

-- config.leader = { mods = "CTRL" }
config.keys = {
  { key = "z", mods = mod_key,  action = act.TogglePaneZoomState },

  { key = "h", mods = mod_key,  action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = mod_key,  action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = mod_key,  action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = mod_key,  action = act.ActivatePaneDirection("Right") },

  { key = 'r', mods = mod_key, action = act.ActivateKeyTable { name = "resize_pane", one_shot = false, }, },

  -- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
  { key = '8', mods = mod_key, action = act.PaneSelect },
  -- activate pane selection mode with numeric labels
  {
    key = '9',
    mods = mod_key,
    action = act.PaneSelect {
      alphabet = '1234567890',
    },
  },
  -- show the pane selection mode, but have it swap the active and selected panes
  {
    key = '0',
    mods = mod_key,
    action = act.PaneSelect {
      mode = 'SwapWithActive',
    },
  },
  { key = 'i', mods = mod_key, action = act.RotatePanes 'CounterClockwise', },
  { key = 'o', mods = mod_key, action = act.RotatePanes 'Clockwise' },

  -- tabs
  -- { key = 'm', mods = mod_key, action = act.SpawnTab("CurrentPaneDomain"), },
  { key = 't', mods = mod_key, action = act.ShowTabNavigator, },
  { key = '[', mods = mod_key, action = act.ActivateTabRelative(-1), },
  { key = ']', mods = mod_key, action = act.ActivateTabRelative(1), },
  -- move tabs: https://youtu.be/I3ipo8NxsjY?t=603
}

config.key_tables = {
    resize_pane = {
        { key = "h", action = act.AdjustPaneSize { "Left", 1 } },
        { key = "j", action = act.AdjustPaneSize { "Down", 1 } },
        { key = "k", action = act.AdjustPaneSize { "Up", 1 } },
        { key = "l", action = act.AdjustPaneSize { "Right", 1 } },
        { key = "Enter", action = "PopKeyTable" },
        { key = "Escape", action = "PopKeyTable" },
    },
}


return config
