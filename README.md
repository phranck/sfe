[![Mastodon: @phranck](https://img.shields.io/badge/Mastodon-@LAYERED-6364ff.svg?style=flat)](https://oldbytes.space/@LAYERED)
![SF Symbols](https://img.shields.io/badge/SF%20Symbols-6984-blue?style=flat&logo=apple&logoColor=white)
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

# sfe - SF Symbols Extractor

A Python tool to extract individual SVG files from concatenated `svgs.txt` files.

Current version: **SF Symbols 7.0**

## Directory Structure

```
sfe/
├── sfe                 # Extractor script
├── names.txt           # Symbol names (one per line)
├── hie/                # Hierarchical variant
│   ├── pri/            # Primary color
│   │   └── svgs.txt
│   └── sec/            # Secondary color
│       └── svgs.txt
├── mon/                # Monochrome variant
│   ├── pri/            # Primary color
│   │   └── svgs.txt
│   └── sec/            # Secondary color
│       └── svgs.txt
└── mul/                # Multicolor variant
    ├── pri/            # Primary color
    │   └── svgs.txt
    └── sec/            # Secondary color
        └── svgs.txt
```

## Symbol Variants & Colors

The directories are organized by SF Symbol rendering variants and colors:

**Variants:**
- `hie/` - Hierarchical
- `mon/` - Monochrome
- `mul/` - Multicolor

**Colors:**
- `pri/` - Primary Color
- `sec/` - Secondary Color

## Usage

```bash
# Check directory structure
./sfe --check | -c

# Update SF Symbols badge in README
./sfe --update-badge | -u

# Extract all SVGs
./sfe
```

The script extracts individual `.svg` files from each `svgs.txt` into their respective directories.

## Note

The extracted `.svg` files are excluded from version control (see `.gitignore`). Run `./sfe` after cloning to generate them.

## Contributing

Reports and pull requests are welcome. Please use the GitHub issue tracker for bug reports or feature requests.

## License

This repository has been published under the [CC-BY-NC-SA](https://creativecommons.org/licenses/by-nc-sa/4.0/) license.
