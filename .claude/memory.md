# Project Memory: sfe

## Project Overview

**Name:** sfe (SF Symbols Extractor)  
**Purpose:** Extract individual SVG files with embedded metadata from concatenated SF Symbols svgs.txt files  
**Language:** Python 3  
**Type:** CLI tool

### Package Structure
```
sfe/
├── sfe                      # Main executable script
├── sfe_main.py             # Pip-installable entry point (same as sfe)
├── .data/
│   ├── names.txt           # Symbol names (7007 entries)
│   ├── info.txt            # Restricted symbols (574 entries)
│   ├── categories/         # Category mappings (30 files)
│   ├── hierarchical/svgs.txt
│   └── monochrome/svgs.txt
├── pyproject.toml          # Python package metadata
├── setup.py                # Data files installation
└── homebrew/sfe.rb         # Homebrew formula
```

### Key Dependencies
None (Python standard library only)

## Architecture

### Core Components

| Component | File | Purpose |
|-----------|------|---------|
| `get_base_dir()` | sfe, sfe_main.py | Detect data files location (.data/source/brew/pip) |
| `check_structure()` | sfe, sfe_main.py | Validate required files exist |
| `load_categories()` | sfe, sfe_main.py | Load category mappings from .data/categories/*.txt |
| `load_restricted_symbols()` | sfe, sfe_main.py | Load restricted symbols from .data/info.txt |
| `generate_lib_name()` | sfe, sfe_main.py | Generate SF Symbols Lib name (PascalCase + SF prefix) |
| `create_metadata_element()` | sfe, sfe_main.py | Generate SVG <metadata> XML element |
| `clean_svgs()` | sfe, sfe_main.py | Delete extracted SVG files |
| `update_readme_badge()` | sfe, sfe_main.py | Update README with SVG count |
| `main()` | sfe, sfe_main.py | CLI entry point and orchestration |

### Data Flow

1. **Initialization:** Detect BASE_DIR based on installation method
2. **Validation:** Check for required files (.data/names.txt, .data/info.txt, .data/*/svgs.txt)
3. **Load Metadata Sources:** Categories (30 files), restricted symbols (574), names (7007)
4. **Extraction:** Split concatenated SVGs by `<?xml` delimiter
5. **Metadata Generation:** Create <metadata> element with Apple name, Lib name, restricted flag, categories
6. **Metadata Injection:** Insert <metadata> after opening <svg> tag
7. **Output:** Write individual .svg files with embedded metadata to variant directories

### Installation Paths

| Method | Script Location | Data Location |
|--------|----------------|---------------|
| Source | `./sfe` | `./.data/` |
| Homebrew | `/opt/homebrew/bin/sfe` | `/opt/homebrew/share/sfe/` |
| pip/pipx | `{prefix}/bin/sfe` | `{prefix}/share/sfe/` |

## Key Functions Reference

| Function | Purpose | Key Logic |
|----------|---------|-----------|
| `get_base_dir()` | Find data files | Checks: .data/ → source dir → brew share → pip share |
| `load_categories()` | Load category mappings | Reads .data/categories/*.txt, returns {symbol: [categories]} |
| `load_restricted_symbols()` | Load restricted symbols | Reads .data/info.txt, returns set of symbol names |
| `generate_lib_name()` | Generate Lib name | Split by `.`, capitalize words, join, add `SF` prefix |
| `create_metadata_element()` | Create SVG metadata | Generates <metadata><symbol>...</symbol></metadata> XML |
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
- **info.txt:** Restricted symbol names (one per line)
- **categories/*.txt:** Symbol names per category (filename = category name)
- **svgs.txt:** Concatenated SVGs, split by `<?xml version="1.0" encoding="UTF-8"?>`

### SVG Metadata Format

Each exported SVG contains:
```xml
<metadata>
  <symbol>
    <name type="apple">square.and.arrow.up</name>
    <name type="lib">SFSquareAndArrowUp</name>
    <restricted>false</restricted>
    <sfSymbolsVersion>7.3</sfSymbolsVersion>
    <categories>
      <category>Draw</category>
    </categories>
  </symbol>
</metadata>
```

- Metadata inserted after opening `<svg>` tag
- SF Symbols version included (7.3)
- Categories alphabetically sorted, optional
- Lib name: PascalCase conversion of Apple name with `SF` prefix

### CLI Argument Pattern

```python
parser.add_argument("-v", "--version", action="version", version=f"sfe {VERSION}")
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
**Version:** v1.1.0  
**SF Symbols:** 7.3 (7007 symbols, 30 categories, 574 restricted)

### Recent Changes
- Released v1.1.0 with embedded metadata feature
- Added --version/-v flag (displays "sfe 1.1.0")
- Removed info.txt export (data now in SVG metadata)
- Embedded comprehensive metadata in exported SVGs (Apple name, Lib name, restricted flag, categories)
- Reorganized data files into .data/ directory structure

### Known Issues
None

### Automation
- GitHub Action updates README badge when names.txt changes
- `./sfe --update-badge` works without extracting SVGs first

### Package Distribution

| Platform | Method | Command |
|----------|--------|---------|
| macOS | Homebrew | `brew install phranck/tap/sfe` |
| Any | pipx | `pipx install .` |
| Any | pip | `pip install .` |
