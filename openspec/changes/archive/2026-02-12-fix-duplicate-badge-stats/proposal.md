## Why

The `update_readme_badge()` function in both `sfe` and `sfe_main.py` contains duplicate variable assignments (`per_variant` and `total_svgs` are computed twice identically) and a vestigial `colors = 1` variable from the removed color variants feature (v1.3.0). This dead code reduces readability and creates confusion about intent.

## What Changes

- Remove duplicate `per_variant` and `total_svgs` assignments
- Remove the obsolete `colors` variable and simplify statistics calculation
- Simplify the statistics output labels (no more "per variant and color" since there are no color variants)

## Capabilities

### New Capabilities

_None_

### Modified Capabilities

- `update-readme-badge`: Simplified statistics calculation with identical output behavior; removal of dead code and vestigial variables

## Impact

- `sfe`: Lines 263-277 in `update_readme_badge()` (statistics calculation and output)
- `sfe_main.py`: Same lines (identical mirror file)
