# PyLux

**Python environment management without the bloat.**

Born from frustration with Miniconda's takeover and bloat, PyLux is a lightweight, powerful toolkit for managing Python installations and virtual environments. No package manager dependencies, no conda channels, just clean bash scripts and full control.

This is a collection of optimized scripts and functions I made for my own use, which later expanded into something I figured more people would enjoy having.

## Where did the name "PyLux" come from?

**PyLux** = **Py**thon + **Lux**ury (or **Lux** for Linux, depending on the day)

Started as "Python for Linux" since these are bash scripts optimized for Linux distros. But as it grew, it became more about providing a *luxurious* Python workflow - clean, fast, and without the bloat. Pick whichever interpretation makes you happier. 😎

> **Note:** Currently Linux-only. macOS *might* work (uses bash/zsh too; would likely require modifications to save directory paths) but hasn't been tested. Windows users: try WSL2!

## Why PyLux?

**The Problem:**
- Conda is massive and takes over your system
- Single monolithic base environment gets messy
- No easy way to compile Python from source with custom configurations
- Broken venvs are a pain to fix
- Too much typing to activate environments

**The Solution:**
PyLux gives you:
- 🔧 **Source compilation** - Install any Python version (including alphas/betas) from source with optimizations
- 🎯 **Smart venv management** - Create, list, repair, and delete venvs with ease
- ⭐ **Persistent base environment** - Conda-style always-active base env without the bloat
- 🚀 **Quick activation** - Short commands to switch environments instantly
- 🔍 **Diagnostics** - See what's broken and fix it automatically
- 💪 **Full control** - Pure bash, no hidden magic, easy to customize

## Features

### Source Management
- **py-altinstall** - Compile and install Python from source with optimizations (LTO, PGO)
- **py-list** - List all installed Python versions with details
- Supports stable releases AND alpha/beta/RC versions
- Automatic symlink creation (py310, py311, py312, etc.)
- Smart pre-release detection and warnings

### Virtual Environment Management
- **vcreate** - Quick venv creator with Python version picker and package presets
- **vlist** - List all venvs with diagnostics (Python version, packages, broken status)
- **vrepair** - Resurrect broken venvs by extracting packages from site-packages
- **vrepair-local** - Repair in-project venvs
- **vactivate** - Quick activation: `vactivate myproject` instead of `source ~/pylux-venvs/myproject/bin/activate`
- **vdel** - Safe deletion with confirmation and optional backup
- **vclone** - Clone existing venv with all packages to new venv
- **vdiff** - Compare packages between two venvs

### Cache Management (Space Saver!)
- **vcache** - Manage shared package cache to save disk space
- **Python version isolation** - Separate cache per Python version (no ABI conflicts)
- **Safe hardlinks** - Code files hardlinked, metadata stays per-venv
- **vcache status** - See cache size, cached packages organized by Python version
- **vcache clean** - Remove orphaned packages (not used by any venv)
- **vcache rebuild** - Scan all venvs and rebuild registry
- Automatically used by vcreate and vrepair
- **Zero safety compromises** - pip works normally, uninstall safe, upgrades safe

### Base Environment Management (Conda-style)
- **base-create** - Create specialized base environments (dev, data-science, ml, etc.)
- **base-list** - List all base environments
- **base-shell-integration** - Auto-activate base env on shell start
- **base-switch** - Quickly switch between base environments
- `deactivate` returns to base env (not fully off!)
- `deactivate_all` for full deactivation

## Installation

```bash
# Clone the repo
git clone https://github.com/project-elyx/PyLux.git
cd PyLux

# Run the installer
./install.sh

# Reload your shell
source ~/.bashrc  # or ~/.zshrc
```

## Quick Start

### Interactive Launcher (Easiest!)
```bash
pylux
# Opens FZF menu with all PyLux tools
# Color-coded by category, searchable, with previews
# Perfect if you forget command names!
```

### 1. Install a Python version
```bash
py-altinstall
# Follow prompts to install Python 3.13, 3.12, etc.
# Can even install alpha/beta releases!
```

