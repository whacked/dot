local wezterm = require 'wezterm'
local config = {}


config.color_scheme = 'Mirage'
config.window_background_opacity = 0.8
config.hide_tab_bar_if_only_one_tab = true
-- leave with defaults for now
-- config.font = wezterm.font_with_fallback {
--   "FiraCode",
--   "Deja Vu Sans Mono",
--   "Menlo",              -- mac fallback
--   "Consola",            -- windows fallback
--   "Liberation Mono",    -- linux fallback?
-- };
config.font_size = 12.0;


return config
