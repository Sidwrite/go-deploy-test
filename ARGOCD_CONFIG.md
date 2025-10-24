# ArgoCD Configuration

## What Was Created

### 1. ArgoCD Application Configuration
- **File:** `argocd/application.yaml`
- **Repository:** https://github.com/Sidwrite/go-deploy-test.git
- **Path:** helm-chart
- **Namespace:** go-app
- **Sync Policy:** Automated with self-heal

### 2. Deployment Script
- **File:** `scripts/deploy-argocd-app.sh`
- **Purpose:** Deploy ArgoCD application with ECR secret
- **Features:** Status checks, namespace creation, ECR secret setup

### 3. Documentation
- **File:** `docs/ARGOCD_SETUP.md`
- **Purpose:** Complete setup and troubleshooting guide

## How to Use

### 1. Deploy ArgoCD Application
```bash
# Using script (recommended)
./scripts/deploy-argocd-app.sh

# Or manually
kubectl apply -f argocd/application.yaml
```

### 2. Check Status
```bash
# Application status
kubectl get application go-app -n argocd

# Pods status
kubectl get pods -n go-app
```

### 3. Access ArgoCD UI
```bash
# Get ArgoCD URL
kubectl get svc -n argocd argocd-server

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Configuration Details

### Repository Settings
- **URL:** https://github.com/Sidwrite/go-deploy-test.git
- **Branch:** HEAD (latest)
- **Path:** helm-chart

### Image Settings
- **Repository:** 211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app
- **Tag:** latest
- **Pull Secret:** ecr-secret

### Sync Settings
- **Automated:** true
- **Self-heal:** true
- **Prune:** true
- **Create Namespace:** true

## Benefits

1. **GitOps** - infrastructure as code
2. **Automatic sync** - no manual deployment
3. **Self-healing** - reverts manual changes
4. **History tracking** - see all changes
5. **Easy rollback** - revert to previous versions

## Next Steps

1. Deploy ArgoCD application
2. Check ArgoCD UI for status
3. Monitor application deployment
4. Test automatic sync with code changes
5. Use ArgoCD UI for management

## Troubleshooting

- Check application status in ArgoCD UI
- Verify ECR secret exists
- Check pod logs for errors
- Ensure ArgoCD is running
- Verify repository access
