local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- helpful:
-- https://www.youtube.com/watch?v=I3ipo8NxsjY


wezterm.on('open-uri', function(window, pane, uri)
    -- disable open browser on url
    return false
end)


-- disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

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
config.tab_bar_at_bottom = false

config.colors = {
  -- foreground = 'silver',
  -- background = 'white',

  selection_fg = 'black',
  selection_bg = '#fffacd',


  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = '#ff2222',

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = '#000000' },
  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
  copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
  copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

  quick_select_label_bg = { Color = 'peru' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { AnsiColor = 'Navy' },
  quick_select_match_fg = { Color = '#ffffff' },


  -- cursor_fg = 'red',
  -- cursor_bg = 'red',
--  brights = {
--    'grey',
--    'red',
--    'lime',
--    'yellow',
--    'blue',
--    'fuchsia',
--    'aqua',
--    'white',
--  },

  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = '#0b0022',

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = '#5b4022',
      -- The color of the text for the tab
      fg_color = '#c0c0c0',

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Normal',

    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}



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
-- disable ligatures
config.harfbuzz_features = { 'calt=0' }

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

  {
    key = '.',
    mods = mod_key,
    action = wezterm.action_callback(function(win, pane)
      local tab, window = pane:move_to_new_window()
    end),
  },
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
