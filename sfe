#!/usr/bin/env python3
import argparse
import os
import re
import shutil
import sys
import time

# Determine base directory for data files
def get_base_dir():
    """Find the base directory containing data files."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Check if running from source directory
    if os.path.exists(os.path.join(script_dir, 'names.txt')):
        return script_dir
    
    # Check Homebrew Cellar path (when installed via brew)
    # Script is in: /opt/homebrew/bin/sfe
    # Data is in: /opt/homebrew/share/sfe/
    homebrew_share = os.path.join(os.path.dirname(script_dir), 'share', 'sfe')
    if os.path.exists(os.path.join(homebrew_share, 'names.txt')):
        return homebrew_share
    
    # Installed via pip/pipx - check common installation paths
    prefix_paths = [
        os.path.join(sys.prefix, 'share', 'sfe'),
        os.path.join(sys.prefix, 'local', 'share', 'sfe'),
    ]
    
    for path in prefix_paths:
        if os.path.exists(os.path.join(path, 'names.txt')):
            return path
    
    # Fallback to script directory
    return script_dir

BASE_DIR = get_base_dir()

# ANSI color codes
class Colors:
    RESET = "\033[0m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    CYAN = "\033[96m"
    BOLD = "\033[1m"
    DIM = "\033[2m"


# Expected file structure
SVG_BASE_DIRS = [
    "monochrome",
    "hierarchical",
]

REQUIRED_FILES = ["names.txt", "info.txt"] + [f"{d}/svgs.txt" for d in SVG_BASE_DIRS]

STRUCTURE_DIAGRAM = f"""
{Colors.BOLD}Expected directory structure:{Colors.RESET}

  {Colors.CYAN}<script-directory>/{Colors.RESET}
  ├── names.txt
  ├── info.txt
  ├── monochrome/
  │   └── svgs.txt
  └── hierarchical/
      └── svgs.txt
