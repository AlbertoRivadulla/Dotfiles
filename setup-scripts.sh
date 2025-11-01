#!/bin/bash
set -euo pipefail

CURR_SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo
echo "=====================================" 
echo "Linking scripts"
echo

SCRIPT_DEST_DIR="$HOME/scripts"

if [[ ! -d "$SCRIPT_DEST_DIR" ]]; then
	mkdir -p "$SCRIPT_DEST_DIR"
fi

scripts_dir=("$CURR_SCRIPT_DIR/scripts/")
if [[ "$(find "$scripts_dir" -mindepth 1 -print -quit 2>/dev/null)" ]]; then
	scripts=("$CURR_SCRIPT_DIR/scripts/"*)
	for script_path in "${scripts[@]}"; do
		script_name=$(basename $script_path)
		dest="$SCRIPT_DEST_DIR/${script_name}"
		echo "Installing $script_path into $dest"
		ln -s "$script_path" "$dest" || true
		chmod +x "$dest"
	done

	# Add the scripts dir to the path
	# cat <<-EOF >> $TEMP_ZSHRC
	cat <<-EOF

	# Add the directory to the scripts to the PATH
	export PATH="\$PATH:$SCRIPT_DEST_DIR"
	EOF

else
	echo "The directory $scripts_dir is empty"
fi
