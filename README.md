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

### Git 🐛

```shell
ln -sf ~/dotfiles/git/* ~/
```

### Starship 🚀

```shell
ln -sf ~/dotfiles/starship/config.toml ~/.config/starship.toml
```

### Warp 🦀

```shell
mkdir -p ~/.warp/themes
ln -sf ~/dotfiles/warp/rose-pine.yaml ~/.warp/themes/rose-pine.yaml
```

### ZSH 🐚

```shell
rm -f ~/.zshrc
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
```
