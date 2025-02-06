#!/bin/bash

SCRIPT_URL="https://raw.githubusercontent.com/yourusername/yourrepo/main/git-cleanbranches"  # Replace with actual URL
INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="git-cleanbranches"

# Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root: sudo bash install.sh"
   exit 1
fi

echo "Downloading script..."
curl -o "$INSTALL_DIR/$SCRIPT_NAME" "$SCRIPT_URL"

if [[ $? -ne 0 ]]; then
    echo "Download failed. Please check the URL."
    exit 1
fi

chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
echo "Installation complete! Run the command with: git cleanbranches"
