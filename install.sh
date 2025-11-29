#!/usr/bin/env bash

# PyLux Installer
# Symlinks all tools to ~/bin/ (or optionally /usr/local/bin/)

set -e

# ANSI Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BOLD}${CYAN}"
echo "╔═══════════════════════════════════════╗"
echo "║         PyLux Installer v1.0          ║"
echo "║  Python Environment Management Tool   ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Determine installation directory
if [[ -d ~/bin ]]; then
    INSTALL_DIR=~/bin
    echo -e "${GREEN}✓ Found ~/bin/, will install there${NC}"
else
    echo -e "${YELLOW}! ~/bin/ not found${NC}"
    echo -e "${CYAN}Choose installation directory:${NC}"
    echo "  1) Create ~/bin/ (recommended)"
    echo "  2) Install to /usr/local/bin/ (requires sudo)"
    read -p "Choice [1]: " choice
    choice=${choice:-1}
    
    if [[ "$choice" == "1" ]]; then
        mkdir -p ~/bin
        INSTALL_DIR=~/bin
        echo -e "${GREEN}✓ Created ~/bin/${NC}"
        
        # Check if ~/bin is in PATH
        if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
            echo -e "${YELLOW}! ~/bin is not in your PATH${NC}"
            echo -e "${CYAN}Adding to shell RC files...${NC}"
            
            for rc in ~/.bashrc ~/.zshrc; do
                if [[ -f "$rc" ]]; then
                    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$rc"; then
                        echo '' >> "$rc"
                        echo '# Added by PyLux installer' >> "$rc"
                        echo 'export PATH="$HOME/bin:$PATH"' >> "$rc"
                        echo -e "${GREEN}✓ Updated $rc${NC}"
                    fi
                fi
            done
            
            echo -e "${YELLOW}! Please run: source ~/.bashrc (or ~/.zshrc)${NC}"
        fi
    else
        INSTALL_DIR=/usr/local/bin
        echo -e "${YELLOW}! Will install to /usr/local/bin/ (may require sudo)${NC}"
    fi
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create required directories
echo ""
echo -e "${CYAN}Creating directories...${NC}"
mkdir -p /opt/python-lab
mkdir -p ~/venvs
mkdir -p ~/pybase-envs
echo -e "${GREEN}✓ /opt/python-lab/${NC}"
echo -e "${GREEN}✓ ~/venvs/${NC}"
echo -e "${GREEN}✓ ~/pybase-envs/${NC}"

# Install source management tools
echo ""
echo -e "${CYAN}Installing source management tools...${NC}"
for script in "$SCRIPT_DIR"/source-management/*; do
    if [[ -f "$script" ]]; then
        name=$(basename "$script")
        ln -sf "$script" "$INSTALL_DIR/$name"
        chmod +x "$script"
        echo -e "${GREEN}✓ $name${NC}"
    fi
done

# Install venv management tools
echo ""
echo -e "${CYAN}Installing venv management tools...${NC}"
for script in "$SCRIPT_DIR"/venv-management/*; do
    if [[ -f "$script" ]]; then
        name=$(basename "$script")
        ln -sf "$script" "$INSTALL_DIR/$name"
        chmod +x "$script"
        echo -e "${GREEN}✓ $name${NC}"
    fi
done

# Install pybase management tools
echo ""
echo -e "${CYAN}Installing pybase management tools...${NC}"
for script in "$SCRIPT_DIR"/pybase-management/*; do
    if [[ -f "$script" ]]; then
        name=$(basename "$script")
        ln -sf "$script" "$INSTALL_DIR/$name"
        chmod +x "$script"
        echo -e "${GREEN}✓ $name${NC}"
    fi
done

# Check for build dependencies
echo ""
echo -e "${CYAN}Checking build dependencies...${NC}"
MISSING_DEPS=()

for dep in gcc make libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl; do
    if ! dpkg -l | grep -q "^ii  $dep"; then
        MISSING_DEPS+=("$dep")
    fi
done

if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    echo -e "${YELLOW}! Missing dependencies for compiling Python:${NC}"
    for dep in "${MISSING_DEPS[@]}"; do
        echo "  - $dep"
    done
    echo ""
    echo -e "${CYAN}Install with:${NC}"
    echo "  sudo apt-get install ${MISSING_DEPS[*]}"
else
    echo -e "${GREEN}✓ All build dependencies present${NC}"
fi

# Summary
echo ""
echo -e "${BOLD}${GREEN}═══════════════════════════════════════${NC}"
echo -e "${BOLD}${GREEN}Installation Complete!${NC}"
echo -e "${BOLD}${GREEN}═══════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}Quick Start:${NC}"
echo ""
echo -e "${BOLD}1. Install Python:${NC}"
echo "   py-altinstall"
echo ""
echo -e "${BOLD}2. Create base environment:${NC}"
echo "   pybase-create"
echo ""
echo -e "${BOLD}3. Set up shell integration:${NC}"
echo "   pybase-shell-integration"
echo "   source ~/.bashrc  # or ~/.zshrc"
echo ""
echo -e "${BOLD}4. Create project venvs:${NC}"
echo "   venv-create"
echo ""
echo -e "${CYAN}Available Commands:${NC}"
echo "  ${BOLD}py-altinstall${NC}        - Install Python from source"
echo "  ${BOLD}py-list${NC}              - List installed Pythons"
echo "  ${BOLD}venv-create${NC}          - Create new venv"
echo "  ${BOLD}venv-list${NC}            - List all venvs"
echo "  ${BOLD}venv-repair${NC}          - Repair broken venvs"
echo "  ${BOLD}vactivate <name>${NC}     - Quick activate venv"
echo "  ${BOLD}vdel <name>${NC}          - Delete venv"
echo "  ${BOLD}pybase-create${NC}        - Create base environment"
echo "  ${BOLD}pybase-list${NC}          - List base environments"
echo "  ${BOLD}base-switch <name>${NC}   - Switch base environment"
echo ""
echo -e "${BOLD}${MAGENTA}Documentation:${NC} https://github.com/yourusername/PyLux"
echo ""
