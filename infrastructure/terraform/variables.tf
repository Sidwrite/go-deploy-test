# Variables for ArgoCD Terraform Configuration

variable "argocd_repo_url" {
  description = "Git repository URL for ArgoCD applications"
  type        = string
  default     = "https://github.com/Sidwrite/go-deploy-test.git"
}

variable "ecr_repository_url" {
  description = "ECR repository URL for Docker images"
  type        = string
  default     = "211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app"
}

variable "ecr_token" {
  description = "ECR authentication token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-go-app-cluster"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}
