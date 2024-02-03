vim.cmd.language('messages C')

local os_name = vim.loop.os_uname().sysname

vim.g.is_mac = os_name == 'Darwin'
vim.g.is_linux = os_name == 'Linux'
vim.g.is_windows = os_name == 'Windows_NT'
vim.g.is_wsl = vim.fn.has('wsl') == 1
vim.g.vim_path = vim.fn.stdpath('config')
