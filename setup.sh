#!/bin/bash

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
