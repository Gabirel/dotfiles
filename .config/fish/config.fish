thefuck --alias | source
alias t="task"
alias ta="task add"
alias tan="task annotate"
alias td="task done"
alias to="taskopen"
alias t-="task delete"


# MacOS Start
set -x HOMEBREW_BOTTLE_DOMAIN https://mirrors.ustc.edu.cn/homebrew-bottles
source ~/.linuxify
# For Rust
source $HOME/.cargo/env
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# For CMake
alias cmakedebug='cmake $1 -DCMAKE_BUILD_TYPE=Debug'
alias cmakerelease='cmake $1 -DCMAKE_BUILD_TYPE=Release'

alias git="env LANG=en_GB git"
alias ls="ls --color -h --group-directories-first"
alias lt="ls --human-readable --size -1 -S --classify"
alias pcs="proxychains4"
alias cpv='rsync -ah --info=progress2'
