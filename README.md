# Go Application with EKS Deployment

A simple Go API with automated deployment to AWS EKS cluster.

## Features

- **Go API** with two endpoints: `/` and `/health`
- **Docker containerization** with multi-stage build
- **Kubernetes deployment** via Helm charts
- **AWS EKS cluster** with automatic setup
- **ECR Repository** for Docker images
- **CI/CD pipeline** via GitHub Actions

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
│   └── my-go-app/
├── infrastructure/               # Terraform infrastructure
│   ├── EKS/                     # EKS + ArgoCD project
│   └── infra/                    # Infra project
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
3. Select **Project:** EKS and **Action:** apply
4. Click **Run workflow**

### 2. Build and Push Application

The CI pipeline automatically:
1. **Tests** code on push to main
2. **Builds** Docker image
3. **Pushes** to ECR
4. **Deploys** to EKS

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

### Cost (October 2025)

- **EKS Cluster:** ~$72/month (fixed)
- **t3.medium Node:** ~$3/month (spot instances)
- **EBS Storage:** ~$2/month
- **Total:** ~$77/month

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

**EKS Project includes:**
- EKS cluster + VPC
- ECR repository
- ArgoCD installation
- ArgoCD applications (App of Apps + Go App)
- ECR authentication secrets

## Documentation

- [Terraform Pipelines](docs/TERRAFORM_PIPELINES.md) - How to use Terraform pipelines
- [EKS Deployment](docs/EKS_DEPLOYMENT.md) - Deploy to EKS cluster
- [ECR Setup](docs/ECR_SETUP.md) - ECR configuration

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