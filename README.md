[![Mastodon: @phranck](https://img.shields.io/badge/Mastodon-@LAYERED-6364ff.svg?style=flat)](https://oldbytes.space/@LAYERED)
![SF Symbols](https://img.shields.io/badge/SF%20Symbols-7007-blue?style=flat&logo=apple&logoColor=white)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# sfe - SF Symbols Extractor

A Python tool to extract individual SVG files from concatenated `svgs.txt` files.

Current version: **[SF Symbols 7.2](https://developer.apple.com/sf-symbols/)**

## Data Source

The data files (`names.txt`, `info.txt`, `svgs.txt`) in this repository are generated directly from [sf-symbols-lib](https://github.com/phranck/sf-symbols-lib).

## Directory Structure

```
sfe/
├── sfe                 # Extractor script
├── names.txt           # Symbol names (one per line)
├── info.txt            # Special Symbol info (one per line)
├── monochrome/         # Monochrome variant
│   └── svgs.txt
└── hierarchical/       # Hierarchical variant
    └── svgs.txt
```

## Symbol Variants

The directories are organized by SF Symbol rendering variants:

**Variants:**
- `monochrome/` - Monochrome
- `hierarchical/` - Hierarchical

## Installation

Install `sfe` globally on your system using Homebrew, pipx, or pip:

### Using Homebrew (Recommended)

```bash
brew install phranck/tap/sfe
```

### Using pipx

```bash
# Install pipx if not already installed
brew install pipx

# Install sfe from source directory
pipx install .

# Or install in editable mode (changes reflect immediately)
pipx install -e .
```

### Using pip with virtual environment

```bash
# Install from source directory
pip install .

# Or install in development mode (changes reflect immediately)
pip install -e .
```

After installation, the `sfe` command is available globally in your terminal.

### Uninstall

```bash
# If installed with Homebrew
brew uninstall sfe

# If installed with pipx
pipx uninstall sfe

# If installed with pip
pip uninstall sfe
```

## Usage

```bash
# Check directory structure
sfe --check

# Update SF Symbols badge in README
sfe --update-badge

# Extract SVGs to custom directory (preserves directory structure)
sfe --output ~/Desktop/SVGs

# Delete all extracted SVGs (current directory)
sfe --clean

# Delete all extracted SVGs (custom directory)
sfe --clean ~/Desktop/SVGs

# Extract all SVGs
sfe
```

The script extracts individual `.svg` files from each `svgs.txt` into their respective directories.

## Note

The extracted `.svg` files are excluded from version control (see `.gitignore`). After cloning the repository, install it with `pip install .` and then run `sfe` to generate the SVG files.

## Contributing

Reports and pull requests are welcome. Please use the GitHub issue tracker for bug reports or feature requests.

## License

This repository has been published under the [MIT](https://opensource.org/licenses/MIT) license.
