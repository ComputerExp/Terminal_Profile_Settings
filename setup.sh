#!/bin/bash

# Rename the current directory to dotfiles

# 1. Get the current absolute path of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 2. Extract the parent directory path and the current folder name
PARENT_DIR=$(dirname "$SCRIPT_DIR")
CURRENT_NAME=$(basename "$SCRIPT_DIR")

# 3. Define the strict target name your aliases expect
TARGET_NAME="dotfiles"

# 4. Only rename if the current name doesn't match the target
if [ "$CURRENT_NAME" != "$TARGET_NAME" ]; then
    mv "$PARENT_DIR/$CURRENT_NAME" "$PARENT_DIR/$TARGET_NAME"
    echo "SUCCESS: Repository directory renamed to '$TARGET_NAME'."
    echo "Please run: cd ../$TARGET_NAME to refresh your terminal."
else
    echo "Directory name is already correct."
fi

# Get the absolute path to this dotfiles directory
DOT_DIR=$(pwd)

echo "Setting up your environment..."

# List of files to link (Format: "source_file:destination_path")
# Note: We keep the dot in the destination so the apps find them
FILES=(
    "bash_aliases:~/.bash_aliases"
    "vimrc:~/.vimrc"
    "tmux.conf:~/.tmux.conf"
)

for entry in "${FILES[@]}"; do
    # Split the entry into source and target
    src="${entry%%:*}"
    dst="${entry#*:}"

    # Expand the tilde (~) to the full home path
    dst_eval=$(eval echo "$dst")

    echo "Linking $src to $dst_eval"
    
    # -s: symbolic, -f: force (overwrites existing files), -v: verbose
    ln -sfv "$DOT_DIR/$src" "$dst_eval"
done

echo "Done! Restart your terminal or run 'source ~/.bashrc'."
