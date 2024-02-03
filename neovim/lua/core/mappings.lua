vim.keymap.set('n', ';', ':', {noremap = true})
vim.keymap.set('n', ':', ';', {noremap = true})

vim.keymap.set('n', 'j', 'gj', {noremap = true})
vim.keymap.set('n', 'k', 'gk', {noremap = true})

vim.keymap.set('v', '<', '<gv', {noremap = true})
vim.keymap.set('v', '>', '>gv', {noremap = true})

vim.keymap.set('i', '<C-c>', '<Esc>', {noremap = false, silent = true})

vim.keymap.set('n', '<C-h>', ':<C-u>help<Space>', {noremap = true})
vim.keymap.set('n', ',h', ':<C-u>help<Space><C-r><C-w><CR>', {noremap = true})
vim.keymap.set('n', '<Space>q', ':<C-u>help<Space>quickref<CR>', {noremap = true})

vim.keymap.set({'n', 'v', 'o'}, '<F1>', '<Nop>', {noremap = true})
vim.keymap.set('i', '<F1>', '<Nop>', {noremap = true})

vim.keymap.set('n', 'Q', 'q', {noremap = true})
vim.keymap.set('n', 'q', '<Nop>', {noremap = true})

vim.keymap.set({'n', 'v', 'o'}, '<C-z>', '<Nop>', {noremap = true})
vim.keymap.set('n', 'ZQ', '<Nop>', {noremap = true})

vim.keymap.set('n', 'ZQ', '<Nop>', {noremap = true})

vim.keymap.set('n', 'gc', '`[v`]', {noremap = true})
vim.keymap.set({'v', 'o'}, 'gc', ':<C-u>normal! gc', {noremap = true})
vim.keymap.set({'v', 'o'}, 'gv', ':<C-u>normal! gv', {noremap = true})


vim.keymap.set('n', '<Space>cd', cd_to_current_buffer_dir, {noremap = true})
vim.keymap.set('n', '<Space>cgd', cd_to_git_root_dir, {noremap = true})

vim.keymap.set('n', '<Space>ob', toggle_background_color, {noremap = true})
vim.keymap.set('n', '<Space>ow', ':<C-u>setlocal wrap! wrap?<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<Space>sp', ':<C-u>DeleteTrailingSpaces<CR>', {noremap = true})

vim.keymap.set('n', '<Space>r', ':<C-u>registers<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<Space>/', ':<C-u>nohlsearch<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<Space>v', 'zMzv', {noremap = true, silent = true})

vim.keymap.set('i', '<C-a>', '<Home>', {noremap = true})
vim.keymap.set('i', '<C-e>', function() return vim.fn.pumvisible() == 1 and '<C-e>' or '<End>' end, {noremap = true, expr = true})
vim.keymap.set('i', '<C-d>', '<Del>', {noremap = true})
vim.keymap.set('i', '<Up>', function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>' end, {noremap = true, expr = true})
vim.keymap.set('i', '<Down>', function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>' end, {noremap = true, expr = true})

vim.keymap.set('c', '<C-p>', '<Up>', {noremap = true})
vim.keymap.set('c', '<C-n>', '<Down>', {noremap = true})
vim.keymap.set('c', '<C-a>', '<Home>', {noremap = true})
vim.keymap.set('c', '<C-e>', '<End>', {noremap = true})

vim.keymap.set('ca', 'w!!', 'w !sudo tee % > /dev/null', {noremap = true})
vim.keymap.set('ca', 't', 'tabedit', {noremap = true})
