# Go App EKS Infrastructure

Minimal AWS EKS cluster setup for testing Go application with Helm.

## Features

- **EKS Cluster** - Kubernetes 1.34
- **Node Group** - t3.medium spot instances (2 vCPU, 4GB RAM)
- **ArgoCD** - GitOps для автоматического деплоя
- **Prometheus + Grafana** - Мониторинг и алерты
- **VPC** - Custom VPC with public/private subnets
- **Security Groups** - Minimal security configuration
- **IAM Roles** - Required permissions for EKS

## Prerequisites

- AWS CLI configured
- Terraform >= 1.6
- kubectl
- AWS credentials with EKS permissions

## Quick Start

1. **Copy variables file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Plan deployment:**
   ```bash
   terraform plan
   ```

4. **Deploy infrastructure:**
   ```bash
   terraform apply
   ```

5. **Configure kubectl:**
   ```bash
   aws eks update-kubeconfig --region us-east-2 --name go-app-cluster
   ```

6. **Verify cluster:**
   ```bash
   kubectl get nodes
   ```

## Configuration

### Spot Instance Resources

- **Instance Type:** t3.medium (2 vCPU, 4GB RAM)
- **Capacity Type:** SPOT (до 90% экономии)
- **Disk Size:** 20GB (для метрик Prometheus)
- **Nodes:** 1-2 nodes
- **Region:** us-east-2

### Monitoring Stack

- **ArgoCD:** 0.5 vCPU, 256MB RAM
- **Prometheus:** 1 vCPU, 1GB RAM
- **Grafana:** 0.5 vCPU, 512MB RAM
- **Go App:** 0.1 vCPU, 128MB RAM

### Network

- **VPC:** 10.0.0.0/16
- **Public Subnets:** 10.0.1.0/24, 10.0.2.0/24
- **Private Subnets:** 10.0.10.0/24, 10.0.20.0/24

## Deploy Go App

After cluster is ready, deploy the Go application:

```bash
# From project root
cd ../helm-chart
helm install go-app . --namespace go-app --create-namespace
```

## Cleanup

```bash
terraform destroy
```

## Cost (October 2025)

⚠️ **ВНИМАНИЕ: EKS дорогой для тестирования!**

- **EKS Cluster Management:** $0.10/hour = **$72/month** (фиксированно!)
- **t3.medium Spot Node:** ~$0.004/hour = **~$3/month** (до 90% экономии!)
- **EBS Storage (20GB):** ~$2/month (для метрик Prometheus)
- **Total:** **~$77/month** (полный мониторинг стек)

**Поддерживаемые версии Kubernetes (October 2025):**
- **Стандартная поддержка:** 1.34, 1.33, 1.32, 1.31
- **Расширенная поддержка:** 1.30, 1.29, 1.28 (дополнительная плата)

**Альтернативы для тестирования:**
- **k3s на EC2:** ~$7.50/month (только нода)
- **minikube локально:** бесплатно
- **kind локально:** бесплатно

**Рекомендация:** Для тестирования используйте локальные кластеры!
