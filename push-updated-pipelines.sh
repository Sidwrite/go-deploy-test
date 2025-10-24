#!/bin/bash

# Push updated Terraform pipelines
echo "🚀 Pushing updated Terraform pipelines..."

# Add all changes
git add .

# Commit with descriptive message
git commit -m "Update Terraform pipelines to best practices

- Simplified Terraform Infrastructure pipeline (single job)
- Simplified Terraform Destroy pipeline (single job)
- Added project selection (EKS or infra)
- Added environment protection
- Implemented Terraform best practices (format, validate, plan, apply)
- Removed complex reporting and artifacts
- Manual runs only for better control
- One project at a time for simplicity"

# Push to main branch
git push origin main

echo "✅ Updated pipelines pushed successfully!"
echo "📋 Summary of changes:"
echo "  - Simplified to single jobs"
echo "  - Added project selection"
echo "  - Implemented best practices"
echo "  - Removed complexity"
echo "  - Manual runs only"
