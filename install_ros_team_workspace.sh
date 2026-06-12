#!/bin/bash

# =================================================================
# Description: Install RosTeamWorkspace (RTW) into ~/workspaces
# Target OS: Ubuntu 24.04 and later (best effort on older Ubuntu)
# =================================================================

set -e

REPO_URL="https://github.com/b-robotized/ros_team_workspace.git"
INSTALL_PARENT="$HOME/workspaces"
INSTALL_DIR="$INSTALL_PARENT/ros_team_workspace"
BASHRC="$HOME/.bashrc"
RTW_RC="$HOME/.ros_team_ws_rc"
RTW_MARKER_START="# === ROS TEAM WORKSPACE AUTO SOURCE ==="
RTW_MARKER_END="# === END ROS TEAM WORKSPACE AUTO SOURCE ==="

echo "========================================================"
echo "        RosTeamWorkspace (RTW) one-click setup          "
echo "========================================================"
echo "Install path: $INSTALL_DIR"
echo ""

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" != "ubuntu" ]]; then
        echo " [!] Warning: Non-Ubuntu system detected. This script is designed for Ubuntu."
    fi
fi

install_apt_packages() {
    local missing_packages=()

    command -v git > /dev/null || missing_packages+=("git")
    command -v pip3 > /dev/null || missing_packages+=("python3-pip")

    if [ ${#missing_packages[@]} -eq 0 ]; then
        echo " [*] Required apt packages are already installed."
        return
    fi

    echo " [*] Installing required apt packages: ${missing_packages[*]}"
    sudo apt-get update
    sudo apt-get install -y "${missing_packages[@]}"
}

clone_or_update_rtw() {
    mkdir -p "$INSTALL_PARENT"

    if [ -d "$INSTALL_DIR/.git" ]; then
        echo " [*] RTW repository already exists. Updating with git pull --ff-only..."
        git -C "$INSTALL_DIR" pull --ff-only
        return
    fi

    if [ -e "$INSTALL_DIR" ]; then
        echo " [x] $INSTALL_DIR already exists but is not a Git repository."
        echo "     Please move or remove it before running this script again."
        exit 1
    fi

    echo " [*] Cloning RTW repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
}

install_rtw_cli() {
    echo " [*] Installing RTW CLI Python packages..."

    local pip_args=("--user" "-r" "requirements.txt")

    if pip3 install --help 2>/dev/null | grep -q -- "--break-system-packages"; then
        pip_args+=("--break-system-packages")
    fi

    (
        cd "$INSTALL_DIR/rtwcli"
        pip3 install "${pip_args[@]}"
    )
}

source_rtw_setup() {
    echo " [*] Sourcing RTW setup.bash for this installation run..."

    # Official step:
    #   source ros_team_workspace/setup.bash
    source "$INSTALL_DIR/setup.bash"
}

configure_rtw_rc() {
    echo " [*] Configuring $RTW_RC..."

    if [ ! -f "$RTW_RC" ]; then
        cp "$INSTALL_DIR/templates/.ros_team_ws_rc" "$RTW_RC"
    else
        local backup_file
        backup_file="$RTW_RC.bak.$(date +%Y%m%d%H%M%S)"
        cp "$RTW_RC" "$backup_file"
        echo " [*] Existing $RTW_RC backed up to $backup_file"
    fi

    sed -i "s|source <PATH TO ros_team_workspace>/setup.bash|source $INSTALL_DIR/setup.bash|g" "$RTW_RC"
    sed -i "s|source .*/ros_team_workspace/setup.bash|source $INSTALL_DIR/setup.bash|g" "$RTW_RC"
    sed -i "s|source <Path to ros_team_workspace>/scripts/configuration/terminal_coloring.bash|source $INSTALL_DIR/scripts/configuration/terminal_coloring.bash|g" "$RTW_RC"
    sed -i "s|source .*/ros_team_workspace/scripts/configuration/terminal_coloring.bash|source $INSTALL_DIR/scripts/configuration/terminal_coloring.bash|g" "$RTW_RC"
    sed -i "s|source .*/ros_team_workspace/scripts/environment/setup.bash|source $INSTALL_DIR/scripts/environment/setup.bash|g" "$RTW_RC"

    if ! grep -q "source $INSTALL_DIR/setup.bash" "$RTW_RC"; then
        {
            echo ""
            echo "# RosTeamWorkspace framework"
            echo "source $INSTALL_DIR/setup.bash"
        } >> "$RTW_RC"
    fi
}

configure_bashrc() {
    echo " [*] Configuring auto-sourcing (non-interactive setup-auto-sourcing equivalent)..."

    # Official step:
    #   setup-auto-sourcing
    #
    # The upstream command is interactive. For one-click installation, this
    # script performs the same permanent setup directly:
    #   1. ~/.ros_team_ws_rc sources $INSTALL_DIR/setup.bash
    #   2. ~/.bashrc sources ~/.ros_team_ws_rc in every new terminal

    touch "$BASHRC"
    sed -i "/$RTW_MARKER_START/,/$RTW_MARKER_END/d" "$BASHRC"

    cat << EOF >> "$BASHRC"

$RTW_MARKER_START
export PATH="\$HOME/.local/bin:\$PATH"
if [ -f "\$HOME/.ros_team_ws_rc" ]; then
    . "\$HOME/.ros_team_ws_rc"
fi
$RTW_MARKER_END
EOF
}

install_apt_packages
clone_or_update_rtw
install_rtw_cli
source_rtw_setup
configure_rtw_rc
configure_bashrc

echo ""
echo -e "\033[0;32m [✔] RTW installation completed.\033[0m"
echo ""
echo "Important:"
echo "  Keep this folder: $INSTALL_DIR"
echo "  RTW CLI was installed in editable mode and your shell setup sources files from that folder."
echo ""
echo "Next steps:"
echo "  1. Run: source ~/.bashrc"
echo "  2. Check: rtw --help"
echo "========================================================"
