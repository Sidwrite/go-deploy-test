# ArgoCD App of Apps Setup

## What Was Created

### 1. App of Apps Configuration
- **File:** `argocd/app-of-apps.yaml`
- **Purpose:** Main application that manages other applications
- **Watches:** `argocd/applications/` directory
- **Sync Policy:** Automated with self-heal

### 2. Applications Directory
- **Directory:** `argocd/applications/`
- **Purpose:** Store individual application configurations
- **Current Apps:** go-app.yaml

### 3. Setup Script
- **File:** `scripts/setup-argocd-app-of-apps.sh`
- **Purpose:** Automated setup of App of Apps
- **Features:** Status checks, namespace creation, ECR secret setup

### 4. Documentation
- **File:** `docs/ARGOCD_APP_OF_APPS.md`
- **Purpose:** Complete guide for App of Apps pattern

## How to Use

### 1. Setup App of Apps
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
```

### 3. Add New Applications
1. Create new YAML file in `argocd/applications/`
2. Commit and push to Git
3. ArgoCD automatically creates new application

## Benefits

1. **Centralized Management** - all apps in one place
2. **GitOps** - configuration as code
3. **Automatic Sync** - no manual intervention
4. **Self-healing** - reverts manual changes
5. **Scalable** - easy to add new applications

## Structure

```
argocd/
├── app-of-apps.yaml          # Main application
└── applications/             # Application configs
    └── go-app.yaml          # Go application
```

## Next Steps

1. Setup App of Apps
2. Check ArgoCD UI for status
3. Add more applications as needed
4. Monitor all applications from one place
5. Use GitOps for all changes

## Troubleshooting

- Check App of Apps status in ArgoCD UI
- Verify applications are in correct directory
- Check YAML syntax for new applications
- Ensure ArgoCD is running
- Verify repository access
