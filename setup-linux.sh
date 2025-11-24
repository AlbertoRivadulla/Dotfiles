#!/bin/bash
set -euo pipefail

CURR_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo
echo "=====================================" 
echo "Applying specific Linux configuration"
echo

# Copy the contents of .zshrc-macos to .zshrc
cat "$CURR_SCRIPT_DIR/system-specific/.zshrc-linux" >> $TEMP_ZSHRC

# # Set zsh as the default shell:
# chsh -s $(which zsh)
