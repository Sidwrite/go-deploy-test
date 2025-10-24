# Terraform Pipeline

## Overview

Single Terraform pipeline for all infrastructure operations:

- **Plan** - shows what would change
- **Apply** - creates/updates resources
- **Destroy** - removes resources (with confirmation)

## How to Use

### All Operations

1. Go to **Actions** → **Terraform**
2. Click **Run workflow**
3. Select:
   - **Project:** EKS or infra
   - **Action:** plan, apply, or destroy
   - **Confirm destroy:** DESTROY (only for destroy action)
4. Click **Run workflow**

## Projects

### EKS Project
- EKS cluster
- VPC and subnets
- Security groups
- IAM roles
- ArgoCD

### Infra Project
- VPC and subnets
- K3s cluster
- Database
- Bastion host
- App server
- Security groups

## Requirements

GitHub secrets required:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Safety

- **Plan** - safe, shows changes only
- **Apply** - creates/updates resources
- **Destroy** - removes everything (requires "DESTROY" confirmation)

## Benefits

- **Single pipeline** - easier to manage
- **All operations** - plan, apply, destroy in one place
- **Project selection** - choose EKS or infra
- **Safety confirmation** - required for destroy
- **Best practices** - format, validate, plan, apply
