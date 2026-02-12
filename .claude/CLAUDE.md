# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**sfe** (SF Symbols Extractor) is a minimal-dependencies Python CLI tool that extracts individual SVG files from Apple's SF Symbols library, enriching each with embedded metadata (apple name, library name, restricted status, rendering mode, version, categories). Version 1.3.0, supports SF Symbols 7.3 (14,014 SVGs across monochrome and dualtone modes).

- **Language:** Python 3.7+
- **Dependencies:** None (stdlib only)
- **License:** MIT
- **Distribution:** Homebrew, pipx, pip

## Development Setup

### Installation & Running

```bash
# Homebrew (macOS)
brew install phranck/tap/sfe
sfe --help

# pipx (recommended for development)
pipx install -e .
sfe --help

# pip (with virtualenv)
python -m venv venv
source venv/bin/activate
pip install -e .
sfe --help

# Local development (no install needed)
python sfe_main.py --help
./sfe --help
```

### Directory Structure

```
sfe/
├── sfe_main.py          # Main CLI script (507 lines, 13 functions)
├── sfe                  # Shell wrapper (executes sfe_main.py)
├── setup.py             # Installation metadata
├── pyproject.toml       # Package config (version, metadata)
├── .data/               # Data files (ignored by git after extraction)
│   ├── names.txt        # 7,007 SF Symbol names (one per line)
│   ├── info.txt         # 574 restricted symbols
│   ├── categories/      # 30 category mapping files
│   ├── monochrome/
│   │   └── svgs.txt     # Concatenated monochrome SVGs (~14 MB)
│   └── dualtone/
│       └── svgs.txt     # Concatenated dualtone SVGs (~14 MB)
├── .github/
│   └── workflows/
│       └── update-badge.yml  # Auto-updates README symbol count on names.txt changes
└── homebrew/
    └── sfe.rb           # Homebrew formula
```

## CLI Commands

```bash
# Extract SVGs (default: ./svgs/)
sfe

# Extract to custom directory
sfe --output ~/Desktop/SVGs

# Validate data structure without extracting
sfe --check

# Update symbol count badge in README
sfe --update-badge

# Delete extracted SVGs
sfe --clean                    # Deletes ./svgs
sfe --clean ~/Desktop/SVGs     # Deletes custom directory

# Show version
sfe --version
```

When output directory already contains SVGs, tool prompts for: delete & fresh, merge (overwrite), or cancel.

## Architecture: High-Level Data Flow

```
Input (from .data/):
  ├── names.txt → 7,007 symbol names
  ├── info.txt → 574 restricted symbols
  ├── categories/*.txt → Symbol → [Categories] mapping
  └── {monochrome,dualtone}/svgs.txt → Concatenated SVGs (split by <?xml> delimiter)

Processing:
  1. Load names, categories, restricted symbols into memory
  2. Parse svgs.txt: split by <?xml> delimiter
  3. For each SVG:
     a. Convert apple_name to library_name (PascalCase + SF prefix)
     b. Look up categories
     c. Check restricted status
     d. Generate <metadata> XML element
     e. Inject metadata after <svg> tag
     f. Write individual .svg file with all metadata embedded

Output:
  svgs/
  ├── monochrome/
  │   ├── square.and.arrow.up.svg (with embedded metadata)
  │   └── ... (7,007 files)
  └── dualtone/
      ├── square.and.arrow.up.svg
      └── ... (7,007 files)

Total: 14,014 self-describing SVG files
```

### Embedded SVG Metadata Format

Each extracted SVG contains a `<metadata>` block after the `<svg>` tag:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.1" ...>
  <metadata>
    <symbol>
      <name type="apple">square.and.arrow.up</name>
      <name type="lib">SFSquareAndArrowUp</name>
      <restricted>false</restricted>
      <renderingMode>monochrome</renderingMode>
      <sfSymbolsVersion>7.3</sfSymbolsVersion>
      <categories>
        <category>Draw</category>
        <category>Navigation</category>
      </categories>
    </symbol>
  </metadata>
  <!-- SVG content -->
