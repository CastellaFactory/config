vim.cmd('language messages C')

vim.g.is_mac = vim.fn.has('mac') or vim.fn.has('macunix')
vim.g.is_linux = not vim.g.mac and vim.fn.has('unix')
vim.g.is_windows = vim.fn.has('win32')

vim.g.my_init = vim.fn.stdpath('config') .. '/init.lua'
