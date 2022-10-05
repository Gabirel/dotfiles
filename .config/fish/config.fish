# for macOS
if test (uname) = "Darwin"
    set -x HOMEBREW_BOTTLE_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles

    # add sbin
    if test -d /usr/local/sbin/
        set -x PATH $PATH /usr/local/sbin
    end

    # add Apple-Sillicon support for homebrew
    if test -d /opt/homebrew/bin
        set -x PATH $PATH /opt/homebrew/bin
    end

    # read .linuxify
    if test -f $HOME/.linuxify
        # simple use case: exec bash -c "source ~/.linuxify; exec fish"
        bass source $HOME/.linuxify
    end

    if command -s go > /dev/null
        set -x GOPATH /usr/local/opt/go-package
        # add the go bin path 
        set -x PATH $PATH $GOPATH/bin
    end

    # add the npm bin path 
    if command -s npm > /dev/null
        set -x PATH $PATH /usr/local/Cellar/node/14.5.0/bin
    end

    # ruby environment
    if command -s ruby-install > /dev/null
        source /usr/local/share/chruby/chruby.fish
        source /usr/local/share/chruby/auto.fish
        # make sure version is correct
        chruby ruby-3.1.1
    end

    # add latex binary
    if test -d /usr/local/texlive/2021/bin/
        set -x PATH $PATH /usr/local/texlive/2021/bin/universal-darwin
    end

    # reset activity monitor to bring column back
    alias monitor_reset="rm ~/Library/Preferences/com.apple.ActivityMonitor.plist"

    # proxy related with privoxy
    # set -x http_proxy http://127.0.0.1:1087
    # set -x https_proxy http://127.0.0.1:1087
    function set_proxy -d "set proxy forwarding to privoxy, then to the proxy server"
        set -g -x http_proxy http://127.0.0.1:1087
        and set -g -x https_proxy http://127.0.0.1:1087
    end
    function unset_proxy -d "unset proxy forwarding to privoxy"
        set -e http_proxy
        and set -e https_proxy
    end
end

# use nvim
if command -s nvim > /dev/null
    alias vvim="vim"
    alias vim="nvim"
end

if test -f $HOME/.cargo/env
    # for rust
    set -x RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
    set -x RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup
    set -x PATH $PATH ~/.cargo/bin
end

# use autojump if it exist
if test (uname) = "Darwin"
    # adapt for ARM darwin
    if test -d /opt/homebrew
        [ -f /opt/homebrew/share/autojump/autojump.fish ]; and source /opt/homebrew/share/autojump/autojump.fish
    else
        [ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
    end
else if test (uname) = "Linux"
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

# use jenv
if test -d $HOME/.jenv
    set PATH $HOME/.jenv/bin $PATH
    status --is-interactive; and source (jenv init -|psub)
end

# For CMake
alias cmakedebug='cmake $1 -DCMAKE_BUILD_TYPE=Debug'
alias cmakerelease='cmake $1 -DCMAKE_BUILD_TYPE=Release'

# https://superuser.com/questions/802698/disable-mouse-reporting-in-a-terminal-session-after-tmux-exits-unexpectedly
function resetmouse -d "reset mouse for escaping"
    printf '\e[?1000l'
end

alias git="env LANG=en_GB git"
alias pcs="proxychains4"
alias cpv='rsync -ah --info=progress2'