</svg>
```

This makes each SVG completely self-describing (no external lookups needed).

### Key Architecture Patterns

**Installation-Aware Configuration**: `get_base_dir()` detects installation method (source, Homebrew, pip/pipx) and returns correct data path. Enables deployment flexibility.

**Functional Data Transformation**: No classes or OOP. Pure functions with single responsibility. Data flows linearly through pipeline.

**Self-Describing Output**: Metadata embedded in SVGs → no external file dependencies.

**DRY Principle**: Categories in separate files (30 files), restricted symbols centralized (info.txt), names centralized (names.txt).

**User Choice Principle**: When conflicts arise (output dir already contains SVGs), tool prompts user instead of silently overwriting.

### Core Functions in sfe_main.py

| Function | Purpose |
|----------|---------|
| `get_base_dir()` | Detect installation method, return data dir path |
| `check_structure()` | Validate required files exist |
| `load_categories()` | Load 30 category mappings from .data/categories/*.txt |
| `load_restricted_symbols()` | Load 574 restricted symbols from info.txt |
| `generate_lib_name()` | Convert apple_name to library_name (e.g., square.and.arrow.up -> SFSquareAndArrowUp) |
| `create_metadata_element()` | Generate `<metadata>` XML with symbol info |
| `clean_svgs()` | Delete all extracted SVGs from output directory |
| `update_readme_badge()` | Update symbol count badge in README |
| `print_progress()` | Display progress bar during extraction |
| `main()` | CLI orchestration |

## Code Conventions

**From Copilot Instructions** (applies to this project):

- **Descriptive names**: Use `symbol_name`, not `s`. Names reveal intent without comments.
- **Comments**: Explain non-trivial logic in English. All functions have docstrings.
- **DRY**: Never duplicate data, types, or constants. Centralize in data files or module-level constants.
- **No changes without explicit request**: Always ask before modifying code.

## Git Standards

### Commit Prefix Format

| Prefix | Use |
|--------|-----|
| `Feat:` | New feature |
| `Fix:` | Bug fix |
| `Chore:` | Maintenance, version bumps, Homebrew updates |
| `Docs:` | Documentation, README |
| `Refactor:` | Code restructure, no behavior change |

**Examples:**
```
Feat: Add category support to metadata
Chore: Update Homebrew formula to v1.3.0
Docs: Update project tracking for v1.2.1
Fix: Handle edge case in metadata injection
```

### Branch Workflow

- Feature branches for substantial changes
- Always ask before PR or push
- Never push autonomously
- If on `main` with changes, ask to switch to feature branch first

## Advanced Development Tasks

### Adding a New Rendering Mode

Example: Adding a new "custom" rendering mode alongside monochrome and dualtone.

1. **Get new SVGs from Apple**: Obtain concatenated custom/svgs.txt (~14 MB)
2. **Update .data/ structure**:
   ```bash
   mkdir -p .data/custom
   cp <svgs from apple> .data/custom/svgs.txt
   ```
3. **Update sfe_main.py**: Modify `main()` to iterate over rendering modes:
   ```python
   rendering_modes = ["monochrome", "dualtone", "custom"]  # Add "custom"
   ```
4. **Test**: `python sfe_main.py --check` then `python sfe_main.py`
5. **Verify**: Check that .svg files have correct metadata with renderingMode="custom"
6. **Commit**: `Feat: Add custom rendering mode`

### Updating to SF Symbols 7.4+

When Apple releases new SF Symbols version:

1. **Update .data/names.txt**: Replace with new symbol list
2. **Update .data/info.txt**: Update restricted symbols list
3. **Update .data/categories/**: Update all category mappings
4. **Replace .data/monochrome/svgs.txt and .data/dualtone/svgs.txt**: From Apple's new release
5. **Update version in pyproject.toml**:
   ```
   version = "1.4.0"  # Or next appropriate version
   ```
6. **Update version in sfe_main.py** (search for "SF Symbols 7.3" constant)
7. **Update Homebrew formula** (homebrew/sfe.rb): Bump version, update SHA256
8. **Run validation**: `python sfe_main.py --check`
9. **Test extraction**: `python sfe_main.py --output /tmp/test_svgs`
10. **Update README badge**: `python sfe_main.py --update-badge`
11. **Commit**: `Chore: Update to SF Symbols 7.4`
12. **Create release tag**: `git tag -a v1.4.0 -m "SF Symbols 7.4 support"`

### Releasing a New Version

1. **Update version** in `pyproject.toml` and search codebase for old version strings
2. **Update Homebrew formula** (homebrew/sfe.rb):
   - Bump `version` field
   - Calculate new SHA256: `sha256 "$(shasum -a 256 <dist-file>)"`
   - Update URL if distribution changed
3. **Run tests**: `python sfe_main.py --check`
4. **Update README** if needed: `python sfe_main.py --update-badge`
5. **Commit changes**: `Chore: Bump version to X.Y.Z`
6. **Create tag**: `git tag -a vX.Y.Z -m "Release vX.Y.Z"`
7. **Build distribution**: `python -m build` (if set up)
8. **Publish to Homebrew**: PR to phranck/homebrew-tap with formula update

### Changing Data Format or Metadata Structure

If you need to add new metadata fields to SVGs:

1. **Update create_metadata_element()** in sfe_main.py to include new fields
2. **Update SVG metadata documentation** in this file
3. **Ensure backward compatibility**: New fields should be optional or have defaults
4. **Test**: Extract SVGs and validate metadata with XML parser
5. **Update README** if changes are user-facing
6. **Commit**: `Feat: Add [field] to SVG metadata`

### Debugging

**Check data structure integrity**:
```bash
python sfe_main.py --check
```

**Extract with verbose output**: Add print statements in sfe_main.py, then:
```bash
python sfe_main.py --output /tmp/debug_svgs 2>&1 | head -50
```

**Verify metadata in extracted SVG**:
```bash
grep -A 10 "<metadata>" svgs/monochrome/square.and.arrow.up.svg
```

**Check symbol count mismatch**:
```bash
wc -l .data/names.txt                        # Should be 7007
ls svgs/monochrome/ | wc -l                  # Should be 7007
ls svgs/dualtone/ | wc -l                    # Should be 7007
```

## Testing

No formal test suite exists. Validation happens through:

1. **Structure check**: `python sfe_main.py --check` verifies all required files
2. **Integration testing**: Extraction produces 14,014 SVGs (7,007 x 2 modes)
3. **Mismatch detection**: Warnings if SVG count != name count
4. **GitHub Action**: Auto-runs `python sfe_main.py --update-badge` on names.txt changes

For manual testing, extract to temp directory and spot-check:
```bash
python sfe_main.py --output /tmp/test_svgs
# Check a few SVGs for correct metadata:
python -c "from xml.etree import ElementTree as ET; tree = ET.parse('/tmp/test_svgs/monochrome/square.and.arrow.up.svg'); print(ET.tostring(tree.find('.//metadata'), encoding='unicode'))"
```

## Notes

- **No external dependencies**: sfe uses only Python stdlib. Makes it lightweight and portable.
- **Large data files**: .data/ directory (~28 MB for SVGs) is git-ignored. Data must be present locally or via Homebrew installation.
- **Performance**: Extracts ~14K SVGs in ~2-3 seconds on modern hardware.
- **Symbol naming**: Apple names (e.g., `square.and.arrow.up`) are converted to library names (e.g., `SFSquareAndArrowUp`) for easier API usage.
