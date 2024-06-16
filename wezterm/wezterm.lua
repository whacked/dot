local wezterm = require 'wezterm'
local config = {}


config.color_scheme = 'Mirage'
config.window_background_opacity = 0.8
config.font = wezterm.font_with_fallback {
  "FiraCode",
  "Deja Vu Sans Mono"
};
config.font_size = 12.0;


return config
