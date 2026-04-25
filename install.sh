#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.local/bin"

echo "Installing Minions to $INSTALL_DIR..."

mkdir -p "$INSTALL_DIR"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$REPO_DIR/minions"

chmod +x "$SCRIPT_PATH"

ln -sf "$SCRIPT_PATH" "$INSTALL_DIR/minions"

echo "✅ Successfully installed!"
echo "You can now use 'minions' from anywhere."
echo ""
echo "Note: Make sure $INSTALL_DIR is in your PATH."
