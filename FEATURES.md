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
- Python installations: `/opt/pylux-sources/X.Y.Z/`
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
# Creates symlink: py313 -> /opt/pylux-sources/3.13.9/bin/python3.13
```

---

### py-list

**List all installed Python versions**

```bash
py-list
```

**Features:**
- Auto-detects Python binaries in `/opt/pylux-sources/`
- Shows full version output
- Displays associated symlinks
- Color-coded output
- Handles non-standard naming (python3.15 vs python3.15.0a2)

**Example Output:**
```
📦 Installed Python Versions
══════════════════════════════════════════════════════════════

Python 3.13.9 (main, Jan 15 2025, 01:23:45)
  Location: /opt/pylux-sources/3.13.9/bin/python3.13
  Symlinks: py313

Python 3.15.0a2 (main, Jan 15 2025, 01:45:12)
  Location: /opt/pylux-sources/3.15.0a2/bin/python3.15
  Symlinks: py315
```

---

## Virtual Environment Management

### vcreate

**Quick venv creator with Python picker and presets**

```bash
vcreate
```

**Features:**
- Lists all available Python versions
- Choose location: `~/pylux-venvs/` or current directory
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
$ vcreate
# Select py313
# Name: web-scraper
# Location: ~/pylux-venvs/
# Preset: Web
# Installs: requests, beautifulsoup4, lxml, aiohttp
```

---

### vlist

**List and diagnose all virtual environments**

```bash
vlist
```

**Features:**
- Scans `~/pylux-venvs/` directory
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
🐍 Virtual Environments in ~/pylux-venvs/
══════════════════════════════════════════════════════════════

✓ web-scraper
  Python: 3.13.9
  Pip: 24.3.1
  Packages: 47

✗ old-project (BROKEN - missing bin/python)
  Reason: Python binary not found
```

---

### vrepair

**Resurrect broken venvs by extracting packages**

```bash
vrepair
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
1. Lists all venvs in `~/pylux-venvs/`
2. Shows broken venvs
3. Prompts for selection
4. Extracts package list
5. Detects Python version
6. Offers version choices
7. Creates new venv
8. Reinstalls packages

**Example:**
```bash
$ vrepair
# Select: old-project (broken)
# Found packages: numpy, pandas, requests, etc.
# Old Python: 3.11.5
# Options: 1) Same (py311), 2) Upgrade (py313)
# Rebuilds venv and reinstalls packages
```

---

### vrepair-local

**Repair in-project virtual environments**

```bash
vrepair-local
```

Same features as `vrepair` but:
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
- Sources `~/pylux-venvs/<name>/bin/activate`
- Lists available venvs if no name provided
- Shorter than `source ~/pylux-venvs/myproject/bin/activate`
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
✓ Backed up to ~/pylux-venvs/old-project.bak
✓ Deleted ~/pylux-venvs/old-project
To restore: mv ~/pylux-venvs/old-project.bak ~/pylux-venvs/old-project
```

---

### vclone

**Clone existing venv with all packages**

```bash
vclone
```

**Features:**
- Interactive source venv selection
- Automatic Python version detection
- Extracts full package list with `pip freeze`
- Creates new venv with same Python version
- Reinstalls all packages with versions
- Perfect for duplicating working environments

**Example:**
```bash
$ vclone
# Select source: web-scraper
# Name new venv: web-scraper-v2
# Detects Python 3.13.9
# Copies all 47 packages with exact versions
```

---

### vdiff

**Compare packages between two venvs**

```bash
vdiff
```

**Features:**
- Interactive dual venv selection
- Side-by-side package comparison
- Shows version differences
- Shows packages unique to each venv
- Color-coded output (different = yellow, same = green)
- Summary statistics

**Example Output:**
```
📦 Comparing: web-scraper vs web-scraper-v2
══════════════════════════════════════════════════════════════

Package Differences:
  requests: 2.31.0 vs 2.32.0 ⚠
  numpy: 1.24.3 vs 1.25.0 ⚠

Only in web-scraper:
  beautifulsoup4 (4.12.2)

Only in web-scraper-v2:
  lxml (5.1.0)

Summary:
  Same: 45 packages
  Different versions: 2 packages
  Unique to web-scraper: 1 package
  Unique to web-scraper-v2: 1 package
