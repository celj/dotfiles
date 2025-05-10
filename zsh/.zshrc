zstyle ':omz:update' mode auto

plugins=(
  aliases
  git
  macos
  python
  qrcode
  terraform
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

alias dd3='workspace ~/Developer/dd3'
alias desk='workspace ~/Desktop'
alias dot='workspace ~/dotfiles'
alias down='workspace ~/Downloads'
alias lemon='workspace ~/Developer/lemonade'
alias personal='workspace ~/Developer/personal'
alias sand='workspace ~/Developer/sandbox'
alias sec='workspace ~/Developer/security'

alias dev='set_environment development dd3tech-sandbox.org.github'
alias prod='set_environment production dd3tech.org.github'
alias off='
unset AWS_PROFILE &&
unset EXECUTION_ENVIRONMENT &&
unset AWS_ACCESS_KEY_ID &&
unset AWS_SECRET_ACCESS_KEY &&
tailscale down
'

alias gchanges='git ls-files --modified --exclude-standard'
alias gignored='git ls-files --cached --ignored --exclude-standard -z | xargs -0 git rm --cached'
alias guntracked='git ls-files . --exclude-standard --others'
alias repo-info='onefetch --no-art --no-color-palette || true && tokei || true && scc || true'

alias btm='btm --process_memory_as_value'
alias c='cursor'
alias cat='bat --theme=ansi'
alias ls='eza'
alias tree='eza --tree --all --git --ignore-glob ".DS_Store|.git|.next|.ruff_cache|.venv|__pycache__|node_modules|target|venv"'
alias vi='hx'

alias activate='source .venv/bin/activate && which python'
alias new-app='find 2>/dev/null /private/var/folders/ -type d -name com.apple.dock.launchpad -exec rm -rf {} +; killall Dock'
alias randpw='openssl rand -base64 12 | pbcopy'
alias size='du -shc *'

alias dotfiles='cursor -w ~/dotfiles && unalias -m "*" && source ~/.zprofile && source ~/.zshrc'
alias zsh-config='cursor -w ~/.zshrc && unalias -m "*" && source ~/.zprofile && source ~/.zshrc'

alias speedtest='notify speedtest'
alias sysupdate='notify sysupdate'

function workspace() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
  cd "$1" && l
}

function set_environment() {
  export AWS_PROFILE=$1
  export EXECUTION_ENVIRONMENT=$1

  # export AWS_ACCESS_KEY_ID=$(aws configure get $1.aws_access_key_id)
  # export AWS_SECRET_ACCESS_KEY=$(aws configure get $1.aws_secret_access_key)

  echo "AWS_PROFILE: $AWS_PROFILE"
  echo "EXECUTION_ENVIRONMENT: $EXECUTION_ENVIRONMENT"

  tailscale down
  tailscale switch $2
  tailscale up
  tailscale switch --list
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
  echo "Updating brew packages..."
  brew update
  echo "Upgrading brew packages..."
  brew upgrade
  if [[ $(scutil --get LocalHostName) == $MACHINE ]]; then
    echo "Updating brew dump file..."
    brew bundle dump --force --file=$BREW_FILE
  fi
  echo "Cleaning up brew packages..."
  brew bundle cleanup --force --file=$BREW_FILE --zap
  echo "Unaliasing all commands..."
  unalias -m "*"
  echo "Reloading zsh..."
  source ~/.zshrc
  echo "Reloading launchpad ..."
  new-app
  echo "System updated!"
}

function notify() {
  local start_time=$(date +%s)

  "$@"

  local cmd_status=$?

  local end_time=$(date +%s)
  local duration=$((end_time - start_time))

  local formatted_time
  local hours=$((duration / 3600))
  local minutes=$(((duration % 3600) / 60))
  local seconds=$((duration % 60))

  if [ $hours -gt 0 ]; then
    formatted_time="${hours}h ${minutes}m"
  elif [ $minutes -gt 0 ]; then
    formatted_time="${minutes}m ${seconds}s"
  else
    formatted_time="${seconds}s"
  fi

  local message
  if [ $cmd_status -eq 0 ]; then
    message="✅ Succeeded after ${formatted_time}"
  else
    message="❌ Failed after ${formatted_time}"
  fi

  echo -e '\033]777;notify;;'"$message"''
}

function www() {
  url=$(git remote -v | grep '(fetch)' | awk '{print $2}' | sed -E 's|^git@([^:]+):(.*)\.git$|https://\1/\2|')
  branch=$(git branch --show-current)
  [[ -n "$branch" ]] && url="${url}/tree/${branch}"
  open $url
}

function pgurl() {
  local secret_id="$1"
  local profile="$2"

  local secret=$(aws secretsmanager get-secret-value --secret-id "$secret_id" --profile "$profile" --query 'SecretString' --output text)
  local url=$(echo "$secret" | jq -r '"postgresql://\(.username):\(.password)@\(.host):\(.port // "5432")/\(.dbname // "<unknown>")"')

  echo -n "$url" | tee >(pbcopy)
  echo
  echo "$secret" | jq
}
