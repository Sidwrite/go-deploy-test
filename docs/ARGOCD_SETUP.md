# ArgoCD Setup

## Overview

ArgoCD configuration for automatic deployment from your Git repository.

## Configuration

### Application Configuration
- **Repository:** https://github.com/Sidwrite/go-deploy-test.git
- **Path:** helm-chart
- **Target:** go-app namespace
- **Sync Policy:** Automated with self-heal

### Image Configuration
- **Repository:** 211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app
- **Tag:** latest
- **Pull Secret:** ecr-secret

## How to Deploy

### 1. Deploy ArgoCD Application
```bash
# Create namespace
kubectl create namespace go-app

# Create ECR secret
./scripts/create-ecr-secret.sh go-app

# Deploy application
kubectl apply -f argocd/application.yaml
```

### 2. Using Script (Recommended)
```bash
./scripts/deploy-argocd-app.sh
```

## Verification

### Check Application Status
```bash
# ArgoCD application status
kubectl get application go-app -n argocd

# Pods status
kubectl get pods -n go-app

# Services
kubectl get svc -n go-app
```

### Check ArgoCD UI
1. Get ArgoCD URL:
```bash
kubectl get svc -n argocd argocd-server
```

2. Get admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

3. Access ArgoCD UI and check application status

## How It Works

1. **ArgoCD watches** your Git repository
2. **Detects changes** in helm-chart directory
3. **Automatically syncs** changes to Kubernetes
4. **Uses ECR images** from your CI/CD pipeline
5. **Self-heals** if manual changes are made

## Benefits

- **GitOps** - infrastructure as code
- **Automatic sync** - no manual deployment needed
- **Self-healing** - reverts manual changes
- **History tracking** - see all changes in ArgoCD UI
- **Rollback** - easy rollback to previous versions

## Troubleshooting

### Application Not Syncing
```bash
# Check application status
kubectl describe application go-app -n argocd

# Check ArgoCD logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
```

### Image Pull Errors
```bash
# Check ECR secret
kubectl get secret ecr-secret -n go-app

# Recreate ECR secret
./scripts/create-ecr-secret.sh go-app
```

### Pod Issues
```bash
# Check pod logs
kubectl logs -l app.kubernetes.io/name=go-api -n go-app

# Check pod events
kubectl describe pod <pod-name> -n go-app
```
