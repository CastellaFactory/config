vim.api.nvim_create_user_command('DeleteTrailingSpaces', function() preserve(vim.cmd, [[%s/\s\+$//eg]]) end, {force = true})
