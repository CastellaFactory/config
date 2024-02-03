return {
    {
        'thinca/vim-quickrun',
        dependencies = { 'lambdalisue/vim-quickrun-neovim-job' },
        keys = {
            { '<Leader>r', '<Plug>(quickrun)',  mode = {'n', 'v'}, silent = true },
        },
        config = function()
            vim.g.quickrun_config = {
                ['_'] = {
                    ['outputter'] = 'buffer',
                    ['outputter/buffer/opener'] = ':botright 8sp',
                    ['outputter/buffer/close_on_empty'] = 1,
                    ['runner'] = 'neovim_job'
                }
            }
        end
    },

    {
        'kana/vim-textobj-entire',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { 'ie',  mode = {'o', 'x'} },
            { 'ae',  mode = {'o', 'x'} },
        }
    },

    {
        'kana/vim-textobj-fold',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { 'iz',  mode = {'o', 'x'} },
            { 'az',  mode = {'o', 'x'} },
        }
    },

    {
        'kana/vim-textobj-function',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { 'if',  mode = {'o', 'x'} },
            { 'af',  mode = {'o', 'x'} },
            { 'iF',  mode = {'o', 'x'} },
            { 'aF',  mode = {'o', 'x'} },
        }
    },

    {
        'kana/vim-textobj-indent',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { 'ii',  mode = {'o', 'x'} },
            { 'ai',  mode = {'o', 'x'} },
        }
    },

    {
        'kana/vim-textobj-line',
        dependencies = { 'kana/vim-textobj-user' },
        keys = {
            { 'il',  mode = {'o', 'x'} },
            { 'al',  mode = {'o', 'x'} },
        }
    },

    {
        'kana/vim-operator-replace',
        dependencies = { 'kana/vim-operator-user' },
        keys = {
            { '_', '<Plug>(operator-replace)',  mode = {'n', 'v', 'o'}, silent = true },
            { 'p', '<Plug>(operator-replace)',  mode = 'v', silent = true },
        }
    },

    {
        'haya14busa/vim-operator-flashy',
        dependencies = { 'kana/vim-operator-user' },
        keys = {
            { 'y', '<Plug>(operator-flashy)',  mode = {'n', 'v', 'o'}, silent = true },
            { 'Y', '<Plug>(operator-flashy)$', mode = 'n', silent = true },
        }
    },

    {
        'machakann/vim-sandwich',
        keys = {
            { 'sa',  mode = {'n', 'o', 'x'} },
            { 'sd',  mode = {'n', 'x'} },
            { 'sdb',  mode = 'n' },
            { 'sr',  mode = {'n','x'} },
            { 'srb',  mode = 'n' },
            { 'ib',  mode = {'o','x'} },
            { 'ab',  mode = {'o','x'} },
            { 'is',  mode = {'o','x'} },
            { 'as',  mode = {'o','x'} },
        }
    },

    {
        'cohama/lexima.vim',
        event = 'InsertEnter',
        init = function()
            vim.g.lexima_ctrlh_as_backspace = 1
        end,
        config = function()
            vim.fn['lexima#add_rule']({ ['at'] = [[\s\+\%#]], ['char'] = '<CR>', ['input'] = [[<C-o>:call setline('.', substitute(getline('.'), '\s\+$', '', '')) | echo 'delete trailing spaces'<CR>a<CR>]] })
        end
    },
}
