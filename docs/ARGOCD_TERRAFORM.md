# ArgoCD Terraform Configuration

This document explains how to deploy and manage ArgoCD using Terraform.

## Overview

The Terraform configuration includes:
- **EKS Cluster** - Kubernetes cluster for running applications
- **VPC** - Virtual Private Cloud with public/private subnets
- **ECR Repository** - Container registry for Docker images
- **ArgoCD** - GitOps continuous delivery tool
- **ArgoCD Applications** - App of Apps pattern for application management

## Files Structure

```
infrastructure/terraform/
├── main.tf                 # Main Terraform configuration
├── argocd.tf              # ArgoCD applications configuration
├── argocd-helm.tf         # ArgoCD Helm installation
├── variables.tf           # Terraform variables
├── outputs.tf             # Terraform outputs
├── init-terraform.sh      # Initialize Terraform
└── deploy-argocd.sh       # Deploy ArgoCD
```

## Prerequisites

1. **AWS CLI** configured with appropriate credentials
2. **Terraform** >= 1.0 installed
3. **kubectl** configured for EKS cluster
4. **Helm** for ArgoCD installation

## Quick Start

### 1. Initialize Terraform

```bash
cd infrastructure/terraform
chmod +x init-terraform.sh
./init-terraform.sh
```

### 2. Deploy ArgoCD

```bash
chmod +x deploy-argocd.sh
./deploy-argocd.sh
```

### 3. Access ArgoCD UI

```bash
# Port forward to access ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

Open: https://localhost:8080

## Configuration Details

### ArgoCD Applications

The Terraform configuration creates two ArgoCD applications:

#### 1. App of Apps (`app-of-apps`)
- **Purpose**: Central application manager
- **Source**: `argocd/applications` directory
- **Destination**: `argocd` namespace
- **Sync Policy**: Automated with prune and self-heal

#### 2. Go App (`go-app`)
- **Purpose**: Go application deployment
- **Source**: `helm-chart` directory
- **Destination**: `go-app` namespace
- **Sync Policy**: Automated with prune and self-heal

### ECR Integration

- **Repository**: `go-app`
- **Authentication**: ECR secret for image pull
- **Lifecycle Policy**: Keep last 10 images
- **Scanning**: Enabled on push

### EKS Cluster

- **Version**: 1.28
- **Node Groups**: Managed node groups with t3.medium instances
- **Networking**: VPC with public/private subnets
- **Access**: AWS IAM roles for cluster access

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `argocd_repo_url` | Git repository URL | `https://github.com/Sidwrite/go-deploy-test.git` |
| `ecr_repository_url` | ECR repository URL | `211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app` |
| `ecr_token` | ECR authentication token | `""` |
| `cluster_name` | EKS cluster name | `my-go-app-cluster` |
| `region` | AWS region | `us-east-2` |

## Outputs

| Output | Description |
|--------|-------------|
| `argocd_namespace` | ArgoCD namespace name |
| `go_app_namespace` | Go app namespace name |
| `argocd_app_of_apps_name` | App of Apps application name |
| `argocd_go_app_name` | Go app application name |
| `ecr_secret_name` | ECR secret name |
| `argocd_ui_url` | ArgoCD UI URL |
| `argocd_ui_commands` | Commands to access ArgoCD UI |

## Terraform Commands

### Plan
```bash
terraform plan
```

### Apply
```bash
terraform apply
```

### Destroy
```bash
terraform destroy
```

### Output
```bash
terraform output
```

## ArgoCD UI Access

### 1. Port Forward
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### 2. Get Admin Password
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

### 3. Access UI
- **URL**: https://localhost:8080
- **Username**: admin
- **Password**: (from step 2)

## Application Management

### Adding New Applications

1. **Create application manifest** in `argocd/applications/` directory
2. **Commit and push** to Git repository
3. **ArgoCD will automatically detect** and deploy the application

### Example Application

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Sidwrite/go-deploy-test.git
    targetRevision: HEAD
    path: helm-charts/my-app
  destination:
    server: https://kubernetes.default.svc
    namespace: my-app
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```

## Troubleshooting

### Common Issues

1. **ArgoCD not accessible**
   - Check if port-forward is running
   - Verify ArgoCD pods are running: `kubectl get pods -n argocd`

2. **Applications not syncing**
   - Check ArgoCD logs: `kubectl logs -n argocd deployment/argocd-server`
   - Verify Git repository access
   - Check application status in ArgoCD UI

3. **ECR authentication issues**
   - Verify ECR secret exists: `kubectl get secret ecr-secret -n go-app`
   - Check ECR token is valid
   - Verify ECR repository exists

### Useful Commands

```bash
# Check ArgoCD status
kubectl get pods -n argocd

# Check applications
kubectl get applications -n argocd

# Check ECR secret
kubectl get secret ecr-secret -n go-app

# ArgoCD logs
kubectl logs -n argocd deployment/argocd-server

# EKS cluster info
kubectl cluster-info
```

## Best Practices

1. **Use App of Apps pattern** for centralized management
2. **Enable automated sync** for continuous deployment
3. **Use namespaces** for application isolation
4. **Monitor ArgoCD UI** for application status
5. **Keep Git repository** as single source of truth
6. **Use Helm charts** for application packaging
7. **Enable ECR scanning** for security
8. **Use Terraform** for infrastructure management

## Next Steps

1. **Deploy infrastructure** using Terraform
2. **Access ArgoCD UI** and verify applications
3. **Add more applications** to `argocd/applications/` directory
4. **Monitor application health** through ArgoCD UI
5. **Set up monitoring** and alerting for applications
