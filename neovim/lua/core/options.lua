if vim.fn.has('vim_starting') then
    vim.opt.encoding = 'utf-8'
end

vim.opt.ambiwidth = 'double'
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace = 'start,eol,indent'
vim.opt.backup = true
vim.opt.breakindent = true

if vim.fn.has('unnamedplus') then
    vim.opt.clipboard = 'unnamed,unnamedplus'
else
    vim.opt.clipboard = 'unnamed'
end

vim.opt.cmdheight = 2
vim.opt.completeopt = 'menuone,preview'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'utf-8,cp932'
vim.opt.foldenable = true
vim.opt.foldmethod = 'syntax'
vim.opt.history = 100
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.laststatus = 3
vim.opt.mouse = 'a'
vim.opt.errorbells = false
vim.opt.nrformats:remove('octal')
vim.opt.number = true
vim.opt.pumheight = 25
vim.opt.ruler = true
vim.opt.scrolloff = 3
vim.opt.shiftround = true
vim.opt.shortmess = 'aoOIt'
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.showtabline = 2
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 5
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.statusline = [[%f %y %r %m%=%{(&fenc!=''?&fenc:&enc).':'.&ff}|%l:%v|%p%%]]
vim.opt.tabpagemax = 20
vim.opt.termguicolors = true
vim.opt.ttimeoutlen = 50
vim.opt.ttyfast = true
vim.opt.updatetime = 500
vim.opt.virtualedit = 'block'
vim.opt.visualbell = true
vim.opt.whichwrap = 'b,s,h,l,[,],<,>,~'
vim.opt.wildchar = ('\t'):byte()
vim.opt.wildmode = 'longest:full,full'
vim.opt.wrap = true
vim.opt.wrapscan = true

function my_tabline()
    local s = ''
    for i = 1, vim.fn.tabpagenr('$'), 1 do
        local bufnrs = vim.fn.tabpagebuflist(i)
        local bufnr = bufnrs[vim.fn.tabpagewinnr(i)]
        local no = i
        local mod = vim.fn.getbufvar(bufnr, '&modified') == 1 and '!' or ' '
        local title = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t')
        title = '[' .. (vim.fn.empty(title) == 1 and 'No Name' or title) .. ']'
        s = s .. '%' .. i .. 'T'
        s = s .. '%#' .. (i == vim.fn.tabpagenr() and 'TabLineSel' or 'TabLine') .. '#'
        s = s .. no .. ':' .. title
        s = s .. mod
        s = s .. '%#TabLineFill# '
    end
    s = s .. '%#TabLineFill#%T%=%#TabLine#'
    return s
end

vim.opt.tabline ='%!v:lua.my_tabline()'
