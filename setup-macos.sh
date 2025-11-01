#!/bin/bash
set -euo pipefail

CURR_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo
echo "=====================================" 
echo "Applying specific MacOS configuration"
echo

# Turn on dock autohiding, and speed up the animations
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
killall Dock 2>/dev/null

# Disable screenshot shadow and set the format to JPEG
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type JPG
killall SystemUIServer 2>/dev/null

# Copy the contents of .zshrc-macos to .zshrc
cat "$CURR_SCRIPT_DIR/system-specific/.zshrc-macos" >> $TEMP_ZSHRC

# # Set zsh as the default shell:
# chsh -s $(which zsh)
