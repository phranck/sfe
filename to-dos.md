# To-Dos

## In Progress
None

## Open
None

## Completed

### 2026-02-11
- Added pip/pipx installation support with pyproject.toml and setup.py
- Changed license from CC-BY-NC-SA to MIT
- Added Homebrew installation support without Python dependencies
- Released v1.0.0 and v1.0.1
- Fixed symbol count badge auto-update to read from names.txt (7007 symbols)
- Added GitHub Action for automatic badge updates on names.txt changes
- Added project tracking files (whats-next.md, to-dos.md, memory.md)
- Documented sf-symbols-lib usage relationship
- Embedded comprehensive metadata in exported SVGs (Apple name, Lib name, restricted flag, categories)
- Reorganized data files into .data/ directory structure
- Added 30 category mapping files from SF Symbols app
- Released v1.1.0 with embedded metadata feature
- Removed info.txt export (data now in SVG metadata)
- Added --version/-v flag

## Notes
- Homebrew formula uses system Python to avoid unnecessary dependencies
- Data files installed to share/sfe/ for both pip and brew installations
- Script detects installation method and locates data files accordingly
- Badge auto-updates via GitHub Action when names.txt changes
- Extracted SVGs used directly by sf-symbols-lib project
- Each SVG is self-describing with W3C standard <metadata> tags

**Last Updated:** 2026-02-11
