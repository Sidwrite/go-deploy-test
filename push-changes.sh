#!/bin/bash

# Push changes to Git
echo "🚀 Pushing changes to Git..."

# Add all changes
git add .

# Commit with descriptive message
git commit -m "Update pipelines to manual-only and translate docs to English

- Changed Terraform pipelines to manual-only (workflow_dispatch)
- Translated README.md to English with human-like writing
- Created TERRAFORM_PIPELINES.md for concise usage guide
- Simplified documentation structure
- Added safety features for destructive operations"

# Push to main branch
git push origin main

echo "✅ Changes pushed successfully!"
echo "📋 Summary of changes:"
echo "  - Terraform pipelines now manual-only"
echo "  - Documentation translated to English"
echo "  - Simplified and human-like writing"
echo "  - Added safety confirmations"
