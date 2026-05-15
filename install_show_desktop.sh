#!/bin/bash

# Exit on error
set -e

echo "--- Starting installation of 'Toggle Desktop' (Pure Bash Version) ---"

# 1. 檢查並安裝 wmctrl
if ! command -v wmctrl &> /dev/null; then
    echo "Installing wmctrl..."
    sudo apt update -qq && sudo apt install -y wmctrl > /dev/null
else
    echo "wmctrl is already installed."
fi

# 2. 定義變數
APP_ID="show-desktop.desktop"
APP_DIR="$HOME/.local/share/applications"
FILE_PATH="$APP_DIR/$APP_ID"

mkdir -p "$APP_DIR"

# 3. 建立具備切換邏輯的啟動器
echo "Generating launcher file..."
TOGGLE_CMD="bash -c 'if wmctrl -m | grep -q \"mode: ON\"; then wmctrl -k off; else wmctrl -k on; fi'"

cat <<EOF > "$FILE_PATH"
[Desktop Entry]
Type=Application
Name=Show Desktop
Icon=desktop
Exec=$TOGGLE_CMD
Terminal=false
Categories=Utility;
Comment=Toggle between show desktop and restore windows
EOF

chmod +x "$FILE_PATH"

# 4. 自動定選到 Dock (使用純 Bash 處理字串)
echo "Pinning to Dock..."

current_favorites=$(gsettings get org.gnome.shell favorite-apps)

# 檢查是否已經在清單內
if [[ $current_favorites != *"$APP_ID"* ]]; then
    if [[ $current_favorites == "[]" || $current_favorites == "@as []" ]]; then
        # 如果清單是空的
        new_favorites="['$APP_ID']"
    else
        # 移除結尾的 ] 並加上新項目
        new_favorites="${current_favorites%]*}, '$APP_ID']"
    fi
    
    gsettings set org.gnome.shell favorite-apps "$new_favorites"
    echo "Successfully pinned to Dock!"
else
    echo "Already pinned to Dock."
fi

echo "--- Done! ---"