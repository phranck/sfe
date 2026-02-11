# Project Memory: sfe

## Project Overview

**Name:** sfe (SF Symbols Extractor)  
**Purpose:** Extract individual SVG files from concatenated SF Symbols svgs.txt files  
**Language:** Python 3  
**Type:** CLI tool

### Package Structure
```
sfe/
├── sfe                    # Main executable script
├── sfe_main.py           # Pip-installable entry point (same as sfe)
├── names.txt             # Symbol names (6984 entries)
├── info.txt              # Special symbol metadata
├── hierarchical/svgs.txt # Hierarchical variant (concatenated)
├── monochrome/svgs.txt   # Monochrome variant (concatenated)
├── pyproject.toml        # Python package metadata
├── setup.py              # Data files installation
└── homebrew/sfe.rb       # Homebrew formula
```

### Key Dependencies
None (Python standard library only)

## Architecture

### Core Components

| Component | File | Purpose |
|-----------|------|---------|
| `get_base_dir()` | sfe, sfe_main.py | Detect data files location (source/brew/pip) |
| `check_structure()` | sfe, sfe_main.py | Validate required files exist |
| `clean_svgs()` | sfe, sfe_main.py | Delete extracted SVG files |
| `update_readme_badge()` | sfe, sfe_main.py | Update README with SVG count |
| `main()` | sfe, sfe_main.py | CLI entry point and orchestration |

### Data Flow

1. **Initialization:** Detect BASE_DIR based on installation method
2. **Validation:** Check for required files (names.txt, info.txt, */svgs.txt)
3. **Extraction:** Split concatenated SVGs by `<?xml` delimiter
4. **Naming:** Match SVGs to names from names.txt (1:1 mapping)
5. **Output:** Write individual .svg files to variant directories

### Installation Paths

| Method | Script Location | Data Location |
|--------|----------------|---------------|
| Source | `./sfe` | `./*` (same dir) |
| Homebrew | `/opt/homebrew/bin/sfe` | `/opt/homebrew/share/sfe/` |
| pip/pipx | `{prefix}/bin/sfe` | `{prefix}/share/sfe/` |

## Key Functions Reference

| Function | Purpose | Key Logic |
|----------|---------|-----------|
| `get_base_dir()` | Find data files | Checks: source dir → brew share → pip share |
| `check_structure()` | Validate setup | Returns missing files list |
| `print_progress()` | Progress bar | Updates in-place with `\r` |
| `format_duration()` | Human-readable time | ms/s/m format |
| `count_extracted_svgs()` | Count existing SVGs | Checks one variant directory |
| `clean_svgs()` | Delete SVGs | Removes .svg from all variant dirs |
| `update_readme_badge()` | Update badge | Regex replace in README.md |

## Patterns & Conventions

### Adding a New Variant

1. Add directory with `svgs.txt` to `SVG_BASE_DIRS` list
2. Update `STRUCTURE_DIAGRAM` for help text
3. No code changes needed (loop-based processing)

### Data File Format

- **names.txt:** One symbol name per line (no extension)
- **info.txt:** Special symbol metadata (one per line)
- **svgs.txt:** Concatenated SVGs, split by `<?xml version="1.0" encoding="UTF-8"?>`

### CLI Argument Pattern

```python
parser.add_argument("-c", "--check", action="store_true")
parser.add_argument("-o", "--output", metavar="PATH")
parser.add_argument("--clean", nargs="?", const=BASE_DIR)
```

### Color Output

Uses ANSI codes via `Colors` class:
- `GREEN` for success
- `YELLOW` for warnings
- `RED` for errors
- `CYAN` for info
- `BOLD`/`DIM` for emphasis

## Current State

**Branch:** main  
**Version:** v1.0.1  
**SF Symbols:** 7.2 (6984 symbols)

### Recent Changes
- Added Homebrew installation without Python dependency
- Implemented smart BASE_DIR detection for all install methods
- Removed virtualenv from Homebrew formula (uses system Python)
- Data files now install to share/sfe/ directory
- Changed license to MIT

### Known Issues
None

### Package Distribution

| Platform | Method | Command |
|----------|--------|---------|
| macOS | Homebrew | `brew install phranck/tap/sfe` |
| Any | pipx | `pipx install .` |
| Any | pip | `pip install .` |
