export MACHINE=mac-n-cheese

zstyle ':omz:update' mode auto

eval "$(starship init zsh)"

export EDITOR=hx
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export MYPYDEPS=('notebook' 'poetry' 'pre-commit' 'pyright' 'python-dotenv' 'ruff' 'ruff-lsp')
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export PATH=$(brew --prefix)/opt/llvm/bin:$PATH
export PATH=/opt/homebrew/opt/postgresql@15/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/.cargo/bin:$PATH
export PATH=~/.local/bin:$PATH
export VISUAL=$EDITOR
export ZSH=~/.oh-my-zsh

plugins=(
  aliases
  git
  macos
  python
  qrcode
  terraform
)

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)

function set_environment() {
  export AWS_PROFILE=$1
  export EXECUTION_ENVIRONMENT=$1

  export AWS_ACCESS_KEY_ID=$(aws configure get $1.aws_access_key_id)
  export AWS_SECRET_ACCESS_KEY=$(aws configure get $1.aws_secret_access_key)

  echo "AWS_PROFILE: $AWS_PROFILE"
  echo "EXECUTION_ENVIRONMENT: $EXECUTION_ENVIRONMENT"

  tailscale up
  tailscale switch $2
}

alias dev='set_environment development dd3tech-sandbox.org.github'
alias prod='set_environment production dd3tech.org.github'

alias activate='source .venv/bin/activate && which python'
alias btm='btm --process_memory_as_value'
alias c='cursor'
alias cat='bat --theme=ansi'
alias dotfiles='vi ~/.dotfiles'
alias gchanges='git ls-files --modified --exclude-standard'
alias gignored='git ls-files --cached --ignored --exclude-standard -z | xargs -0 git rm --cached'
alias guntracked='git ls-files . --exclude-standard --others'
alias ls='eza'
alias new-app='defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock'
alias personal='cd ~/Documents/personal && ls -a'
alias randpw='openssl rand -base64 12 | pbcopy'
alias repo-info='onefetch --no-art --no-color-palette || true && tokei || true && scc || true'
alias size='du -shc *'
alias tree='eza --tree --all --git --ignore-glob ".DS_Store|.git|.next|.ruff_cache|.venv|__pycache__|node_modules|target|venv"'
alias vi='hx'
alias work='cd ~/Documents/work && ls -a'
alias zsh-config='vi ~/.zshrc && unalias -m "*" && source ~/.zshrc'

function pyactivate() {
  activate
}

function pyclean() {
  rm -f poetry.lock
  rm -rf .ruff_cache
  rm -rf .venv
}

function pydeps() {
  uv pip install --upgrade pip
  uv pip install $MYPYDEPS
}

function pyinfo() {
  echo "Virtual environment set to $(python --version)"
  which python
}

function pyreqs() {
  if [ -f "pyproject.toml" ]; then
    if grep -q "poetry" pyproject.toml; then
      poetry install --no-root
    fi
    if grep -q "uv" pyproject.toml; then
      uv lock --python "$1"
      uv sync --frozen --python "$1"
    fi
  elif [ -f "requirements.txt" ]; then
    uv pip install -r requirements.txt
  fi
}

function pyvenv() {
  uv venv --python="$1" .venv
}

function pyinit() {
  force=0
  version=""

  for arg in "$@"; do
    if [[ "$arg" == "--force" || "$arg" == "-f" ]]; then
      force=1
    elif [[ -z "$version" ]]; then
      version="$arg"
    fi
  done

  if [[ $force -eq 1 ]]; then
    pyclean
  fi

  if [[ -z "$version" && -f "Dockerfile" ]]; then
    version=$(grep -Eo 'FROM.*python:[0-9]+\.[0-9]+' Dockerfile | grep -Eo '[0-9]+\.[0-9]+')
  fi

  if [[ -z "$version" && -f ".python-version" ]]; then
    version=$(cat .python-version)
  fi

  if [[ -z "$version" && -f "pyproject.toml" ]]; then
    version=$(grep -E '^(requires-python|python)' pyproject.toml | grep -Eo '[0-9]+(\.[0-9]+)+(<[0-9\.]+)?' | awk -F '[<>]' '{print $NF}' | sort -V | tail -n 1)
  fi

  pyvenv "$version"
  activate
  pydeps
  pyreqs "$version"
  pyinfo
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
    echo "Updating all packages..."
    darwin-rebuild switch --flake ~/.config/nix --impure
    echo "Removing previous aliases..."
    unalias -m "*"
    echo "Reloading zsh..."
    source ~/.zshrc
    echo "Reloading launchpad ..."
    new-app
    echo "System updated!"
  else
    echo "Updating all packages..."
    darwin-rebuild switch --flake ~/.config/nix --impure
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
    cd ~/.dotfiles
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
    cd ~/.dotfiles
    git pull --rebase
    echo "Updating system..."
    sysupdate
  fi
}

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
