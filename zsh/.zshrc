export MACHINE=mac-n-cheese

zstyle ':omz:update' mode auto

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"

export BREW_FILE=~/dotfiles/brew/pkgs
export CPPFLAGS=-I/opt/homebrew/opt/openssl/include
export EDITOR=hx
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LDFLAGS=-L/opt/homebrew/opt/openssl/lib
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export PATH=$(brew --prefix)/opt/llvm/bin:$PATH
export PATH=/opt/homebrew/opt/postgresql@15/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/.cargo/bin:$PATH
export PATH=~/.local/bin:$PATH
export PKG_CONFIG_PATH=/opt/homebrew/opt/openssl/lib/pkgconfig
export VISUAL=$EDITOR
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
    terraform
)

source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function set_environment() {
    export AWS_PROFILE=$1
    export EXECUTION_ENVIRONMENT=$1
    echo "AWS_PROFILE: $AWS_PROFILE"
    echo "EXECUTION_ENVIRONMENT: $EXECUTION_ENVIRONMENT"
    tailscale up
    tailscale switch $2
}

alias dev='set_environment development dd3tech-sandbox.org.github'
alias prod='set_environment production dd3tech.org.github'

alias activate='source venv/bin/activate'
alias btm='btm --mem_as_value'
alias cat='bat --theme=ansi'
alias dotfiles='vi ~/dotfiles'
alias gchanges='git ls-files --modified --exclude-standard'
alias gignored='git ls-files --cached --ignored --exclude-standard -z | xargs -0 git rm --cached'
alias guntracked='git ls-files . --exclude-standard --others'
alias ls='eza'
alias new-app='defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock'
alias personal='cd ~/Documents && l'
alias pip-reqs='uv pip freeze --exclude-editable > requirements.txt'
alias randpw='openssl rand -base64 12 | pbcopy'
alias repo-info='onefetch --no-art --no-color-palette && tokei && scc'
alias size='du -shc * | grep total'
alias tree='eza --tree --all --git --ignore-glob ".git|venv|.DS_Store|target"'
alias vi='hx'
alias work='cd ~/Desktop && l'
alias zsh-config='vi ~/.zshrc && unalias -m "*" && source ~/.zshrc'

function pydeps() {
    pip install --upgrade pip
    pip install notebook poetry python-dotenv
}

function venv() {
    rm -f *.lock
    rm -rf .venv
    rm -rf venv
    rm -rf .ruff_cache
    virtualenv --verbose venv --python="$1"
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
            git commit -m "sync update 🚀"
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
