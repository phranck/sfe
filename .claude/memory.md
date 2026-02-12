# Project Memory: sfe

## Project Overview

**Name:** sfe (SF Symbols Extractor)  
**Purpose:** Extract individual SVG files with embedded metadata from concatenated SF Symbols svgs.txt files  
**Language:** Python 3  
**Type:** CLI tool  
**Dependencies:** None (Python standard library only)

### Package Structure
```
sfe/
├── sfe                      # Main executable script
├── sfe_main.py             # Pip-installable entry point (identical to sfe)
├── .data/
│   ├── names.txt           # Symbol names (7007 entries)
│   ├── info.txt            # Restricted symbols (574 entries)
│   ├── categories/         # Category mappings (30 files)
│   ├── monochrome/svgs.txt # Monochrome rendering mode
│   └── dualtone/svgs.txt   # Dualtone rendering mode
├── pyproject.toml          # Python package metadata
├── setup.py                # Data files installation
└── homebrew/sfe.rb         # Homebrew formula
```

## Architecture

### Core Components

| Component | File | Purpose |
|-----------|------|---------|
| `get_base_dir()` | sfe, sfe_main.py | Detect data files location (.data/source/brew/pip) |
| `check_structure()` | sfe, sfe_main.py | Validate required files exist |
| `load_categories()` | sfe, sfe_main.py | Load category mappings from .data/categories/*.txt |
| `load_restricted_symbols()` | sfe, sfe_main.py | Load restricted symbols from .data/info.txt |
| `generate_lib_name()` | sfe, sfe_main.py | Generate SF Symbols Lib name (PascalCase + SF prefix) |
| `create_metadata_element()` | sfe, sfe_main.py | Generate SVG `<metadata>` XML element |
| `clean_svgs()` | sfe, sfe_main.py | Delete extracted SVG files |
| `update_readme_badge()` | sfe, sfe_main.py | Update README with SVG count |
| `main()` | sfe, sfe_main.py | CLI entry point and orchestration |

### Data Flow

1. **Initialization:** Detect BASE_DIR based on installation method
2. **Validation:** Check for required files (.data/names.txt, .data/info.txt, .data/*/svgs.txt)
3. **Output Setup:** Determine output directory (default: ./svgs), handle existing files interactively
4. **Load Metadata Sources:** Categories (30 files), restricted symbols (574), names (7007)
5. **Extraction:** Loop through 2 rendering modes, split concatenated SVGs by `<?xml` delimiter
6. **Metadata Injection:** Insert `<metadata>` after opening `<svg>` tag
7. **Output:** Write individual .svg files to rendering mode directories

### Installation Paths

| Method | Script Location | Data Location |
|--------|----------------|---------------|
| Source | `./sfe` | `./.data/` |
| Homebrew | `/opt/homebrew/bin/sfe` | `/opt/homebrew/share/sfe/` |
| pip/pipx | `{prefix}/bin/sfe` | `{prefix}/share/sfe/` |

## Patterns & Conventions

### Adding a New Rendering Mode

1. Add directory with `svgs.txt` to `SVG_BASE_DIRS` list in sfe + sfe_main.py
2. Update `STRUCTURE_DIAGRAM` for help text
3. Update `homebrew/sfe.rb` to install new svgs.txt
4. Update `setup.py` variant list
5. No other code changes needed (loop-based processing)

### Data File Format

- **names.txt:** One symbol name per line (no extension)
- **info.txt:** Restricted symbol names (one per line)
- **categories/*.txt:** Symbol names per category (filename = category name)
- **svgs.txt:** Concatenated SVGs, split by `<?xml version="1.0" encoding="UTF-8"?>`

### SVG Metadata Format

```xml
<metadata>
  <symbol>
    <name type="apple">square.and.arrow.up</name>
    <name type="lib">SFSquareAndArrowUp</name>
    <restricted>false</restricted>
    <renderingMode>monochrome</renderingMode>
    <sfSymbolsVersion>7.3</sfSymbolsVersion>
    <categories>
      <category>Draw</category>
    </categories>
  </symbol>
</metadata>
```

### CLI Arguments

| Flag | Purpose |
|------|---------|
| `-v, --version` | Print version |
| `-c, --check` | Validate directory structure |
| `-u, --update-badge` | Update README badge count |
| `-o, --output PATH` | Custom output directory |
| `--clean [PATH]` | Delete extracted SVGs |

## Current State

**Branch:** main  
**Version:** v1.3.0  
**SF Symbols:** 7.3 (7007 symbols, 30 categories, 574 restricted, 2 rendering modes)

### Recent Changes
- Removed palette/multicolor modes, renamed hierarchical to dualtone (v1.3.0)
- Improved statistics output clarity (v1.2.1)
- Added interactive output directory handling (v1.2.0)

### Known Issues
None

### Package Distribution

| Platform | Method | Command |
|----------|--------|---------|
| macOS | Homebrew | `brew install phranck/tap/sfe` |
| Any | pipx | `pipx install .` |
| Any | pip | `pip install .` |
