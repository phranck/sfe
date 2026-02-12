## Context

In v1.3.0, palette and multicolor rendering modes were removed and hierarchical was renamed to dualtone. The `update_readme_badge()` function still contains a `colors = 1` variable and duplicate assignments from the era when color variants existed. Both `sfe` and `sfe_main.py` are identical mirrors that must be kept in sync.

## Goals / Non-Goals

**Goals:**
- Remove dead code (duplicate assignments, vestigial `colors` variable)
- Simplify statistics calculation to reflect the current 2-mode model
- Update output labels to not reference color variants

**Non-Goals:**
- Changing the actual badge update logic or regex
- Restructuring the function beyond the statistics block
- Merging `sfe` and `sfe_main.py` into a single source of truth

## Decisions

### Decision 1: Inline the simplified calculation

Instead of `svg_count * variants * colors`, use `svg_count * variants` directly. The `colors` variable served no purpose at `1` and obscured the simple multiplication.

**Alternative considered:** Keep `colors` as a named constant for future extensibility. Rejected because YAGNI and the feature was deliberately removed.

### Decision 2: Simplify output labels

Replace the three-tier output (total / per variant / per variant and color) with a two-tier output (total / per mode) since "per variant and color" is now identical to "per mode".

## Risks / Trade-offs

- [Mirror files] Both `sfe` and `sfe_main.py` must receive identical changes. Forgetting one creates drift.
