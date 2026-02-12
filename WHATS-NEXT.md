# What's Next

## Status Snapshot

- **Branch**: main
- **Active Task**: Migrate /save and /remember commands to ~/LLMs/commands/
- **Status**: in_progress
- **Last Updated**: 2026-02-12T01:18:44Z

## Current Checkpoint

- **File**: ~/.claude/commands/save.md, ~/.claude/commands/remember.md
- **What**: Moving command files to shared LLMs directory and creating symlinks
- **Phase**: 2 of 4 (copying files)

## Blockers

- cp command requires user confirmation (using -f flag to force overwrite)

## Next Steps (Immediate Actions)

1. Complete file copy with force flag (-f)
2. Remove original files from ~/.claude/commands/
3. Create symlinks in ~/.claude/commands/ pointing to ~/LLMs/commands/
4. Verify symlinks work correctly

---

## In Progress (1-2 items max)

- [ ] **Migrate /save and /remember commands**: Move from ~/.claude/commands/ to ~/LLMs/commands/ with symlinks

## Open (Backlog)

- [ ] **Add test coverage**: Write integration tests for metadata injection
- [ ] **Prepare SF Symbols 7.4**: Download and validate new symbol data when available
- [ ] **Improve documentation**: Document category mapping system and extension points

## Completed

- **2026-02-12**: Explored command structure, verified source and destination files exist
- **2026-02-12**: Created comprehensive CLAUDE.md with OpenSpec integration and global standards
- **2026-02-12**: Fixed duplicate badge statistics in update_readme_badge()
- **2026-02-10**: Updated Homebrew formula to v1.3.0, released stable version
- **2026-02-08**: Added metadata injection with apple name, library name, restricted status, version, and categories

## Notes

- Project is migrating commands to centralized ~/LLMs/commands/ directory for better maintainability
- Pattern already established: add-todo.md, anaylize-project.md, cm.md, code-review.md, commit.md, gen-docs.md are already symlinked
- Destination files (save.md, remember.md) already exist in ~/LLMs/commands/ but are older versions (Feb 7)
- Need to overwrite with newer versions from ~/.claude/commands/ (Feb 12)

**Last Updated**: 2026-02-12T01:18:44Z
