#! /bin/zsh

create_symlink() {
    local source_file=$1
    local target_file=$2
    local is_directory=${3:-false}

    if [ "$is_directory" = true ]; then
        rm -rf "$target_file"
    fi

    ln -sf "$source_file" "$target_file"
    echo "$source_file -> $target_file"
}

# ALACRITTY
mkdir -p ~/.config/alacritty
create_symlink $(pwd)/alacritty/config.toml ~/.config/alacritty/alacritty.toml
mkdir -p ~/.config/alacritty/themes
if [ -z "$(ls -A ~/.config/alacritty/themes)" ]; then
    git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
    echo "https://github.com/alacritty/alacritty-theme -> ~/.config/alacritty/themes"
else
    echo "https://github.com/alacritty/alacritty-theme -> ~/.config/alacritty/themes"
fi

# GIT
for file in $(pwd)/git/.*; do
    create_symlink $file ~/$(basename $file)
done

# HELIX
create_symlink $(pwd)/helix ~/.config/helix true

# SQLFLUFF
create_symlink $(pwd)/sqlfluff/config ~/.sqlfluff

# SSH
create_symlink $(pwd)/ssh/config ~/.ssh/config

# STARSHIP
create_symlink $(pwd)/starship/config.toml ~/.config/starship.toml

# ZSH
create_symlink $(pwd)/zsh/.zprofile ~/.zprofile
create_symlink $(pwd)/zsh/.zshrc ~/.zshrc
