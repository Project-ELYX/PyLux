# PyLux Features

Detailed documentation for all PyLux tools.

---

## Source Management

### py-altinstall

**Install Python from source with custom optimizations**

```bash
py-altinstall
```

**Features:**
- Fetches latest available versions from python.org
- Supports stable releases (3.13.9, 3.12.7, etc.)
- Supports pre-releases (3.15.0a2, 3.14.0b1, etc.)
- Compiles with optimizations:
  - `--enable-optimizations` (Profile-Guided Optimization)
  - `--with-lto` (Link-Time Optimization)
  - `--enable-shared` (Shared library support)
- Creates dynamic symlinks: `py310`, `py311`, `py312`, etc.
- Warns about pre-release stability
- Handles binary naming edge cases for alphas/betas

**Installation Location:**
- Python installations: `/opt/python-lab/X.Y.Z/`
- Symlinks: `/usr/local/bin/pyXYZ`
- Shared libraries: Registered with `ldconfig`

**Interactive Workflow:**
1. Lists available Python versions
2. Prompts for version selection
3. Shows compile options
4. Downloads tarball
5. Extracts and compiles
6. Installs and creates symlinks
7. Verifies installation

**Example:**
```bash
$ py-altinstall
# Select Python 3.13.9
# Compiles with optimizations
# Creates symlink: py313 -> /opt/python-lab/3.13.9/bin/python3.13
```

---

### py-list

**List all installed Python versions**

```bash
py-list
```

**Features:**
- Auto-detects Python binaries in `/opt/python-lab/`
- Shows full version output
- Displays associated symlinks
- Color-coded output
- Handles non-standard naming (python3.15 vs python3.15.0a2)

**Example Output:**
```
📦 Installed Python Versions
══════════════════════════════════════════════════════════════

Python 3.13.9 (main, Jan 15 2025, 01:23:45)
  Location: /opt/python-lab/3.13.9/bin/python3.13
  Symlinks: py313

Python 3.15.0a2 (main, Jan 15 2025, 01:45:12)
  Location: /opt/python-lab/3.15.0a2/bin/python3.15
  Symlinks: py315
```

---

## Virtual Environment Management

### venv-create

**Quick venv creator with Python picker and presets**

```bash
venv-create
```

**Features:**
- Lists all available Python versions
- Choose location: `~/venvs/` or current directory
- Package presets:
  - **Basic** - Just pip, setuptools, wheel
  - **Dev** - pytest, black, flake8, mypy, ipython
  - **Web** - requests, beautifulsoup4, lxml, aiohttp
  - **Data Science** - numpy, pandas, matplotlib, jupyter
- Custom package installation
- Fallback to `get-pip.py` if ensurepip fails
- Full diagnostics on completion

**Example:**
```bash
$ venv-create
# Select py313
# Name: web-scraper
# Location: ~/venvs/
# Preset: Web
# Installs: requests, beautifulsoup4, lxml, aiohttp
```

---

### venv-list

**List and diagnose all virtual environments**

```bash
venv-list
```

**Features:**
- Scans `~/venvs/` directory
- Shows Python version
- Shows pip version
- Package count
- Broken venv detection:
  - Missing `pyvenv.cfg`
  - Missing `bin/python`
  - Missing `bin/activate`
- Color-coded status (✓ working, ✗ broken)

**Example Output:**
```
🐍 Virtual Environments in ~/venvs/
══════════════════════════════════════════════════════════════

✓ web-scraper
  Python: 3.13.9
  Pip: 24.3.1
  Packages: 47

✗ old-project (BROKEN - missing bin/python)
  Reason: Python binary not found
```

---

### venv-repair

**Resurrect broken venvs by extracting packages**

```bash
venv-repair
```

**Features:**
- Two-stage package extraction:
  1. Try `pip freeze` if pip works
  2. Scan `lib/pythonX.Y/site-packages/*.dist-info/` directories
- Detects original Python version
- Offers version options:
  - Same version (if available)
  - Upgrade to different version
- Smart version matching
- Shows old vs new Python versions
- Creates backup before deletion
- Reinstalls all packages

**Workflow:**
1. Lists all venvs in `~/venvs/`
2. Shows broken venvs
3. Prompts for selection
4. Extracts package list
5. Detects Python version
6. Offers version choices
7. Creates new venv
8. Reinstalls packages

**Example:**
```bash
$ venv-repair
# Select: old-project (broken)
# Found packages: numpy, pandas, requests, etc.
# Old Python: 3.11.5
# Options: 1) Same (py311), 2) Upgrade (py313)
# Rebuilds venv and reinstalls packages
```

---

### venv-repair-local

**Repair in-project virtual environments**

