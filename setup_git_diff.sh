#!/bin/bash

# =================================================================
# Description: Setup _diff function with clipboard support for Ubuntu
# Target OS: Ubuntu 22.04 and later (should be compatible with older versions too)
# =================================================================

# 1. Environment Check (Ubuntu 22.04 friendly notice)
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        echo " [!] Warning: Non-Ubuntu system detected. The script may require minor adjustments."
    fi
fi

# 2. Install required tools (xclip)
if ! command -v xclip > /dev/null; then
    echo " [*] xclip not detected, proceeding with installation..."
    sudo apt-get update && sudo apt-get install -y xclip
fi

# 3. Define basic variables
BASHRC="$HOME/.bashrc"
ALIAS_NAME="_diff"

# 4. Check for existing configuration and handle overwrite logic
if grep -q "GIT DIFF CLIPBOARD FUNCTION" "$BASHRC" || grep -q "alias _diff=" "$BASHRC" || grep -q "_diff()" "$BASHRC"; then
    echo " [?] '$ALIAS_NAME' configuration already exists in $BASHRC."
    
    # 關鍵修正：加上 < /dev/tty 確保在 wget | bash 模式下仍能接收輸入
    read -p " Do you want to overwrite the existing configuration? (y/N): " confirm < /dev/tty
    
    if [[ $confirm != [yY] ]]; then
        echo " [x] Operation canceled."
        exit 0
    fi
    
    echo " [*] Removing old configuration safely..."
    # Safe removal of any previous versions
    sed -i '/# === GIT DIFF CLIPBOARD FUNCTION ===/,/# === END GIT DIFF CLIPBOARD FUNCTION ===/d' "$BASHRC"
    sed -i '/alias _diff=/d' "$BASHRC"
    sed -i '/_diff()/d' "$BASHRC"
    sed -i '/xclip -selection clipboard/d' "$BASHRC"
fi

# 5. Write and apply changes (Safely handle newlines)
echo " [*] Writing configuration to $BASHRC..."

# 先移除檔案末尾所有的空白行（避免重複執行導致空白行堆疊）
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$BASHRC"

# 直接寫入，不額外使用 echo ""
cat << 'EOF' >> "$BASHRC"
# === GIT DIFF CLIPBOARD FUNCTION ===
_diff() {
    # 1. Intent-to-add: includes untracked files in the diff
    git add -N .
    
    # 2. Show colorful diff on the terminal screen
    git --no-pager diff --color HEAD >&2
    
    # 3. Copy clean plain-text diff (without ANSI color codes) to clipboard
    git --no-pager diff HEAD | xclip -selection clipboard
}
# === END GIT DIFF CLIPBOARD FUNCTION ===
EOF

# Success and Usage Instructions
echo -e "\n\033[0;32m [✔] Success! Command '$ALIAS_NAME' has been added to $BASHRC.\033[0m"
echo -e " [i] Please run: \033[0;33msource ~/.bashrc\033[0m to apply changes immediately.\n"

echo "========================================================"
echo "                   USAGE GUIDE                          "
echo "========================================================"
echo " Simply type the shortcut in your repository:"
echo -e "   \033[1;36m_diff\033[0m"
echo ""
echo " Features:"
echo "   1. Auto-Tracks: Runs 'git add -N .' first, so newly created"
echo "      (untracked) files will also show up in the diff."
echo "   2. Split-Output: Your terminal will display the standard"
echo "      colorful diff (red/green) for easy review."
echo "   3. Auto-Copy: The clean, plain-text version (without messy"
echo "      ANSI color codes) is automatically copied to your clipboard."
echo "   4. Ready to Paste: You can directly Ctrl+V / Cmd+V into"
echo "      Slack, Discord, or GitHub issues without garbage text."
echo "========================================================"