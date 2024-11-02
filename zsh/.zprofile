eval "$(/opt/homebrew/bin/brew shellenv)"

export BREW_FILE=$HOME/dotfiles/Brewfile
export EDITOR=hx
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export MACHINE=mac-n-cheese
export MYPYDEPS=('notebook' 'poetry' 'pre-commit' 'pyright' 'python-dotenv' 'ruff' 'ruff-lsp')
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export PATH=/opt/homebrew/opt/postgresql@15/bin:$PATH
export PATH=/opt/homebrew/opt/rustup/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$(brew --prefix)/opt/llvm/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export VISUAL=$EDITOR
export ZSH=$HOME/.oh-my-zsh

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

zstyle ':omz:update' mode auto
