local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

require('core').setup(config)
require('fontsetting').setup(config)
require('appearance').setup(config)
require('keymapping').setup(config)
require('domain').setup(config)

return config
