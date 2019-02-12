function fzf_select_history
    set -l query (commandline)

    history | fzf --query=$query |read cmd

    if [ $cmd ]
        commandline $cmd
    else
        commandline ''
    end
end

