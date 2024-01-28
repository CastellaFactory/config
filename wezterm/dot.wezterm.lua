local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

require('fontsetting').setup(config)
require('appearance').setup(config)
require('keymapping').setup(config)

return config
