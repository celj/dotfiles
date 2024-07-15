# My dotfiles

> OS: macOS Ventura

First, install `brew` and `git`.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git gh
```

Then, clone this repo into home directory (`~` or `$HOME`) to `.dotfiles`.

```shell
cd ~
gh repo clone celj/dotfiles ~/.dotfiles
```

## Packages needed

```shell
brew bundle install --all --file=~/.dotfiles/brew/pkgs
brew bundle cleanup --force --file=~/.dotfiles/brew/pkgs
```

## Symlink files

```shell
stow -d $HOME/.dotfiles -t $HOME
```
