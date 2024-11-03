# My dotfiles

> OS: macOS Sequoia

First, install `brew` and `omz`.

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rustup default stable
```

Then, symlink files.

```shell
chmod +x symlink.sh
./symlink.sh
```

Finally, install all packages with

```shell
brew bundle --file=$HOME/dotfiles/Brewfile
```
