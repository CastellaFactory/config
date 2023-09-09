vim.keymap.set('n', ';', ':', {noremap = true})
vim.keymap.set('n', ':', ';', {noremap = true})

vim.keymap.set('n', 'j', 'gj', {noremap = true})
vim.keymap.set('n', 'k', 'gk', {noremap = true})

vim.keymap.set('v', '<', '<gv', {noremap = true})
vim.keymap.set('v', '>', '>gv', {noremap = true})

vim.keymap.set('i', '<C-c>', '<Esc>', {noremap = true})
vim.keymap.set('i', '<Esc>', '<C-c>', {noremap = true})


vim.keymap.set('n', '<C-h>', ':<C-u>help<Space>', {noremap = true})
vim.keymap.set('n', ',h', ':<C-u>help<Space><C-r><C-w><CR>', {noremap = true})
vim.keymap.set('n', '<Space>q', ':<C-u>help quickref<CR>', {noremap = true})

vim.keymap.set({'n', 'v', 'o'}, '<F1>', '<Nop>', {noremap = true})
vim.keymap.set('i', '<F1>', '<Nop>', {noremap = true})


vim.keymap.set('n', 'Q', 'q', {noremap = true})
vim.keymap.set('n', 'q', '<Nop>', {noremap = true})
