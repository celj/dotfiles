eval "$(/opt/homebrew/bin/brew shellenv)"

export BREW_FILE=~/dotfiles/Brewfile
export CPPFLAGS=-I/opt/homebrew/opt/llvm/include
export EDITOR=hx
export HOMEBREW_NO_ENV_HINTS=1
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LDFLAGS=-L/opt/homebrew/opt/llvm/lib
export MACHINE=mac-n-cheese
export NODE_NO_WARNINGS=1
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export PATH=/opt/homebrew/opt/postgresql@16/bin:$PATH
export PATH=/opt/homebrew/opt/rustup/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=~/.cargo/bin:$PATH
export PATH=~/.config/composer/vendor/bin:$PATH
export PATH=~/.local/bin:$PATH
export VISUAL=$EDITOR
export ZSH=~/.oh-my-zsh

export PNPM_HOME="~/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
