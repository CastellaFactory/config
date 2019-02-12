function fzf_select_ghq_repository
    set -l query (commandline)

    ghq list | fzf --query="$query" | read line

    if [ $line ]
        cd (ghq root)/$line
        commandline -f repaint
    end
end

