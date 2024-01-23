export MACHINE=mac-n-cheese

zstyle ':omz:update' mode auto

eval "$(conda "shell.$(basename "${SHELL}")" hook)"

export BREW_FILE=~/dotfiles/brew/pkgs
export CPPFLAGS=-I/opt/homebrew/opt/openssl/include
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LDFLAGS=-L/opt/homebrew/opt/openssl/lib
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export PATH=/opt/homebrew/opt/postgresql@15/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/.cargo/bin:$PATH
export PATH=~/.local/bin:$PATH
export PKG_CONFIG_PATH=/opt/homebrew/opt/openssl/lib/pkgconfig
export ZSH=~/.oh-my-zsh

export NVM_DIR='$HOME/.nvm'
[ -s '/opt/homebrew/opt/nvm/nvm.sh' ] && \. '/opt/homebrew/opt/nvm/nvm.sh'
[ -s '/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm' ] && \. '/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm'

ZSH_THEME='lezama'

plugins=(
    aliases
    git
    macos
    python
    qrcode
)

source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias cat='bat --theme=ansi'
alias cel='conda env list'
alias config-zsh='nvim ~/.zshrc && unalias -m "*" && source ~/.zshrc'
alias dev='export AWS_PROFILE=development EXECUTION_ENVIRONMENT=development && echo "AWS_PROFILE: $AWS_PROFILE" && echo "EXECUTION_ENVIRONMENT: $EXECUTION_ENVIRONMENT" && tailscale switch dd3tech-sandbox.org.github'
alias dotfiles='cd ~/dotfiles && nvim .'
alias gd='ydiff -s -p cat'
alias gignored='git ls-files . --ignored --exclude-standard --others'
alias guntracked='git ls-files . --exclude-standard --others'
alias ls='eza'
alias nb='code'
alias new-app='defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock'
alias pip-reqs='pip freeze --exclude-editable > requirements.txt'
alias prod='export AWS_PROFILE=production EXECUTION_ENVIRONMENT=production && echo "AWS_PROFILE: $AWS_PROFILE" && echo "EXECUTION_ENVIRONMENT: $EXECUTION_ENVIRONMENT" && tailscale switch dd3tech.org.github'
alias randpw='openssl rand -base64 12 | pbcopy'
alias size='du -shc * | grep total'
alias tree='eza --tree'
alias vi='nvim'

function install_ruff() {
  pip install ruff ruff-lsp
}

function cnew() {
    conda create -n "$1" python="$2" -y &&
        conda deactivate &&
        conda activate "$1" &&
        install_ruff &&
        conda env list
}

function crm() {
    conda deactivate &&
        conda activate base &&
        conda env remove -n "$1" -y &&
        conda env list
}

function crp() {
    conda deactivate &&
        conda activate base &&
        conda env remove -n "$1" -y &&
        conda create -n "$1" python="$2" -y &&
        conda deactivate &&
        conda activate "$1" &&
        install_ruff &&
        conda env list
}

function csw() {
    conda deactivate &&
        conda activate "$1" &&
        conda env list
}

function fcd() {
    local dir
    dir=$(find ${1:-.} -type d -not -path '*/\.*' 2>/dev/null | fzf +m) && cd "$dir"
}

function nd() {
    mkdir -p -- "$1" &&
        cd -P -- "$1"
}

function sysupdate() {
    if [[ $(scutil --get LocalHostName) == $MACHINE ]]; then
        echo "Updating brew packages..."
        brew update
        echo "Upgrading brew packages..."
        brew upgrade
        echo "Updating brew dump file..."
        brew bundle dump --force --file=$BREW_FILE
        echo "Cleaning up brew packages..."
        brew bundle cleanup --force --file=$BREW_FILE
        echo "Removing previous aliases..."
        unalias -m "*"
        echo "Reloading zsh..."
        source ~/.zshrc
        echo "Reloading launchpad ..."
        new-app
        echo "System updated!"
    else
        echo "Updating brew packages..."
        brew update
        echo "Upgrading brew packages..."
        brew upgrade
        echo "Cleaning up brew packages..."
        brew bundle cleanup --force --file=$BREW_FILE
        echo "Removing previous aliases..."
        unalias -m "*"
        echo "Reloading zsh..."
        source ~/.zshrc
        echo "Reloading launchpad ..."
        new-app
        echo "System updated!"
    fi
}

function syncsys() {
    if [[ $(scutil --get LocalHostName) == $MACHINE ]]; then
        echo "Updating system..."
        sysupdate
        echo "Pushing changes to github..."
        cd ~/dotfiles
        git add .
        if [ "$1" != "" ]; then
            git commit -m "$1"
        else
            git commit -m update
        fi
        git push
    else
        if [ "$1" != "" ]; then
            echo "You are not on the main machine."
        fi
        echo "Pulling changes from github..."
        cd ~/dotfiles
        git pull --rebase
        echo "Updating system..."
        sysupdate
    fi
}
