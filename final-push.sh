#!/bin/bash

# Final push script for all changes
echo "🚀 Final push of all changes..."

# Check if we're in the right directory
if [ ! -f "README.md" ]; then
    echo "❌ Not in the right directory. Please run from /Users/sidwrite/project/my-go-app"
    exit 1
fi

# Add all changes
echo "📦 Adding all changes to git..."
git add .

# Show status
echo "📋 Git status:"
git status

# Commit with comprehensive message
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
- Updated README with App of Apps information
- Added push scripts and instructions
- Created complete ArgoCD setup"

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
echo "  - Push scripts and instructions"

echo "🎉 Ready to use ArgoCD App of Apps!"
echo "📋 Next steps:"
echo "  1. Run: ./scripts/setup-argocd-app-of-apps.sh"
echo "  2. Check ArgoCD UI for application status"
echo "  3. Add more applications to argocd/applications/ directory"
echo "  4. Monitor all applications from ArgoCD UI"
