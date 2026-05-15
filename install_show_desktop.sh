#!/bin/bash

# Exit on error
set -e

echo "--- Starting installation of 'Show Desktop' icon ---"

# 1. Install required package wmctrl
if ! command -v wmctrl &> /dev/null; then
    echo "Installing wmctrl..."
    sudo apt update -qq && sudo apt install -y wmctrl > /dev/null
else
    echo "wmctrl is already installed, skipping this step."
fi

# 2. Define paths and filenames
APP_DIR="$HOME/.local/share/applications"
FILE_PATH="$APP_DIR/show-desktop.desktop"

# Ensure directory exists
mkdir -p "$APP_DIR"

# 3. Create .desktop file content
echo "Generating launcher file..."
cat <<EOF > "$FILE_PATH"
[Desktop Entry]
Type=Application
Name=Show Desktop
Icon=desktop
Exec=wmctrl -k on
Terminal=false
Categories=Utility;
Comment=Minimize all windows and show the desktop
EOF

# 4. Grant execute permission
chmod +x "$FILE_PATH"

echo "--- Installation completed! ---"
echo "Now press the 'Super key' (Windows key) to search for 'Show Desktop',"
echo "and right-click it to 'Add to Dock' to pin it to the Dock."