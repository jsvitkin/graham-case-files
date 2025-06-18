#!/usr/bin/env bash
set -e

# Find the project root by looking for package.json
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

if [ -z "$PROJECT_ROOT" ] || [ ! -f "$PROJECT_ROOT/package.json" ]; then
    echo "Error: Could not find project root (package.json missing)."
    exit 1
fi

ENV_FILE="$PROJECT_ROOT/.vaultenv"

# Try to load env file
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
    echo "--> Loaded .vaultenv"
fi

# Prompt if missing or empty
if [ -z "$SOURCE_PATH" ]; then
    read -rp "Please enter full path to the Obsidian Vault: " SOURCE_PATH

    if [ ! -d "$SOURCE_PATH" ]; then
        echo "Error: Source path '$SOURCE_PATH' does not exist."
        exit 1
    fi

    echo "SOURCE_PATH=$SOURCE_PATH" > "$ENV_FILE"
    echo "--> Saved source path to .vaultenv"
fi

DESTINATION="$PROJECT_ROOT/content"
echo "==> Starting sync from '$SOURCE_PATH' to '$DESTINATION'"

if [ -d "$DESTINATION" ]; then
    echo "--> Removing existing content folder..."
    rm -rf "$DESTINATION"
fi

mkdir -p "$DESTINATION"
echo "--> Copying files..."
cp -R "$SOURCE_PATH"/* "$DESTINATION"

echo "==> Sync complete!"