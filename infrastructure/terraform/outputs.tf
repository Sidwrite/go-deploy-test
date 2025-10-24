# Outputs for Go App EKS Infrastructure

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.eks.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.eks.private_subnet_ids
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.eks.public_subnet_ids
}

output "node_group_arn" {
  description = "EKS node group ARN"
  value       = module.eks.node_group_arn
}

# kubectl config command
output "kubectl_config_command" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

# ECR Repository information
output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.go_app.repository_url
}

output "ecr_repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.go_app.name
}

output "ecr_login_command" {
  description = "Command to login to ECR"
  value       = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.go_app.repository_url}"
}

# ArgoCD information
output "argocd_info" {
  description = "ArgoCD installation information"
  value = {
    namespace = "argocd"
    ui_access = "kubectl port-forward svc/argocd-server -n argocd 8080:443"
    admin_password = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
  }
}