### 2. Create your base environment
```bash
base-create
# Name it 'mybase' (or whatever you want)
# Choose Python version
# Install packages
```

### 3. Set up persistent base env (OPTIONAL!)
```bash
base-shell-integration
# Choose YES to enable conda-style base env
# Choose NO to use PyLux with traditional venv workflow
source ~/.zshrc
# Now you'll always have your base env active (if enabled)
```

**Don't want base env?** Skip this step! Use `vactivate` and `deactivate` normally.

### 4. Create project venvs
```bash
vcreate
# Choose location (~/pylux-venvs/ or current directory)
# Pick Python version
# Install package presets or custom packages
```

### 5. Use the shortcuts
```bash
pylux                   # Interactive menu (if you forget commands!)
vactivate myproject     # Activate ~/pylux-venvs/myproject
deactivate              # Return to base env
base-switch ml-tools    # Switch to ~/pylux-base-envs/ml-tools
vlist                   # See all your venvs
py-list                 # See all installed Pythons
```

**Pro tip:** Can't remember a command? Just type `pylux` and browse the menu!

## Workflow Example

```bash
# Your shell starts with (mybase) base env active
(mybase) $ vactivate web-scraper
(web-scraper) $ # Work on project
(web-scraper) $ deactivate
(mybase) $ # Back to base env

# Got a broken venv from old Python install?
(mybase) $ vrepair
# Select broken venv, it extracts packages and rebuilds!

# Want bleeding edge Python?
(mybase) $ py-altinstall
# Say yes to alpha/beta versions, install Python 3.15.0a2
```

## How It Works

**Source Management:**
- Downloads Python source from python.org
- Compiles with optimizations (--enable-optimizations, --with-lto)
- Installs to `/opt/pylux-sources/X.Y.Z/`
- Creates symlinks like `py313` in `/usr/local/bin/`

**Venv Recovery:**
- When venvs break (Python deleted, conda removed, etc.), packages are still in `lib/pythonX.Y/site-packages/`
- PyLux scans `.dist-info` directories to extract package names
- Rebuilds venv with new Python and reinstalls packages
- Smart version matching for seamless migration

**Shared Package Cache:**
- Packages stored in `~/pylux-cache/` organized by Python version (cp311, cp312, etc.)
- **Python version isolation** - No ABI mismatches, each Python version has its own cache
- **Safe hardlinking** - Package code hardlinked, pip metadata stays per-venv
- **Atomic writes** - Cache updates are atomic to prevent corruption
- Automatic cache usage in vcreate and vrepair
- Example: 5 venvs with torch (Python 3.12) = 1 cached copy + hardlinks!
- **VEX GOLD STANDARD** - Maximum disk savings with zero safety compromises

**Base Environment:**
- Shell integration auto-activates base env on startup
- Overrides `deactivate` to return to base instead of fully deactivating
- Separate `deactivate_all` command for full shutdown
- Feels like conda but with zero bloat

## Requirements

- Linux (tested on Ubuntu/Debian, should work on most distros)
- Bash or Zsh
- Build tools for compiling Python: `gcc`, `make`, `libssl-dev`, `zlib1g-dev`, `libbz2-dev`, etc.
- `curl` or `wget`
- `jq` for cache management (JSON registry parsing)
- **Optional:** `fzf` for the interactive `pylux` launcher (highly recommended!)
  ```bash
  sudo apt install fzf  # Debian/Ubuntu
  ```

**First time? Install all dependencies at once:**
```bash
# Debian/Ubuntu
sudo apt update && sudo apt install -y \
    build-essential gcc make \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libffi-dev liblzma-dev libncurses5-dev libgdbm-dev libnss3-dev \
    curl wget git jq fzf

# Fedora/RHEL
sudo dnf groupinstall "Development Tools" && \
sudo dnf install -y \
    openssl-devel zlib-devel bzip2-devel readline-devel sqlite-devel \
    libffi-devel xz-devel ncurses-devel gdbm-devel nss-devel \
    curl wget git jq fzf

# Arch
sudo pacman -S --needed base-devel openssl zlib bzip2 readline sqlite \
    libffi xz ncurses gdbm nss curl wget git jq fzf
```

