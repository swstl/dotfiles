#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
MARKER=".--link-here--"
BACKUP_DIR="$HOME/old_config"

USE_SUDO=""
DID_BACKUP=false

run() {
    if ! "$@" 2>/dev/null; then
        if [ -z "$USE_SUDO" ]; then
            echo "  retrying with sudo..."
            USE_SUDO=sudo
        fi
        $USE_SUDO "$@"
    fi
}

backup_item() {
    local dest="$1"
    local backup_path="$BACKUP_DIR$dest"

    run mkdir -p "$(dirname "$backup_path")"
    run rm -rf "$backup_path"
    run cp -a "$dest" "$backup_path"
    run rm -rf "$dest"
    echo "  backup: $dest -> $backup_path"
    DID_BACKUP=true
}

link_item() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        local current
        current="$(readlink "$dest")"
        if [ "$current" = "$src" ]; then
            echo "  ok: $dest"
            return
        fi
        # Existing symlink pointing elsewhere, update it
        echo "  update: $dest -> $src"
        run ln -sfn "$src" "$dest"
    elif [ -e "$dest" ]; then
        # Real file/dir exists, back it up first
        backup_item "$dest"
        run mkdir -p "$(dirname "$dest")"
        run ln -sn "$src" "$dest"
        echo "  link: $dest -> $src"
    else
        echo "  link: $dest -> $src"
        run mkdir -p "$(dirname "$dest")"
        run ln -sn "$src" "$dest"
    fi
}

process_dir() {
    local src_dir="$1"
    local dest_dir="$2"

    if [ -f "$src_dir/$MARKER" ]; then
        # Marker found: symlink all siblings (files and dirs) in this directory
        for item in "$src_dir"/*; do
            [ -e "$item" ] || continue
            local name
            name="$(basename "$item")"
            link_item "$item" "$dest_dir/$name"
        done
        # Also handle hidden files (excluding . .. and the marker itself)
        for item in "$src_dir"/.*; do
            [ -e "$item" ] || continue
            local name
            name="$(basename "$item")"
            [ "$name" = "." ] || [ "$name" = ".." ] || [ "$name" = "$MARKER" ] && continue
            link_item "$item" "$dest_dir/$name"
        done
        return
    fi

    # No marker: process each item individually
    for item in "$src_dir"/* "$src_dir"/.*; do
        [ -e "$item" ] || continue
        local name
        name="$(basename "$item")"
        [ "$name" = "." ] || [ "$name" = ".." ] && continue

        if [ -f "$item" ]; then
            link_item "$item" "$dest_dir/$name"
        elif [ -d "$item" ]; then
            process_dir "$item" "$dest_dir/$name"
        fi
    done
}

# Process home/ -> ~/
if [ -d "$DOTFILES/home" ]; then
    echo "Installing home configs..."
    process_dir "$DOTFILES/home" "$HOME"
fi

# Process root/ -> /
if [ -d "$DOTFILES/root" ]; then
    echo "Installing root configs..."
    USE_SUDO=""
    process_dir "$DOTFILES/root" ""
fi

if $DID_BACKUP; then
    echo -e "\033[33mOld configs backed up in $BACKUP_DIR\033[0m"
fi

# Allow sddm to traverse home dir so it can read theme files symlinked from dotfiles
if id sddm &>/dev/null; then
    echo "Granting sddm traverse access to $HOME..."
    sudo setfacl -m u:sddm:x "$HOME"
fi


echo "Setting default shell to zsh..."
ZSH_PATH="$(command -v zsh)"
if [ -z "$ZSH_PATH" ]; then
    echo -e "\033[31mzsh is not installed.\033[0m"
elif [ "$SHELL" != "$ZSH_PATH" ]; then
    if chsh -s "$ZSH_PATH"; then
        echo "Shell changed successfully. Please log out and log back in to start using zsh."
    else
        echo -e "\033[31mFailed to change shell. Please run 'chsh -s $ZSH_PATH' manually.\033[0m"
    fi
else
    echo "Default shell is already zsh."
fi

echo "Installing deps..."
if [ -f "$DOTFILES/deps" ]; then
    mapfile -t packages < "$DOTFILES/deps"
    if [ ${#packages[@]} -gt 0 ]; then
        echo "  packages: ${packages[*]}"
        sudo pacman -S --needed --noconfirm "${packages[@]}"
    fi
else
    echo "  no deps file found, skipping."
fi

echo "Done."
