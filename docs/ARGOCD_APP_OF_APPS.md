# ArgoCD App of Apps

## Overview

App of Apps pattern for managing multiple applications in ArgoCD from a single Git repository.

## Structure

```
argocd/
├── app-of-apps.yaml          # Main application that manages others
└── applications/             # Directory with application configs
    └── go-app.yaml          # Go application configuration
```

## How It Works

1. **App of Apps** watches `argocd/applications/` directory
2. **Automatically creates** applications from YAML files
3. **Manages lifecycle** of all applications
4. **Self-healing** - reverts manual changes
5. **GitOps** - all configuration in Git

## Setup

### 1. Deploy App of Apps
```bash
# Using script (recommended)
./scripts/setup-argocd-app-of-apps.sh

# Or manually
kubectl apply -f argocd/app-of-apps.yaml
```

### 2. Check Status
```bash
# App of Apps status
kubectl get application app-of-apps -n argocd

# All applications
kubectl get application -n argocd

# Go app status
kubectl get application go-app -n argocd
```

## Adding New Applications

### 1. Create Application Config
Create new file in `argocd/applications/`:
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-new-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Sidwrite/go-deploy-test.git
    targetRevision: HEAD
    path: my-app-helm-chart
  destination:
    server: https://kubernetes.default.svc
    namespace: my-new-app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

### 2. Commit and Push
```bash
git add argocd/applications/my-new-app.yaml
git commit -m "Add new application"
git push origin main
```

### 3. ArgoCD Will Automatically Sync
- App of Apps detects new file
- Creates new application
- Starts deployment

## Benefits

1. **Centralized Management** - all apps in one place
2. **GitOps** - configuration as code
3. **Automatic Sync** - no manual intervention
4. **Self-healing** - reverts manual changes
5. **Scalable** - easy to add new applications

## Monitoring

### Check All Applications
```bash
# List all applications
kubectl get application -n argocd

# Check specific application
kubectl describe application go-app -n argocd
```

### ArgoCD UI
1. Access ArgoCD UI
2. Check **app-of-apps** application
3. See all managed applications
4. Monitor sync status

## Troubleshooting

### Application Not Syncing
```bash
# Check App of Apps status
kubectl describe application app-of-apps -n argocd

# Check application status
kubectl describe application go-app -n argocd
```

### New Application Not Created
1. Check file is in `argocd/applications/` directory
2. Verify YAML syntax
3. Check ArgoCD logs
4. Ensure App of Apps is synced

## Best Practices

1. **One application per file** - easier to manage
2. **Descriptive names** - clear application names
3. **Consistent structure** - same YAML structure
4. **Version control** - all changes in Git
5. **Documentation** - document each application
