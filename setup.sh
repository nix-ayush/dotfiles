#!/usr/bin/env bash

# Function to stow specific config directories
stow_config() {
    app=$1
    echo "Stowing $app..."

    if [ -e "$HOME/.config/$app" ]; then
        rm -rf "$HOME/.config/$app"
    fi

    mkdir -p "$HOME/.config/$app"
    stow -v -R -t "$HOME/.config/$app" "$app"
}

# Apps that go into ~/.config/<app_name>

# x
stow_x() {
    cd x/
    for app in i3 dunst flameshot picom rofi; do
        stow_config "$app"
    done
    cd ..
}

# wayland
stow_wayland() {
    cd wayland/
    for app in sway; do
        stow_config "sway"
    done
    cd ..
}

stow_x
stow_wayland

# ~
stow_config "gallery-dl"
stow_config "kitty"
stow_config "mpv"
stow_config "scripts"
stow_config "yazi"
stow_config "yt-dlp"
stow_config "rmpc"
stow_config "mpd"
mkdir -p ~/.config/mpd/playlists && touch ~/.config/mpd/database
# systemctl restart --user mpd && systemctl status --user mpd

echo "Stowing Emacs..."
mkdir -p ~/.emacs.d/config
stow -t ~/.emacs.d emacs

echo "Stowing Shell..."
stow shell  # Targets ~ by default