"""


def print_progress(current, total, bar_length=40):
    """Print a progress bar that updates in place."""
    percent = current / total
    filled = int(bar_length * percent)
    bar = "█" * filled + "░" * (bar_length - filled)
    sys.stdout.write(f"\r  {Colors.DIM}[{bar}] {current}/{total} ({percent*100:.1f}%){Colors.RESET}")
    sys.stdout.flush()


def format_duration(seconds):
    """Format duration in human readable format."""
    if seconds < 1:
        return f"{seconds*1000:.0f}ms"
    elif seconds < 60:
        return f"{seconds:.1f}s"
    else:
        mins = int(seconds // 60)
        secs = seconds % 60
        return f"{mins}m {secs:.1f}s"


def check_structure():
    """Check if the required file structure exists. Returns list of missing files."""
    missing = []
    for file_path in REQUIRED_FILES:
        full_path = os.path.join(BASE_DIR, file_path)
        if not os.path.exists(full_path):
            missing.append(file_path)
    return missing


def print_structure_error(missing_files):
    """Print error message with expected structure diagram."""
    print(f"{Colors.RED}ERROR:{Colors.RESET} Required files are missing:\n")
    for f in missing_files:
        print(f"  {Colors.RED}✗{Colors.RESET} {f}")
    print(STRUCTURE_DIAGRAM)


def count_extracted_svgs():
    """Count extracted SVG files in one variant/color directory. Returns 0 if none exist."""
    # Check one directory (hierarchical/primary) as reference - all should have the same count
    check_dir = os.path.join(BASE_DIR, SVG_BASE_DIRS[0])
    if not os.path.exists(check_dir):
        return 0
    svg_files = [f for f in os.listdir(check_dir) if f.endswith(".svg")]
    return len(svg_files)


def clean_svgs(base_path):
    """Delete all extracted SVG files from the directory structure."""
    svg_dirs = SVG_BASE_DIRS
    total_deleted = 0

    for rel_dir in svg_dirs:
        dir_path = os.path.join(base_path, rel_dir)
        if not os.path.exists(dir_path):
            continue

        svg_files = [f for f in os.listdir(dir_path) if f.endswith(".svg")]
        for svg_file in svg_files:
            os.remove(os.path.join(dir_path, svg_file))
            total_deleted += 1

        if svg_files:
            print(f"  {Colors.GREEN}✓{Colors.RESET} {rel_dir}: {len(svg_files)} files deleted")

    return total_deleted


def update_readme_badge():
    """Update the SF Symbols badge in README.md with the current SVG count."""
    svg_count = count_extracted_svgs()

    if svg_count == 0:
        print(f"{Colors.YELLOW}⊘{Colors.RESET} No extracted SVGs found. Run {Colors.BOLD}./sfe{Colors.RESET} first to extract SVGs.")
        return False

    readme_path = os.path.join(BASE_DIR, "README.md")
    if not os.path.exists(readme_path):
        print(f"{Colors.RED}ERROR:{Colors.RESET} README.md not found")
        return False

    with open(readme_path, "r") as f:
        content = f.read()

    # Pattern to match the SF Symbols badge
    pattern = r'(!\[SF Symbols\]\(https://img\.shields\.io/badge/SF%20Symbols-)\d+(-blue\?style=flat&logo=apple&logoColor=white\))'
    new_badge = rf'\g<1>{svg_count}\2'

    new_content, count = re.subn(pattern, new_badge, content)

    if count == 0:
        print(f"{Colors.YELLOW}⊘{Colors.RESET} SF Symbols badge not found in README.md")
        return False

    with open(readme_path, "w") as f:
        f.write(new_content)

    # Calculate statistics
    variants = len(SVG_BASE_DIRS)  # monochrome, hierarchical
    colors = 1  # no color variants
    per_variant = svg_count * colors
    total_svgs = svg_count * variants * colors
    per_variant = svg_count * colors
    total_svgs = svg_count * variants * colors

    # Format numbers right-aligned
    width = len(f"{total_svgs:,}")

    print(f"{Colors.GREEN}✓{Colors.RESET} Updated SF Symbols badge to {Colors.BOLD}{svg_count}{Colors.RESET}")
    print(f"  {Colors.DIM}├─{Colors.RESET} {Colors.CYAN}{total_svgs:>{width},}{Colors.RESET} SVGs total")
    print(f"  {Colors.DIM}├─{Colors.RESET} {Colors.CYAN}{per_variant:>{width},}{Colors.RESET} SVGs per variant")
    print(f"  {Colors.DIM}└─{Colors.RESET} {Colors.CYAN}{svg_count:>{width},}{Colors.RESET} SVGs per variant and color")
    return True


def main():
    parser = argparse.ArgumentParser(
        description="Extract individual SVG files from concatenated svgs.txt files.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=str(STRUCTURE_DIAGRAM)
    )
    parser.add_argument(
        "-c", "--check",
        action="store_true",
        help="Only check the directory structure, don't extract files"
    )
    parser.add_argument(
        "-u", "--update-badge",
        action="store_true",
        help="Update the SF Symbols badge in README.md with the current SVG count"
    )
    parser.add_argument(
        "-o", "--output",
        metavar="PATH",
        help="Output directory for extracted SVGs (preserves directory structure)"
    )
    parser.add_argument(
        "--clean",
        nargs="?",
        const=BASE_DIR,
        metavar="PATH",
        help="Delete all extracted SVG files (from current directory or specified path)"
    )
    args = parser.parse_args()

    # Check structure
    missing = check_structure()

    if args.check:
        if missing:
            print_structure_error(missing)
            sys.exit(1)
        else:
            print(f"{Colors.GREEN}✓{Colors.RESET} Directory structure is valid")
            sys.exit(0)

    if args.update_badge:
        success = update_readme_badge()
        sys.exit(0 if success else 1)

    if args.clean is not None:
        clean_path = os.path.expanduser(args.clean)
        print(f"{Colors.CYAN}Cleaning{Colors.RESET} {Colors.BOLD}{clean_path}{Colors.RESET}")
        deleted = clean_svgs(clean_path)
        if deleted > 0:
            print(f"{Colors.GREEN}✓{Colors.RESET} Deleted {Colors.BOLD}{deleted:,}{Colors.RESET} SVG files")
        else:
            print(f"{Colors.YELLOW}⊘{Colors.RESET} No SVG files found to delete")
        sys.exit(0)

    if missing:
        print_structure_error(missing)
        sys.exit(1)

    # Determine output base directory
    if args.output:
        output_base = os.path.expanduser(args.output)
        os.makedirs(output_base, exist_ok=True)
        print(f"{Colors.GREEN}✓{Colors.RESET} Output directory: {Colors.BOLD}{output_base}{Colors.RESET}")
        
        # Copy info.txt to output directory
        info_src = os.path.join(BASE_DIR, "info.txt")
        info_dst = os.path.join(output_base, "info.txt")
        shutil.copy2(info_src, info_dst)
        print(f"{Colors.GREEN}✓{Colors.RESET} Copied info.txt to output directory")
    else:
        output_base = BASE_DIR

    # Statistics
    stats = {
        "processed": 0,
        "skipped": 0,
        "warnings": 0,
        "total_svgs": 0,
    }

    start_time = time.time()

    # Read names
    names_file = os.path.join(BASE_DIR, "names.txt")
    with open(names_file, "r") as f:
        names = [line.strip() for line in f if line.strip()]

    print(f"{Colors.GREEN}✓{Colors.RESET} Loaded {Colors.BOLD}{len(names)}{Colors.RESET} names")

    # All svgs.txt paths (without names.txt)
    svg_files = [f"{d}/svgs.txt" for d in SVG_BASE_DIRS]

    for svg_file in svg_files:
        full_path = os.path.join(BASE_DIR, svg_file)
        rel_dir = os.path.dirname(svg_file)
        output_dir = os.path.join(output_base, rel_dir)

        print(f"\n{Colors.CYAN}Processing{Colors.RESET} {Colors.BOLD}{svg_file}{Colors.RESET}")

        if not os.path.exists(full_path):
            print(f"  {Colors.YELLOW}⊘ Skipping (file not found){Colors.RESET}")
            stats["skipped"] += 1
            continue

        os.makedirs(output_dir, exist_ok=True)

        with open(full_path, "r") as f:
            content = f.read()

        # Split by <?xml - each SVG starts with this
        parts = content.split('<?xml version="1.0" encoding="UTF-8"?>')
        # First part is empty, skip it
        svgs = [p.strip() for p in parts if p.strip()]

        if len(svgs) != len(names):
            print(f"  {Colors.RED}✗ WARNING:{Colors.RESET} SVG count ({len(svgs)}) != name count ({len(names)})")
            stats["warnings"] += 1
            continue

        for i, (name, svg_content) in enumerate(zip(names, svgs)):
            # Reconstruct full SVG with XML declaration
            full_svg = '<?xml version="1.0" encoding="UTF-8"?>\n' + svg_content

            output_path = os.path.join(output_dir, f"{name}.svg")
            with open(output_path, "w") as f:
                f.write(full_svg)

            print_progress(i + 1, len(names))

        stats["processed"] += 1
        stats["total_svgs"] += len(names)
        print(f"\n  {Colors.GREEN}✓ Done:{Colors.RESET} {len(names)} SVGs saved")

    # Calculate duration
    duration = time.time() - start_time

    # Print statistics
    print(f"\n{Colors.BOLD}{'─' * 50}{Colors.RESET}")
    print(f"{Colors.GREEN}{Colors.BOLD}All done!{Colors.RESET}")
    print(f"{Colors.BOLD}{'─' * 50}{Colors.RESET}")
    label_width = 22
    print(f"  {Colors.CYAN}{'Duration:'.ljust(label_width)}{Colors.RESET} {format_duration(duration)}")
    print(f"  {Colors.CYAN}{'Categories processed:'.ljust(label_width)}{Colors.RESET} {stats['processed']}/{len(svg_files)} ({stats['skipped']} skipped, {stats['warnings']} warnings)")
    print(f"  {Colors.CYAN}{'Variants:'.ljust(label_width)}{Colors.RESET} {len(SVG_BASE_DIRS)} (monochrome, hierarchical)")
    print(f"  {Colors.CYAN}{'SVGs per category:'.ljust(label_width)}{Colors.RESET} {len(names)}")
    print(f"  {Colors.CYAN}{'Total SVGs written:'.ljust(label_width)}{Colors.RESET} {stats['total_svgs']:,}")
    if stats["total_svgs"] > 0 and duration > 0:
        rate = stats["total_svgs"] / duration
        print(f"  {Colors.CYAN}{'Processing rate:'.ljust(label_width)}{Colors.RESET} {rate:,.0f} SVGs/sec")
    print(f"{Colors.BOLD}{'─' * 50}{Colors.RESET}")


if __name__ == "__main__":
    main()
