# Go App EKS Infrastructure - Minimal Setup
# AWS EKS Cluster with Free Tier resources

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "go-app"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  # Cluster configuration
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  environment     = var.environment

  # Network configuration
  vpc_cidr             = var.vpc_cidr
  availability_zones    = data.aws_availability_zones.available.names
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  # Node group configuration
  node_instance_types = var.node_instance_types
  node_capacity_type  = var.node_capacity_type
  node_disk_size     = var.node_disk_size
  node_desired_size  = var.node_desired_size
  node_max_size      = var.node_max_size
  node_min_size      = var.node_min_size
}

# ECR Repository for Go App
resource "aws_ecr_repository" "go_app" {
  name                 = "go-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "go-app-ecr"
    Environment = var.environment
  }
}

# ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "go_app" {
  repository = aws_ecr_repository.go_app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images older than 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Install ArgoCD via Helm
resource "null_resource" "argocd_install" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<-EOT
      # Wait for cluster to be ready
      aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}
      
      # Wait for nodes to be ready
      kubectl wait --for=condition=ready nodes --all --timeout=300s
      
      # Add ArgoCD Helm repository
      helm repo add argo https://argoproj.github.io/argo-helm
      helm repo update
      
      # Install ArgoCD
      helm upgrade --install argocd argo/argo-cd \
        --namespace argocd \
        --create-namespace \
        --set server.service.type=LoadBalancer \
        --set server.insecure=true \
        --wait \
        --timeout 10m0s
    EOT
  }

  triggers = {
    cluster_endpoint = module.eks.cluster_endpoint
  }
}
