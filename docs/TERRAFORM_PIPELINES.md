# Terraform Pipelines

## Overview

We have two Terraform pipelines for managing infrastructure:

1. **Terraform Infrastructure** - Plan and apply infrastructure changes
2. **Terraform Destroy** - Safely destroy infrastructure

## How to Use

### Plan Infrastructure Changes

1. Go to **Actions** → **Terraform Infrastructure**
2. Click **Run workflow**
3. Select:
   - **Environment:** dev/staging/prod
   - **Action:** plan
4. Click **Run workflow**

### Apply Infrastructure Changes

1. Go to **Actions** → **Terraform Infrastructure**
2. Click **Run workflow**
3. Select:
   - **Environment:** dev/staging/prod
   - **Action:** apply
4. Click **Run workflow**

### Destroy Infrastructure

1. Go to **Actions** → **Terraform Destroy Infrastructure**
2. Click **Run workflow**
3. Fill in:
   - **Environment:** dev/staging/prod
   - **Type "DESTROY" to confirm:** DESTROY
   - **Destroy EKS infrastructure:** ✅/❌
   - **Destroy Infra infrastructure:** ✅/❌
4. Click **Run workflow**

## What Gets Managed

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

Make sure these GitHub secrets are set:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Safety Notes

- **Plan** is safe - it only shows what would change
- **Apply** creates/updates resources
- **Destroy** removes everything - use with caution!

The destroy pipeline requires typing "DESTROY" to confirm, but still be careful.
