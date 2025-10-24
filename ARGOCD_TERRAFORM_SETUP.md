# ArgoCD Terraform Setup Guide

## Overview

This guide shows how to deploy ArgoCD using Terraform with complete infrastructure management.

## What's Included

### Infrastructure
- **EKS Cluster** - Kubernetes cluster for applications
- **VPC** - Virtual network with public/private subnets
- **ECR Repository** - Container registry for Docker images
- **S3 Bucket** - Terraform state storage
- **DynamoDB Table** - State locking

### ArgoCD
- **ArgoCD Installation** - Via Helm chart
- **App of Apps Pattern** - Centralized application management
- **Go Application** - Automated deployment
- **ECR Integration** - Image pull secrets

## Quick Start

### 1. Navigate to Terraform Directory
```bash
cd /Users/sidwrite/project/my-go-app/infrastructure/terraform
```

### 2. Initialize Terraform
```bash
chmod +x init-terraform.sh
./init-terraform.sh
```

### 3. Deploy ArgoCD
```bash
chmod +x deploy-argocd.sh
./deploy-argocd.sh
```

### 4. Access ArgoCD UI
```bash
# Port forward to access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

**ArgoCD UI:** https://localhost:8080  
**Username:** admin  
**Password:** (from command above)

## Files Created

### Terraform Configuration
- `main.tf` - Main infrastructure configuration
- `argocd.tf` - ArgoCD applications
- `argocd-helm.tf` - ArgoCD Helm installation
- `variables.tf` - Terraform variables
- `outputs.tf` - Terraform outputs

### Scripts
- `init-terraform.sh` - Initialize Terraform
- `deploy-argocd.sh` - Deploy ArgoCD

### Documentation
- `docs/ARGOCD_TERRAFORM.md` - Complete documentation

## What Gets Deployed

### 1. EKS Cluster
- **Version:** 1.28
- **Node Groups:** t3.medium instances
- **Networking:** VPC with public/private subnets
- **Access:** IAM roles for cluster access

### 2. ArgoCD
- **Installation:** Via Helm chart
- **UI Access:** LoadBalancer service
- **Authentication:** Admin user with generated password
- **Applications:** App of Apps and Go app

### 3. ECR Repository
- **Name:** go-app
- **Scanning:** Enabled on push
- **Lifecycle:** Keep last 10 images
- **Authentication:** Kubernetes secret

### 4. ArgoCD Applications
- **App of Apps:** Central application manager
- **Go App:** Automated deployment
- **Sync Policy:** Automated with prune and self-heal

## Configuration Details

### Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `argocd_repo_url` | Git repository URL | `https://github.com/Sidwrite/go-deploy-test.git` |
| `ecr_repository_url` | ECR repository URL | `211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app` |
| `ecr_token` | ECR authentication token | `""` |
| `cluster_name` | EKS cluster name | `my-go-app-cluster` |
| `region` | AWS region | `us-east-2` |

### Outputs
| Output | Description |
|--------|-------------|
| `argocd_namespace` | ArgoCD namespace name |
| `go_app_namespace` | Go app namespace name |
| `argocd_app_of_apps_name` | App of Apps application name |
| `argocd_go_app_name` | Go app application name |
| `ecr_secret_name` | ECR secret name |
| `argocd_ui_url` | ArgoCD UI URL |
| `argocd_ui_commands` | Commands to access ArgoCD UI |

## After Deployment

### 1. ArgoCD Applications
- **App of Apps** will automatically sync
- **Go App** will be deployed automatically
- **All applications** managed centrally

### 2. Access Information
- **ArgoCD UI:** https://localhost:8080
- **Username:** admin
- **Password:** Generated automatically
- **Applications:** Visible in ArgoCD UI

### 3. Application Management
- **Add new applications** to `argocd/applications/` directory
- **ArgoCD will automatically detect** and deploy
- **Monitor applications** through ArgoCD UI

## Troubleshooting

### Common Issues

1. **ArgoCD not accessible**
   ```bash
   # Check ArgoCD pods
   kubectl get pods -n argocd
   
   # Check port-forward
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```

2. **Applications not syncing**
   ```bash
   # Check ArgoCD logs
   kubectl logs -n argocd deployment/argocd-server
   
   # Check applications
   kubectl get applications -n argocd
   ```

3. **ECR authentication issues**
   ```bash
   # Check ECR secret
   kubectl get secret ecr-secret -n go-app
   
   # Check ECR repository
   aws ecr describe-repositories --repository-names go-app
   ```

### Useful Commands

```bash
# Check EKS cluster
kubectl cluster-info

# Check ArgoCD status
kubectl get pods -n argocd

# Check applications
kubectl get applications -n argocd

# ArgoCD logs
kubectl logs -n argocd deployment/argocd-server

# ECR secret
kubectl get secret ecr-secret -n go-app
```

## Next Steps

1. **Deploy infrastructure** using Terraform
2. **Access ArgoCD UI** and verify applications
3. **Add more applications** to `argocd/applications/` directory
4. **Monitor application health** through ArgoCD UI
5. **Set up monitoring** and alerting for applications

## Benefits

- **Infrastructure as Code** - All infrastructure managed by Terraform
- **GitOps** - Applications managed through Git
- **Centralized Management** - All applications in one place
- **Automated Deployment** - Continuous deployment
- **Scalable** - Easy to add new applications
- **Secure** - ECR authentication and RBAC
- **Cost Effective** - Pay only for what you use

## Summary

This Terraform configuration provides:
- **Complete infrastructure** setup
- **ArgoCD installation** and configuration
- **Application management** through GitOps
- **ECR integration** for container images
- **Automated deployment** of applications
- **Centralized management** of all applications

Ready to deploy! 🚀