```

---

## Cache Management

### vcache

**Manage shared package cache to save disk space**

```bash
vcache status   # View cache statistics
vcache clean    # Remove orphaned packages
vcache rebuild  # Rebuild cache registry from venvs
```

**Features:**
- **Shared storage** - Packages installed once in `~/pylux-cache/packages/`
- **Hardlinks** - Same file, multiple locations, stored once on disk
- **Automatic usage** - vcreate and vrepair use cache automatically
- **Registry tracking** - JSON file tracks which venvs use which packages
- **Orphan cleanup** - Remove packages not used by any venv
- **Space savings** - 5 venvs with numpy = 1 copy on disk!

**Cache Structure:**
```
~/pylux-cache/
├── packages/
│   ├── numpy/
│   │   ├── 1.24.3/    # Stored once
│   │   └── 1.25.0/    # Different version
│   ├── requests/
│   │   └── 2.31.0/
│   └── pandas/
│       └── 2.1.0/
└── registry.json       # Tracks venv usage
```

**vcache status output:**
```bash
$ vcache status

📦 PyLux Package Cache Status
══════════════════════════════════════════════════════════════

Cache Directory: /home/user/pylux-cache
Total Size: 1.2G

Cached Packages: 47
Tracked VEnvs: 5

Top 10 Largest Packages:
  torch (1.13.1)      - 524M
  numpy (1.24.3)      - 98M
  pandas (2.1.0)      - 76M
  scipy (1.11.4)      - 54M
  matplotlib (3.8.2)  - 42M
  ...

Space Savings: ~4.8G (estimated if packages were duplicated)
```

**How It Works:**
1. When `vcreate` or `vrepair` installs a package:
   - Package installed normally with pip
   - Package files copied to `~/pylux-cache/packages/{name}/{version}/`
   - Original files deleted
   - Hardlinked back from cache to venv
   - Registry updated to track usage

2. When you delete a venv:
   - Hardlinks removed from venv
   - Package files remain in cache (other venvs may use them)
   - Run `vcache clean` to remove unused packages

3. Multiple venvs sharing packages:
   - All point to same files via hardlinks
   - Same inode = only one copy on disk
   - Delete one venv, others unaffected

**vcache clean:**
```bash
$ vcache clean

Scanning venvs for package usage...
Found 3 orphaned packages:
  - old-package (1.0.0) - not used by any venv
  - deprecated-lib (0.5.0) - not used by any venv

Remove orphaned packages? (yes/no): yes
✓ Removed 2 packages
✓ Freed 145M of disk space
```

**vcache rebuild:**
```bash
$ vcache rebuild

Rebuilding cache registry...
Scanning: ~/pylux-venvs/
Found 5 venvs
Extracting packages...
  web-scraper: 47 packages
  data-analysis: 82 packages
  ml-project: 134 packages
  api-server: 35 packages
  scraper-v2: 51 packages

✓ Registry rebuilt
✓ Total tracked packages: 349 (with duplicates across venvs)
✓ Unique packages in cache: 67
```

**Benefits:**
- Save gigabytes of disk space
- Faster venv creation (if package cached)
- Automatic - no manual intervention
- Safe - uses filesystem hardlinks
- Transparent - venvs work normally

**Example Space Savings:**
```
Without cache:
  5 venvs × 200MB numpy = 1GB storage

With cache:
  5 venvs → 1 numpy copy = 200MB storage
  Savings: 800MB (80%)
```

---

## Base Environment Management

### base-create

**Create specialized base environments**

```bash
base-create
```

**Features:**
- Enhanced package presets:
  - **Essential CLI** - ipython, rich, click, requests
  - **Dev** - pytest, black, ruff, mypy, pre-commit
  - **Data Science** - numpy, pandas, matplotlib, jupyter, seaborn
  - **Web** - flask, fastapi, requests, httpx, jinja2
  - **ML/AI** - numpy, pandas, scikit-learn, torch (warning about size)
- Special handling for "default" base env
- Installs to `~/pylux-base-envs/`
- Full control over Python version

**Example:**
```bash
$ base-create
# Name: mybase
# Python: py313
# Preset: Dev
# Creates ~/pylux-base-envs/mybase/ with pytest, black, ruff, mypy
```

---

### base-list

**List all base environments**

```bash
base-list
```

**Features:**
- Shows Python version
- Shows pip version
- Package count
- Currently active indicator (⭐)

**Example Output:**
```
⭐ Base Environments in ~/pylux-base-envs/
══════════════════════════════════════════════════════════════

⭐ mybase (ACTIVE)
  Python: 3.13.9
  Pip: 24.3.1
  Packages: 52

  ml-tools
  Python: 3.12.7
  Pip: 24.2.0
  Packages: 134
