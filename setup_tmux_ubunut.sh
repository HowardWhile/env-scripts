#!/bin/bash

echo "Starting automatic tmux environment setup (Ubuntu specific)..."

# 1. Update package repositories and install tmux and xclip
echo "Updating system package repositories and installing packages..."
sudo apt-get update
sudo apt-get install -y tmux xclip

# 2. Download the specified Gist content via wget and overwrite to ~/.tmux.conf
echo "Downloading .tmux.conf configuration file..."
GIST_RAW_URL="https://gist.githubusercontent.com/HowardWhile/cc11453ef2e7f5e5461973557f434874/raw/"

if wget -qO ~/.tmux.conf "$GIST_RAW_URL"; then
    echo ".tmux.conf downloaded and configured successfully!"
else
    echo "Download failed, please check network connection."
    exit 1
fi

# 3. If tmux is already running, automatically reload the configuration
if pgrep -x "tmux" > /dev/null; then
    tmux source-file ~/.tmux.conf
    echo "Configuration reloaded for running tmux."
fi

echo "tmux and xclip installation and configuration completed successfully!"
