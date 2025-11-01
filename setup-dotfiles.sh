#!/bin/bash
set -euo pipefail

CURR_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOT_FILES_SRC_DIR="$CURR_SCRIPT_DIR/files"

echo
echo "=====================================" 
echo "Setting up dotfiles"
echo

# Copy .zshrc
cp $DOT_FILES_SRC_DIR/.zshrc $TEMP_ZSHRC


# TODO: Link all other dotfiles







