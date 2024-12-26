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

# GIT
for file in $(pwd)/git/.*; do
    create_symlink $file ~/$(basename $file)
done

# GHOSTTY
create_symlink $(pwd)/ghostty ~/.config/ghostty true

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
