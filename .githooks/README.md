# Git Hooks

This directory contains git hooks for the repository.

## Setup

Run the setup script to install hooks:

```bash
./setup-hooks.sh
```

Or manually:
```bash
git config core.hooksPath .githooks
chmod +x .githooks/*
```

## Pre-commit Hook

Checks CHANGELOG.md before committing:

### On Feature Branches
- **Advisory only** - provides reminders
- Does not block commits
- Warns if CHANGELOG not updated

### On Main Branch  
- **Strictly enforced**
- Requires CHANGELOG.md to be updated
- Validates unreleased version format
- Checks for version conflicts

### Bypass (Emergency Only)
```bash
git commit --no-verify
```

## Release Workflow

1. **Feature Development**
   ```bash
   git checkout -b feature/my-feature
   # Make changes
   git commit -m "feat: add feature"
   ```

2. **Update CHANGELOG** (before PR)
   ```bash
   # Add to CHANGELOG.md:
   ## [v1.1.0] - Unreleased
   
   ### Added
   - New feature description
   
   git commit -m "docs: update CHANGELOG for v1.1.0"
   ```

3. **Create PR** → Workflows validate CHANGELOG

4. **Merge to Main** → Auto-creates tag v1.1.0

## Version Numbering

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (v1.0.0 → v2.0.0): Breaking changes
- **MINOR** (v1.0.0 → v1.1.0): New features, backward compatible  
- **PATCH** (v1.0.0 → v1.0.1): Bug fixes, backward compatible