```

---

### base-shell-integration

**Auto-activate base env on shell start**

```bash
base-shell-integration
```

**Features:**
- Prompts for base env name (suggests "default")
- Modifies `.bashrc` and `.zshrc`
- Auto-activates on shell start
- Overrides `deactivate` to return to base
- Adds `deactivate_all` command for full deactivation
- Conda-style persistent activation

**Integration Code Added:**
```bash
# PyLux Base Environment Auto-Activation
if [[ -z "$VIRTUAL_ENV" && -f ~/pylux-base-envs/mybase/bin/activate ]]; then
    source ~/pylux-base-envs/mybase/bin/activate
fi

# Override deactivate to return to base
function deactivate() {
    if [[ "$VIRTUAL_ENV" == *"/pybase-envs/"* ]]; then
        command deactivate
    else
        command deactivate
        if [[ -f ~/pylux-base-envs/mybase/bin/activate ]]; then
            source ~/pylux-base-envs/mybase/bin/activate
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
(mybase) $ base-switch ml-tools
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
base-create  # Name: mybase, Python: py313, Preset: Dev

# Set up shell integration
base-shell-integration

# Reload shell
source ~/.bashrc

# Now (mybase) is always active!
```

---

### Pattern 2: Project Development
```bash
# Create project venv
(mybase) $ cd ~/projects/myproject
(mybase) $ vcreate  # Name: myproject, Preset: Web

# Activate for work
(mybase) $ vactivate myproject
(myproject) $ # Work on project

# Return to base
(myproject) $ deactivate
(mybase) $
```

---

### Pattern 3: Recovering from Disaster
```bash
# Migrated from conda? Broken venvs?
(mybase) $ vlist
# Shows broken venvs

(mybase) $ vrepair
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
vcreate  # Name: py315-test, Python: py315

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
vcreate
```

**Batch venv creation:**
```bash
for proj in project1 project2 project3; do
    echo "Creating $proj..."
    # Use vcreate interactively or script it
done
```

**Check before repairing:**
```bash
vlist  # See what's broken
py-list    # See available Pythons
vrepair  # Fix broken venvs
```

**Multiple base envs for different workflows:**
```bash
base-create  # Name: dev, Preset: Dev
base-create  # Name: data, Preset: Data Science
base-create  # Name: ml, Preset: ML/AI

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

**Problem: vcreate fails with ensurepip error**
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
  base-shell-integration
  source ~/.zshrc
  ```

**Problem: Can't delete broken venv**
- Solution: Use `rm -rf` directly
  ```bash
  rm -rf ~/pylux-venvs/broken-venv
  ```

---

## Advanced Usage

### Custom Python Compile Options

Edit `py-altinstall` configure flags:
```bash
./configure --prefix=/opt/pylux-sources/$VERSION \
    --enable-optimizations \
    --with-lto \
    --enable-shared \
    --enable-loadable-sqlite-extensions  # Add this
```

### Shared Libraries Across Venvs

Base envs in `~/pylux-base-envs/` can be used as system-wide package repos:
```bash
# Install in base
(mybase) $ pip install numpy

# Use in venv via --system-site-packages
vcreate  # Add flag in script
```

### Automated Venv Creation

Script venv creation with heredocs:
```bash
cat << EOF | vcreate
myproject
~/pylux-venvs/
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
/opt/pylux-sources/          # Compiled Python installations
  ├── 3.13.9/
  ├── 3.12.7/
  └── 3.15.0a2/

~/pylux-venvs/                  # Project virtual environments
  ├── myproject/
  ├── web-scraper/
  └── data-analysis/

~/pylux-base-envs/            # Base environments
  ├── mybase/
  ├── dev/
  └── ml-tools/

~/pylux-cache/                # Shared package cache
  ├── packages/
  │   ├── numpy/
  │   │   └── 1.24.3/
  │   └── requests/
  │       └── 2.31.0/
  └── registry.json           # Usage tracking

/usr/local/bin/           # Symlinks
  ├── py313 -> /opt/pylux-sources/3.13.9/bin/python3.13
  ├── py312 -> /opt/pylux-sources/3.12.7/bin/python3.12
  └── py315 -> /opt/pylux-sources/3.15.0a2/bin/python3.15

~/bin/                    # PyLux scripts (after install)
  ├── py-altinstall
  ├── vcreate
  ├── vcache
  ├── vclone
  ├── vdiff
  ├── base-create
  └── ...
```

---

**More questions?** Check the [README](README.md) or open an issue!
