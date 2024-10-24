#! /bin/zsh

DEPS=$(pwd)/deps

create_symlink() {
    local source_file=$1
    local target_file=$2
    ln -sf $source_file $target_file
    echo "$source_file -> $target_file"
}

# ALACRITTY
mkdir -p ~/.config/alacritty
create_symlink $DEPS/alacritty/config.toml ~/.config/alacritty/alacritty.toml
mkdir -p ~/.config/alacritty/themes
if [ -z "$(ls -A ~/.config/alacritty/themes)" ]; then
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
    echo "https://github.com/alacritty/alacritty-theme -> ~/.config/alacritty/themes"
else
    echo "https://github.com/alacritty/alacritty-theme -> ~/.config/alacritty/themes"
fi

# GIT
for file in $DEPS/git/.*; do
    create_symlink $file ~/$(basename $file)
done

# HELIX
create_symlink $DEPS/helix ~/.config/helix

# NIX
mkdir -p ~/.config/nix
create_symlink $DEPS/nix/flake.nix ~/.config/nix/flake.nix

# SQLFLUFF
create_symlink $DEPS/sqlfluff/config ~/.sqlfluff

# SSH
create_symlink $DEPS/ssh/config ~/.ssh/config

# STARSHIP
create_symlink $DEPS/starship/config.toml ~/.config/starship.toml

# ZSH
create_symlink $DEPS/zsh/.zshrc ~/.zshrc