```bash
venv-repair-local
```

Same features as `venv-repair` but:
- Scans current directory for venv folders
- Detects: `venv/`, `.venv/`, `env/`, `.env/`
- Repairs in-place

---

### vactivate

**Quick venv activation shortcut**

```bash
vactivate <name>
```

**Features:**
- Sources `~/venvs/<name>/bin/activate`
- Lists available venvs if no name provided
- Shorter than `source ~/venvs/myproject/bin/activate`
- Must be sourced (use alias: `alias vactivate='source vactivate'`)

**Setup:**
```bash
venv-aliases-setup  # Creates aliases in .bashrc/.zshrc
source ~/.bashrc
```

**Example:**
```bash
$ vactivate web-scraper
(web-scraper) $
```

---

### vdel

**Safe venv deletion with confirmation**

```bash
vdel <name>
```

**Features:**
- Optional backup creation
- Double confirmation (type exact name)
- Shows size and package count
- Warns if currently active
- Shows restore command if backed up

**Example:**
```bash
$ vdel old-project
Create backup? [y/N]: y
Type name to confirm: old-project
✓ Backed up to ~/venvs/old-project.bak
✓ Deleted ~/venvs/old-project
To restore: mv ~/venvs/old-project.bak ~/venvs/old-project
```

---

## Base Environment Management

### pybase-create

**Create specialized base environments**

```bash
pybase-create
```

**Features:**
- Enhanced package presets:
  - **Essential CLI** - ipython, rich, click, requests
  - **Dev** - pytest, black, ruff, mypy, pre-commit
  - **Data Science** - numpy, pandas, matplotlib, jupyter, seaborn
  - **Web** - flask, fastapi, requests, httpx, jinja2
  - **ML/AI** - numpy, pandas, scikit-learn, torch (warning about size)
- Special handling for "elyx" base env
- Installs to `~/pybase-envs/`
- Full control over Python version

**Example:**
```bash
$ pybase-create
# Name: elyx
# Python: py313
# Preset: Dev
# Creates ~/pybase-envs/elyx/ with pytest, black, ruff, mypy
```

---

### pybase-list

**List all base environments**

```bash
pybase-list
```

**Features:**
- Shows Python version
- Shows pip version
- Package count
- Currently active indicator (⭐)

**Example Output:**
```
⭐ Base Environments in ~/pybase-envs/
══════════════════════════════════════════════════════════════

⭐ elyx (ACTIVE)
  Python: 3.13.9
  Pip: 24.3.1
  Packages: 52

  ml-tools
  Python: 3.12.7
  Pip: 24.2.0
  Packages: 134
```

---

### pybase-shell-integration

**Auto-activate base env on shell start**

```bash
pybase-shell-integration
```

**Features:**
- Prompts for base env name (suggests "elyx")
- Modifies `.bashrc` and `.zshrc`
- Auto-activates on shell start
- Overrides `deactivate` to return to base
- Adds `deactivate_all` command for full deactivation
- Conda-style persistent activation

**Integration Code Added:**
```bash
# PyLux Base Environment Auto-Activation
if [[ -z "$VIRTUAL_ENV" && -f ~/pybase-envs/elyx/bin/activate ]]; then
    source ~/pybase-envs/elyx/bin/activate
fi

# Override deactivate to return to base
function deactivate() {
    if [[ "$VIRTUAL_ENV" == *"/pybase-envs/"* ]]; then
        command deactivate
    else
        command deactivate
        if [[ -f ~/pybase-envs/elyx/bin/activate ]]; then
            source ~/pybase-envs/elyx/bin/activate
        fi
    fi
}

# Add deactivate_all for full deactivation
function deactivate_all() {
    command deactivate
}
```

---

### base-switch

**Quick base environment switching**

```bash
base-switch <name>
```

**Features:**
- Deactivates current env
- Activates new base env
- Lists available base envs if no name provided
- Must be sourced (alias created by `venv-aliases-setup`)

**Example:**
```bash
(elyx) $ base-switch ml-tools
(ml-tools) $
```

---

## Utility Scripts

### exec-all

**Make all shebanged scripts executable**

```bash
exec-all [directory]
```

**Features:**
- Scans directory for files with shebangs (`#!/...`)
- Runs `chmod +x` on matching files
- Shows before/after permissions
- Defaults to current directory

---

## Workflow Patterns

### Pattern 1: Fresh Python Setup
```bash
# Install Python
py-altinstall  # Select 3.13.9

# Create base env
pybase-create  # Name: elyx, Python: py313, Preset: Dev

# Set up shell integration
pybase-shell-integration

# Reload shell
source ~/.bashrc

# Now (elyx) is always active!
```

---

