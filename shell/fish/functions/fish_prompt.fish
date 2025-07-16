function fish_prompt -d "Write out the prompt"
    set dir (prompt_pwd)
    set parts (string split "/" $dir)
    set trunc_dir (string join "" $parts[-1])
    set fstring (string join " " $trunc_dir)
    set git_branch (git branch --show-current 2>/dev/null)
    set is_nix_shell (echo $NIX_SHELL)
    set is_tmux_session (echo $TMUX)
    set hour (date +"%H:%M")
    set current_workspace "workspace: $(hyprctl activeworkspace -j | jq '.id')"

    # Build prompt parts conditionally with colors
    set prompt_parts (set_color cyan)$hour(set_color normal)

    if test -n "$git_branch"
        set -a prompt_parts (set_color yellow)"$git_branch"(set_color normal)
    end

    if test -n "$is_nix_shell"
        set -a prompt_parts (set_color blue)"󱄅"(set_color normal)
    end

    if test -n "$is_tmux_session"
        set -a prompt_parts (set_color magenta)"(tmux)"(set_color normal)
    end

    set -a prompt_parts (set_color green)"$current_workspace"(set_color normal)
    set -a prompt_parts (set_color brwhite)"$fstring"(set_color normal)

    printf '%s\n' (string join " " $prompt_parts)
    printf '%s ' (set_color red)';'(set_color normal)
end
