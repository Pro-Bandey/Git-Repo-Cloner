#!/bin/bash

# Force terminal to change to the directory where this script is located
cd "$(dirname "$0")"

# Determine which python command is available
if command -v python3 &>/dev/null; then
    PYTHON_CMD="python3"
elif command -v python &>/dev/null; then
    PYTHON_CMD="python"
else
    PYTHON_CMD=""
fi

# Check if Git is installed
if command -v git &>/dev/null; then
    GIT_INSTALLED=1
else
    GIT_INSTALLED=0
fi

install_tools() {
    local install_python=$1
    local install_git=$2

    if command -v brew &>/dev/null; then
        echo "Installing tools via Homebrew..."
        [ "$install_python" = "1" ] && brew install python
        [ "$install_git" = "1" ] && brew install git
    else
        echo "❌ Homebrew is not installed. Please install Homebrew (https://brew.sh) to automatically install dependencies."
        read -p "Press Enter to exit..."
        exit 1
    fi
}

# Run immediately if both are present
if [ -n "$PYTHON_CMD" ] && [ "$GIT_INSTALLED" -eq 1 ]; then
    $PYTHON_CMD GitRepoCloner.py
    exit 0
fi

# CASE 1: Both missing
if [ -z "$PYTHON_CMD" ] && [ "$GIT_INSTALLED" -eq 0 ]; then
    echo "❌ Python and Git are not installed."
    read -p "Would you like to install both? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        install_tools 1 1
        if command -v python3 &>/dev/null; then PYTHON_CMD="python3"; fi
    else
        exit 1
    fi

# CASE 2: Python missing
elif [ -z "$PYTHON_CMD" ]; then
    echo "❌ Python is not installed."
    read -p "Would you like to install Python? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        install_tools 1 0
        if command -v python3 &>/dev/null; then PYTHON_CMD="python3"; fi
    else
        exit 1
    fi

# CASE 3: Git missing
elif [ "$GIT_INSTALLED" -eq 0 ]; then
    echo "❌ Git is not installed."
    read -p "Would you like to install Git? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        install_tools 0 1
    else
        exit 1
    fi
fi

# Execute script
if [ -n "$PYTHON_CMD" ] && command -v git &>/dev/null; then
    $PYTHON_CMD GitRepoCloner.py
else
    echo "Please restart your terminal to apply the changes."
    read -p "Press Enter to exit..."
fi