return {
    {
        'itchyny/vim-haskell-indent',
        ft = 'haskell'
    },

    {
        'rhysd/vim-clang-format',
        dependencies = { 'kana/vim-operator-user' },
        keys = {
            { '<Leader>x', '<Plug>(operator-clang-format)',  mode = {'n', 'v', 'o'}, silent = true },
        },
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                group = 'Vimrc',
                pattern = {'c', 'cpp'},
                callback = function()
                    vim.keymap.set({'n', 'v', 'o'}, '<Leader>x', '<Plug>(operator-clang-format)', {noremap = false, buffer = true})
                end
            })
            vim.g['clang_format#style_options'] = {
                ['AccessModifierOffset'] = -4,
                ['AllowShortIfStatementsOnASingleLine'] = 'false',
                ['AllowShortLoopsOnASingleLine'] = 'false',
                ['BreakBeforeBraces'] = 'Stroustrup',
                ['BreakBeforeBinaryOperators'] = 'NonAssignment',
                ['IndentCaseLabels'] = 'false',
                ['IndentWidth'] = 4,
                ['PointerAlignment'] = 'Left'
            }
        end
    }
}
