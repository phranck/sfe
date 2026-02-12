## ADDED Requirements

### Requirement: Statistics calculation uses only active variables

The `update_readme_badge()` function SHALL compute statistics using only variables
that represent active features. Variables from removed features (color variants)
SHALL NOT be present. Each variable SHALL be assigned exactly once.

#### Scenario: No duplicate assignments

- **WHEN** `update_readme_badge()` calculates statistics
- **THEN** `per_variant` and `total_svgs` SHALL each be assigned exactly once

#### Scenario: No vestigial color variables

- **WHEN** `update_readme_badge()` calculates statistics
- **THEN** no `colors` variable SHALL exist in the calculation
- **AND** the computation SHALL use `svg_count * variants` directly for `total_svgs`

### Requirement: Statistics output reflects current feature set

The statistics output labels SHALL accurately describe the current data model
without referencing removed features.

#### Scenario: Output labels match rendering model

- **WHEN** `update_readme_badge()` prints statistics
- **THEN** the output SHALL NOT contain the phrase "per variant and color"
- **AND** the output SHALL contain clear labels for total, per-variant, and per-symbol counts
