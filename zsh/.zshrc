export MACHINE=mac-n-cheese

zstyle ':omz:update' mode auto

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"

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

alias activate='source .venv/bin/activate'
alias cat='bat --theme=ansi'
alias dev='export AWS_PROFILE=development EXECUTION_ENVIRONMENT=development && echo "AWS_PROFILE: $AWS_PROFILE" && echo "EXECUTION_ENVIRONMENT: $EXECUTION_ENVIRONMENT" && tailscale switch dd3tech-sandbox.org.github'
alias dotfiles='cd ~/dotfiles && code --new-window --wait .'
alias gd='ydiff -s -p cat'
alias gignored='git ls-files . --ignored --exclude-standard --others'
alias guntracked='git ls-files . --exclude-standard --others'
alias ls='eza'
alias new-app='defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock'
alias pip-reqs='uv pip freeze --exclude-editable > requirements.txt'
alias prod='export AWS_PROFILE=production EXECUTION_ENVIRONMENT=production && echo "AWS_PROFILE: $AWS_PROFILE" && echo "EXECUTION_ENVIRONMENT: $EXECUTION_ENVIRONMENT" && tailscale switch dd3tech.org.github'
alias randpw='openssl rand -base64 12 | pbcopy'
alias repo-info='onefetch --no-art --no-color-palette && tokei && scc'
alias size='du -shc * | grep total'
alias tree='eza --tree --all --ignore-glob .git'
alias vi='nvim'
alias zsh-config='code --new-window --wait ~/.zshrc && unalias -m "*" && source ~/.zshrc'

function pydeps() {
    pip install --quiet --upgrade pip
    pip install --quiet poetry python-dotenv
}

function venv() {
    rm -rf .venv
    rm -f *.lock
    virtualenv --quiet .venv --python="$1"
    activate
    pydeps
    echo "Virtual environment set to $(python --version)"
    which python
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
