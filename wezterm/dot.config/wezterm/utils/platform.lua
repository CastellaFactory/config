local wezterm = require('wezterm')

return {
   is_win = string.find(wezterm.target_triple, 'windows') ~= nil,
   is_linux = string.find(wezterm.target_triple, 'linux') ~= nil,
   is_mac = string.find(wezterm.target_triple, 'apple') ~= nil,
}