#!/bin/bash

# =================================================================
# Description: Setup _diff function with clipboard support for Ubuntu
# Target OS: Ubuntu 22.04 (Jammy Jellyfish)
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
    read -p " Do you want to overwrite the existing configuration? (y/N): " confirm
    if [[ $confirm != [yY] ]]; then
        echo " [x] Operation canceled."
        exit 0
    fi
    
    echo " [*] Removing old configuration safely..."
    # 安全移除舊版的所有可能形式
    sed -i '/# === GIT DIFF CLIPBOARD FUNCTION ===/,/# === END GIT DIFF CLIPBOARD FUNCTION ===/d' "$BASHRC"
    sed -i '/alias _diff=/d' "$BASHRC"
    sed -i '/_diff()/d' "$BASHRC"
    sed -i '/xclip -selection clipboard/d' "$BASHRC"
fi

# 5. Write and apply changes using Here-Doc (Prevents escape character corruption)
echo " [*] Writing configuration to $BASHRC..."

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

echo " [✔] Success! Command '$ALIAS_NAME' has been added to $BASHRC."
echo " [i] Please run: [ source ~/.bashrc ] to apply changes immediately."