function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    set dir (prompt_pwd)
    set parts (string split "/" $dir)
    set trunc_dir (string join "" $parts[-1])
    set fstring (string join " " $trunc_dir)
    printf '%s%s%s 󰁕 '  \
      (set_color $fish_color_cwd) "$fstring" (set_color normal)
end

