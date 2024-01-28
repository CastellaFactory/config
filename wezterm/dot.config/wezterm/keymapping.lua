local wezterm = require 'wezterm'
local platform = require 'utils.platform'

local cmd_or_ctrl = platform.is_mac and 'CMD' or 'CTRL'

return {
    setup = function(config)
        config.keys = {
            { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
            { key = 'F2', mods = 'NONE', action = wezterm.action.ActivateCommandPalette },
            { key = 'F3', mods = 'NONE', action = wezterm.action.ShowLauncher },
            { key = 'F4', mods = 'NONE', action = wezterm.action.ShowTabNavigator },
            { key = 'F12', mods = 'NONE', action = wezterm.action.ShowDebugOverlay },
        }
    end
}
