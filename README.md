# Go Application with EKS Deployment

A simple Go API with automated deployment to AWS EKS cluster via ArgoCD.

## Features

- **Go API** with two endpoints: `/` and `/health`
- **Docker containerization** with multi-stage build
- **Kubernetes deployment** via Helm charts
- **AWS EKS cluster** with automatic setup
- **ArgoCD GitOps** for automated deployment
- **CI/CD pipeline** via GitHub Actions
- **Monitoring** ready for setup (Prometheus/Grafana)

## Project Structure

```
my-go-app/
├── app/                          # Go application
│   ├── src/
│   │   ├── main.go              # Main code
│   │   ├── main_test.go         # Tests
│   │   └── go.mod               # Go modules
│   ├── Dockerfile               # Docker image
│   └── README.md                # App documentation
├── helm-chart/                  # Helm chart for Kubernetes
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
├── infrastructure/               # Terraform infrastructure
│   ├── EKS/                     # EKS project
│   └── infra/                   # Infra project
├── scripts/                     # Deployment scripts
├── docs/                        # Documentation
├── .github/workflows/           # GitHub Actions CI/CD
└── README.md                    # This file
```

## Quick Start

### 1. Deploy Infrastructure

Use the Terraform pipeline:
1. Go to **Actions** → **Terraform Infrastructure**
2. Click **Run workflow**
3. Select **Environment:** dev and **Action:** apply
4. Click **Run workflow**

### 2. Access ArgoCD

After deployment, get ArgoCD access:

```bash
# Get LoadBalancer URL
kubectl get svc -n argocd argocd-server

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**ArgoCD UI:** https://[LOAD_BALANCER_URL]  
**Login:** `admin`  
**Password:** [from above command]

### 3. Deploy Application

1. **Add Git repository** to ArgoCD
2. **Create Application** for automated deployment
3. **Setup monitoring** (optional)

## Development

### Local Development

```bash
cd app/src
go run main.go
```

### Testing

```bash
cd app/src
go test -v
```

### Docker

```bash
cd app
docker build -t my-go-app .
docker run -p 8080:8080 my-go-app
```

## API Endpoints

- `GET /` - Hello World with current time
- `GET /health` - Health check

### Example Requests

```bash
# Hello World
curl http://localhost:8080/

# Health check
curl http://localhost:8080/health
```

## Infrastructure

### AWS Resources

- **EKS Cluster** - Kubernetes cluster
- **VPC** - Virtual network
- **Subnets** - Public and private subnets
- **Security Groups** - Security rules
- **IAM Roles** - Roles for EKS and nodes
- **ECR Repository** - Docker registry
- **LoadBalancer** - External access to ArgoCD

### Cost (October 2025)

- **EKS Cluster:** ~$72/month (fixed)
- **t3.medium Node:** ~$3/month (spot instances)
- **EBS Storage:** ~$2/month
- **LoadBalancer:** ~$18/month
- **Total:** ~$95/month

⚠️ **Note:** EKS is expensive for testing! Consider using local clusters (k3s, kind, minikube) for development.

## CI/CD

### Application CI/CD
GitHub Actions automatically:
1. **Tests** code on push to main
2. **Builds** Docker image
3. **Checks** functionality
4. **Deploys** to ECR

### Infrastructure CI/CD
Single Terraform pipeline:
1. **Plan** infrastructure changes
2. **Apply** changes to selected project (EKS or infra)
3. **Destroy** infrastructure with confirmation
4. **Manual runs only** - full control over deployments

## Documentation

- [Terraform Pipelines](docs/TERRAFORM_PIPELINES.md) - How to use Terraform pipelines
- [ArgoCD App of Apps](docs/ARGOCD_APP_OF_APPS.md) - App of Apps pattern for ArgoCD
- [ArgoCD Terraform](docs/ARGOCD_TERRAFORM.md) - Deploy ArgoCD with Terraform
- [ArgoCD Setup](docs/ARGOCD_SETUP.md) - ArgoCD configuration and deployment
- [EKS Deployment](docs/EKS_DEPLOYMENT.md) - Deploy to EKS cluster
- [ECR Setup](docs/ECR_SETUP.md) - ECR configuration
- [Helm ECR Deployment](docs/HELM_ECR_DEPLOYMENT.md) - Helm with ECR

## Cleanup

### Automatic Cleanup (Recommended)
1. Go to **Actions** → **Terraform**
2. Click **Run workflow**
3. Select:
   - **Project:** EKS or infra
   - **Action:** destroy
   - **Confirm destroy:** DESTROY
4. Click **Run workflow**

### Manual Cleanup
```bash
# EKS project
cd infrastructure/EKS
terraform destroy

# Infra project
cd infrastructure/infra
terraform destroy
```

⚠️ **Warning:** Destruction is irreversible! All data will be lost.

## License

MIT License
