vim.api.nvim_create_augroup('Vimrc', {})

vim.api.nvim_create_autocmd('BufReadPost', {
	pattern = '*',
    group = 'Vimrc',
	callback = function()
        if vim.fn.line([['"]]) > 1 and vim.fn.line([['"]]) <= vim.fn.line([[$]]) then
            vim.cmd([[normal! g`"]])
        end
    end,
})

if vim.g.is_linux and vim.fn.executable('fcitx-remote') then
    vim.api.nvim_create_autocmd('InsertLeave', {
        pattern = '*',
        group = 'Vimrc',
        callback = function()
            vim.fn.system('fcitx-remote -c')
        end
    })
end