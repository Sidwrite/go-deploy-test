#!/bin/bash

# Add and push all changes
echo "🚀 Adding and pushing all changes..."

# Add all files
echo "📦 Adding files to git..."
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

# Push to main branch
echo "🚀 Pushing to main branch..."
git push origin main

echo "✅ All changes pushed successfully!"
echo "📋 Summary of changes:"
echo "  - App of Apps configuration"
echo "  - Application management"
echo "  - Setup scripts"
echo "  - Documentation"
echo "  - GitOps pattern"

echo "🎉 Ready to use ArgoCD App of Apps!"
echo "📋 Next steps:"
echo "  1. Run: ./scripts/setup-argocd-app-of-apps.sh"
echo "  2. Check ArgoCD UI for application status"
echo "  3. Add more applications to argocd/applications/ directory"