### Pattern 2: Project Development
```bash
# Create project venv
(elyx) $ cd ~/projects/myproject
(elyx) $ venv-create  # Name: myproject, Preset: Web

# Activate for work
(elyx) $ vactivate myproject
(myproject) $ # Work on project

# Return to base
(myproject) $ deactivate
(elyx) $
```

---

### Pattern 3: Recovering from Disaster
```bash
# Migrated from conda? Broken venvs?
(elyx) $ venv-list
# Shows broken venvs

(elyx) $ venv-repair
# Select broken venv
# Extracts packages from site-packages
# Rebuilds with new Python
# All packages restored!
```

---

### Pattern 4: Bleeding Edge Python
```bash
# Install alpha Python
py-altinstall  # Select 3.15.0a2

# Verify
py-list  # Shows py315

# Create test venv
venv-create  # Name: py315-test, Python: py315

# Experiment!
vactivate py315-test
(py315-test) $ python --version
Python 3.15.0a2
```

---

## Tips & Tricks

**Faster venv creation:**
```bash
# Skip prompts by setting PYTHON_VERSION
export PYTHON_VERSION=py313
venv-create
```

**Batch venv creation:**
```bash
for proj in project1 project2 project3; do
    echo "Creating $proj..."
    # Use venv-create interactively or script it
done
```

**Check before repairing:**
```bash
venv-list  # See what's broken
py-list    # See available Pythons
venv-repair  # Fix broken venvs
```

**Multiple base envs for different workflows:**
```bash
pybase-create  # Name: dev, Preset: Dev
pybase-create  # Name: data, Preset: Data Science
pybase-create  # Name: ml, Preset: ML/AI

# Switch as needed
base-switch dev   # For coding
base-switch data  # For analysis
base-switch ml    # For training models
```

---

## Troubleshooting

**Problem: py-altinstall fails to compile**
- Solution: Install build dependencies
  ```bash
  sudo apt-get install gcc make libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev libffi-dev liblzma-dev
  ```

**Problem: venv-create fails with ensurepip error**
- Solution: Script auto-falls back to get-pip.py
- Manual: `py313 -m pip install --upgrade pip`

**Problem: vactivate command not found**
- Solution: Run `venv-aliases-setup` and reload shell
  ```bash
  venv-aliases-setup
  source ~/.bashrc
  ```

**Problem: Base env doesn't auto-activate**
- Solution: Re-run shell integration
  ```bash
  pybase-shell-integration
  source ~/.zshrc
  ```

**Problem: Can't delete broken venv**
- Solution: Use `rm -rf` directly
  ```bash
  rm -rf ~/venvs/broken-venv
  ```

---

## Advanced Usage

### Custom Python Compile Options

Edit `py-altinstall` configure flags:
```bash
./configure --prefix=/opt/python-lab/$VERSION \
    --enable-optimizations \
    --with-lto \
    --enable-shared \
    --enable-loadable-sqlite-extensions  # Add this
```

### Shared Libraries Across Venvs

Base envs in `~/pybase-envs/` can be used as system-wide package repos:
```bash
# Install in base
(elyx) $ pip install numpy

# Use in venv via --system-site-packages
venv-create  # Add flag in script
```

### Automated Venv Creation

Script venv creation with heredocs:
```bash
cat << EOF | venv-create
myproject
~/venvs/
py313
3
requests beautifulsoup4
EOF
```

---

## Performance Notes

**Compile Times:**
- Python 3.13 with optimizations: ~10-15 minutes
- PGO adds significant time but improves runtime speed
- Skip LTO for faster compiles (edit py-altinstall)

**Venv Repair:**
- Large venvs (100+ packages): 2-5 minutes
- Network speed dependent (pip downloads)
- Consider using `--no-cache-dir` for clean installs

---

## File Locations Reference

```
/opt/python-lab/          # Compiled Python installations
  ├── 3.13.9/
  ├── 3.12.7/
  └── 3.15.0a2/

~/venvs/                  # Project virtual environments
  ├── myproject/
  ├── web-scraper/
  └── data-analysis/

~/pybase-envs/            # Base environments
  ├── elyx/
  ├── dev/
  └── ml-tools/

/usr/local/bin/           # Symlinks
  ├── py313 -> /opt/python-lab/3.13.9/bin/python3.13
  ├── py312 -> /opt/python-lab/3.12.7/bin/python3.12
  └── py315 -> /opt/python-lab/3.15.0a2/bin/python3.15

~/bin/                    # PyLux scripts (after install)
  ├── py-altinstall
  ├── venv-create
  ├── pybase-create
  └── ...
```

---

**More questions?** Check the [README](README.md) or open an issue!
