# for macOS
if test (uname)="Darwin"
    set -x HOMEBREW_BOTTLE_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles

    # read .linuxify
    if test -f $HOME/.linuxify
        source $HOME/.linuxify
    end
end

if test -f $HOME/.cargo/env
    # for rust
    source $HOME/.cargo/env
    set -x RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
    set -x RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup
end

# use autojump if it exist
if test (uname)="Darwin"
    [ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
else if test (uname)="Linux"
    [ -f /usr/share/autojump/autojump.fish ]; and source /usr/share/autojump/autojump.fish
end

# use exa for the good
if command -s exa > /dev/null
    alias exa="exa --group-directories-first"
    alias l="exa"
    alias ls="exa"
    alias la="exa -a"
    alias ll="exa -l"
    alias lg="exa -l --git --header"
    alias lt="exa -T"
    alias lla="exa -la"
    alias llt="exa -lT"
    alias lat="exa -aT"
    alias llat="exa -aT"
else
    alias ls="ls --color=always -h --group-directories-first"
    alias lt="ls --human-readable --size -1 -S --classify"
end

# import thefuck
if command -s thefuck > /dev/null
    thefuck --alias | source
end

# import task
if command -s task > /dev/null
    alias t="task"
    alias ta="task add"
    alias tan="task annotate"
    alias td="task done"
    alias to="taskopen"
    alias t-="task delete"
end

# For CMake
alias cmakedebug='cmake $1 -DCMAKE_BUILD_TYPE=Debug'
alias cmakerelease='cmake $1 -DCMAKE_BUILD_TYPE=Release'

# https://superuser.com/questions/802698/disable-mouse-reporting-in-a-terminal-session-after-tmux-exits-unexpectedly
alias resetmouse='printf '"'"'\e[?1000l'"'"

alias git="env LANG=en_GB git"
alias pcs="proxychains4"
alias cpv='rsync -ah --info=progress2'
