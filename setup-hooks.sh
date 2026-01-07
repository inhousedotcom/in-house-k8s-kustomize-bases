#!/bin/bash
# Setup script to install git hooks

set -e

echo "🔧 Setting up git hooks..."

# Create .git/hooks directory if it doesn't exist
mkdir -p .git/hooks

# Copy hooks from .githooks to .git/hooks
if [ -f ".githooks/pre-commit" ]; then
    cp .githooks/pre-commit .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
    echo "✅ Pre-commit hook installed"
else
    echo "❌ .githooks/pre-commit not found"
    exit 1
fi

# Configure git to use .githooks directory (alternative method)
git config core.hooksPath .githooks

echo ""
echo "✅ Git hooks installed successfully!"
echo ""
echo "The pre-commit hook will:"
echo "  - Warn you to update CHANGELOG.md on feature branches"
echo "  - Enforce CHANGELOG.md updates on main branch"
echo "  - Validate version format and check for conflicts"
echo ""
echo "To bypass hook (emergency only): git commit --no-verify"
