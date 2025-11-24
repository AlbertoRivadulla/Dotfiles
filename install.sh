#!/bin/bash
set -euo pipefail

CURR_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export TEMP_ZSHRC=$CURR_SCRIPT_DIR/.zshrc_temp

# Make sure this file is deleted when exiting or interrupting the execution
cleanup() {
	rm -f $TEMP_ZSHRC
}
trap cleanup EXIT ERR TERM
trap $(cleanup; exit 130) INT # Special case for Ctrl+C

# Set up configuration files
if [[ -d $CURR_SCRIPT_DIR/scripts ]]; then
	bash $CURR_SCRIPT_DIR/setup-dotfiles.sh
fi

# Link scripts
if [[ -d $CURR_SCRIPT_DIR/scripts ]]; then
	bash $CURR_SCRIPT_DIR/setup-scripts.sh
fi

# Particular configuration for MacOS or Linux
if [[ $(uname) == "Darwin" ]]; then
	bash $CURR_SCRIPT_DIR/setup-macos.sh
elif [[ $(uname) == "Linux" ]]; then
	bash $CURR_SCRIPT_DIR/setup-linux.sh
fi

# Replace the .zshrc in $HOME with the one built here
if [[ -f $HOME/.zshrc ]]; then
	if ! diff -q $HOME/.zshrc $TEMP_ZSHRC >/dev/null; then
		echo ".zshrc is already present in HOME. This is the diff with the one constructed:"
		echo
		diff --color=always -u $HOME/.zshrc $TEMP_ZSHRC || true
		echo

		read -rp "Apply changes? (y/N) " confirm
		if [[ "$confirm" =~ ^[Yy]$ ]]; then
			cp $TEMP_ZSHRC $HOME/.zshrc
		fi
	else
		cp $TEMP_ZSHRC $HOME/.zshrc
	fi
else
	cp $TEMP_ZSHRC $HOME/.zshrc
fi
