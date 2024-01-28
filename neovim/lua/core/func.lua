function cd_to_current_buffer_dir()
    vim.cmd.lcd({[[%:p:h]]})
    vim.cmd.pwd({})
end

function cd_to_git_root_dir()
    local save_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p')
    vim.cmd.lcd({[[%:p:h]]})
    if (string.find(vim.fn.system('git rev-parse --is-inside-work-tree'), 'true') ~= nil) then
        vim.cmd.lcd({vim.fn.trim(vim.fn.fnamemodify(vim.fn.system('git rev-parse --show-toplevel'), ':p'))})
        vim.cmd.pwd({})
    else
        vim.cmd.echohl({[[ErrorMsg]]})
        vim.cmd.echomsg({[['This file is not inside git tree.']]})
        vim.cmd.echohl({[[none]]})
        vim.cmd.lcd({save_dir})
    end
end
