function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    set dir (prompt_pwd)
    set parts (string split "/" $dir)
    set trunc_dir (string join "" $parts[-1])
    set fstring (string join " " $trunc_dir)

    set git_branch (git branch --show-current 2>/dev/null)

    if test -n "$git_branch"
        set branch_string "($git_branch)"
    else
        set branch_string ""
    end

    printf '%s%s%s %s\n; '  \
      (set_color $fish_color_cwd) "$fstring" (set_color normal) "$branch_string"
end

