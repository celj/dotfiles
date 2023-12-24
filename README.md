# My dotfiles

> OS: macOS Ventura

First, install `brew` and `git`.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git
```

Then, clone this repo into home directory (`~` or `$HOME`).

```shell
cd ~
git clone https://github.com/celj/dotfiles.git ~/dotfiles
```

## Packages needed

```shell
brew bundle install --all --file=~/dotfiles/brew/pkgs
brew bundle cleanup --force --file=~/dotfiles/brew/pkgs
```

## Symlink files

### git

```shell
ln -sf ~/dotfiles/git/* ~/
```

### neovim

```shell
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
rm -rf ~/.config/nvim/lua/custom
rm -rf ~/.local/share/nvim
mkdir -p ~/.config/nvim/lua/custom
ln -sf ~/dotfiles/nvim/custom ~/.config/nvim/lua
```

### warp

```shell
mkdir -p ~/.warp/themes
ln -sf ~/dotfiles/warp/rose-pine.yaml ~/.warp/themes/rose-pine.yaml
```

### zsh

```shell
rm -f ~/.zshrc
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/lezama.zsh-theme ~/.oh-my-zsh/themes/lezama.zsh-theme
```
