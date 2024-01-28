local wezterm = require 'wezterm'

return {
    setup = function(config)
        config.font = wezterm.font('UDEV Gothic 35NFLG', { weight = 'Bold', italic = false })
        config.font_size = 14
        config.line_height = 0.95
    end
}
