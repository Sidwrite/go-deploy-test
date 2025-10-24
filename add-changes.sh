#!/bin/bash

# Add all changes to git
echo "🚀 Adding all changes to git..."

# Add all files
git add .

# Show status
echo "📋 Git status:"
git status

# Commit with descriptive message
echo "📝 Committing changes..."
git commit -m "Add ArgoCD App of Apps configuration

- Created App of Apps pattern for ArgoCD
- Added argocd/app-of-apps.yaml - main application manager
- Added argocd/applications/go-app.yaml - Go application config
- Created setup script for automated deployment
- Added comprehensive documentation
- Implemented GitOps pattern for application management
- Added centralized management for all applications
- Created troubleshooting guides
- Updated README with App of Apps information"

echo "✅ Changes added and committed successfully!"
echo "📋 Summary of changes:"
echo "  - App of Apps configuration"
echo "  - Application management"
echo "  - Setup scripts"
echo "  - Documentation"
echo "  - GitOps pattern"

echo "🚀 To push changes, run:"
echo "  git push origin main"
