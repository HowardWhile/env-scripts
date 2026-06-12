#!/bin/bash

# =================================================================
# Description: Temporarily uninstall RosTeamWorkspace (RTW) setup
# =================================================================

set -e

INSTALL_DIR="$HOME/workspaces/ros_team_workspace"
BASHRC="$HOME/.bashrc"
RTW_RC="$HOME/.ros_team_ws_rc"
RTW_CONFIG_DIR="$HOME/.ros_team_workspace"
RTW_MARKER_START="# === ROS TEAM WORKSPACE AUTO SOURCE ==="
RTW_MARKER_END="# === END ROS TEAM WORKSPACE AUTO SOURCE ==="
ASSUME_YES="false"

if [[ "${1:-}" == "-y" || "${1:-}" == "--yes" ]]; then
    ASSUME_YES="true"
fi

confirm() {
    local message="$1"

    if [[ "$ASSUME_YES" == "true" ]]; then
        return 0
    fi

    read -p "$message (y/N): " answer < /dev/tty || answer="n"
    [[ "$answer" == [yY] ]]
}

backup_file() {
    local file_path="$1"

    if [ -f "$file_path" ]; then
        local backup_path
        backup_path="$file_path.bak.$(date +%Y%m%d%H%M%S)"
        cp "$file_path" "$backup_path"
        echo " [*] Backed up $file_path to $backup_path"
    fi
}

remove_bashrc_block() {
    if [ ! -f "$BASHRC" ]; then
        echo " [*] $BASHRC does not exist. Skipping."
        return
    fi

    echo " [*] Removing RTW auto-source block from $BASHRC..."
    backup_file "$BASHRC"
    sed -i "/$RTW_MARKER_START/,/$RTW_MARKER_END/d" "$BASHRC"
}

remove_rtw_rc() {
    if [ ! -f "$RTW_RC" ]; then
        echo " [*] $RTW_RC does not exist. Skipping."
        return
    fi

    if confirm "Remove $RTW_RC? This also removes RTW workspace aliases stored there"; then
        backup_file "$RTW_RC"
        rm -f "$RTW_RC"
        echo " [*] Removed $RTW_RC"
    else
        echo " [*] Kept $RTW_RC"
    fi
}

uninstall_python_packages() {
    if ! command -v pip3 > /dev/null; then
        echo " [*] pip3 not found. Skipping Python package uninstall."
        return
    fi

    if confirm "Uninstall RTW Python packages installed by pip3"; then
        pip3 uninstall -y rtwcli rtw-cmds rtw-rocker-extensions off-your-rocker || true
    else
        echo " [*] Kept RTW Python packages."
    fi
}

remove_rtw_clone() {
    if [ ! -e "$INSTALL_DIR" ]; then
        echo " [*] $INSTALL_DIR does not exist. Skipping."
        return
    fi

    if confirm "Remove RTW clone at $INSTALL_DIR"; then
        rm -rf "$INSTALL_DIR"
        echo " [*] Removed $INSTALL_DIR"
    else
        echo " [*] Kept $INSTALL_DIR"
    fi
}

remove_rtw_cli_config() {
    if [ ! -e "$RTW_CONFIG_DIR" ]; then
        echo " [*] $RTW_CONFIG_DIR does not exist. Skipping."
        return
    fi

    if confirm "Remove RTW CLI config directory $RTW_CONFIG_DIR"; then
        rm -rf "$RTW_CONFIG_DIR"
        echo " [*] Removed $RTW_CONFIG_DIR"
    else
        echo " [*] Kept $RTW_CONFIG_DIR"
    fi
}

echo "========================================================"
echo "       RosTeamWorkspace (RTW) temporary uninstall       "
echo "========================================================"
echo "This script removes the RTW framework setup."
echo "It does not remove ROS workspaces you created elsewhere."
echo ""

remove_bashrc_block
remove_rtw_rc
uninstall_python_packages
remove_rtw_clone
remove_rtw_cli_config

echo ""
echo -e "\033[0;32m [✔] RTW uninstall steps completed.\033[0m"
echo ""
echo "Next step:"
echo "  Open a new terminal, or run: source ~/.bashrc"
echo "========================================================"
