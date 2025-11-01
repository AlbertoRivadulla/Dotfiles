#!/bin/bash
set -euo pipefail

CURR_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOT_FILES_SRC_DIR="$CURR_SCRIPT_DIR/files"

echo
echo "=====================================" 
echo "Setting up dotfiles"

# Copy .zshrc
cp $DOT_FILES_SRC_DIR/.zshrc $TEMP_ZSHRC

dotfiles_to_link=(
    ".config/kitty"
    ".config/nvim"
)

for dotfile_path in "${dotfiles_to_link[@]}"; do
    src_dotfile_path="$CURR_SCRIPT_DIR/files/$dotfile_path"
    dest_dotfile_path="$HOME/$dotfile_path"

    echo
    echo "Creating link for $dotfile_path into $dest_dotfile_path"

    if [[ ! -f "$src_dotfile_path" && ! -d "$src_dotfile_path" ]]; then
        echo "The path $src_dotfile_path is empty"
        continue
    fi

    if [[ -L "$dest_dotfile_path" ]]; then
        echo "There is already a symlink at $dest_dotfile_path. Skipping."
        continue
    fi

    if [[ -f "$dest_dotfile_path" || -d "$dest_dotfile_path" ]] && [[ ! -L "$dest_dotfile_path" ]]; then
        read -rp "There is already a file or directory at $dest_dotfile_path. Do you want to remove it? [y/N] " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            rm -rf "$dest_dotfile_path"
        else
            continue
        fi
    fi

    ln -s "$src_dotfile_path" "$dest_dotfile_path" 2>/dev/null
done