## Directory Structure

```
PyLux/
├── pylux                  # 🎯 Interactive launcher (main entry point)
├── source-management/     # Python compilation and installation
│   ├── py-altinstall
│   ├── py-list
│   └── py-del
├── venv-management/       # Virtual environment tools
│   ├── vcreate
│   ├── vlist
│   ├── vrepair
│   ├── vrepair-local
│   ├── vactivate
│   ├── vdel
│   ├── vclone
│   ├── vdiff
│   └── venv-aliases-setup
├── cache-management/      # Shared package cache
│   └── vcache
└── base-management/       # Base environment tools
    ├── base-create
    ├── base-list
    ├── base-switch
    ├── base-delete
    └── base-shell-integration
```

**Tip:** Run `pylux` to see all available tools in an interactive menu!

## Philosophy

**Keep It Simple:**
- Pure bash scripts, no complex dependencies
- Each tool does one thing well
- Easy to read, easy to modify

**Full Control:**
- You decide what gets installed and where
- No hidden configuration files
- No package manager lock-in

**Recover from Anything (except mutilation):**
- Migrated from conda? Repair broken venvs
- Deleted Python? Rebuild seamlessly
- Packages still exist? We'll find them

## FAQ

**Q: Why not just use conda?**
A: Conda is great but it's heavy, takes over your system, and the base environment becomes a dumping ground. PyLux gives you the workflow without the bloat.

**Q: Why not pyenv?**
A: Pyenv is excellent but PyLux adds venv management, base environments, and recovery tools in one cohesive system.

**Q: Can I use this alongside conda/pyenv?**
A: Yes! PyLux installs to `/opt/pylux-sources/` and uses its own paths. Just don't let conda's auto-activation conflict with PyLux's base env.

**Q: Do I have to use the base environment feature?**
A: Nope! The base env is totally optional. You can use PyLux just for source compilation and venv management without any shell integration. Just skip the `base-shell-integration` command and use `vactivate`/`deactivate` normally. Best of both worlds!

**Q: Is this production-ready?**
A: Aside from the cache (as of today, Nov.29/25) it's stable and tested on personal systems. Use at your own discretion. Always backup important environments.

**Q: Can I install alpha/beta Python versions?**
A: YES! Try Python alphas before anyone else (I definitely didn't test this trying to install 3.15.0a2).

**Q: Can I customize where PyLux stores files?**
A: Yes! Edit the path variables at the top of each script:
- **py-altinstall/py-list/py-del**: Change `PYLUX_SOURCES="/opt/pylux-sources"` 
- **venv scripts**: Change `VENV_DIR="$HOME/pylux-venvs"`
- **base scripts**: Change `PYBASE_DIR="$HOME/pylux-base-envs"`
- **cache scripts**: Change `CACHE_DIR="$HOME/pylux-cache"`

All paths are simple bash variables - no hidden config files!

**Q: How much space does the cache save?**
A: MASSIVE savings- especially for solo devs! If you have 5 venvs with torch (800MB each), that's 4GB normally but only ~900MB with hardlinks (800MB cached + small metadata per venv). Python version isolation means each Python gets its own cache - so torch for Python 3.12 is separate from Python 3.11.

**Q: What are hardlinks and why are they safe?**
A: Same file, multiple locations, same inode = only stored once on disk. PyLux uses **Python version isolation** (separate cache per cp311, cp312, etc.) and only hardlinks package code files, NOT pip metadata. This means:
- Each venv has its own `.dist-info` (pip sees it as properly installed)
- Package code is hardlinked from cache (massive disk savings)
- `pip uninstall` works normally (removes hardlinks, cache stays)
- No ABI mismatches (Python 3.11 never shares with 3.12)
- **GOLD STANDARD** implementation - zero compromises

## Contributing

Built in an ADHD-fueled 2 AM coding session. Contributions welcome!

## License

MIT - Do whatever you want with it

## Credits

Created by someone who got tired of conda's shit and decided to build something better.

---

**PyLux** - Light up your Python workflow -- without lighhting up your hard drive (and your file management) ✨
