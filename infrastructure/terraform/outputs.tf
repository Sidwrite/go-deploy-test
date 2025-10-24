# Outputs for ArgoCD Terraform Configuration

output "argocd_namespace" {
  description = "ArgoCD namespace name"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "go_app_namespace" {
  description = "Go app namespace name"
  value       = kubernetes_namespace.go_app.metadata[0].name
}

output "argocd_app_of_apps_name" {
  description = "ArgoCD App of Apps application name"
  value       = kubernetes_manifest.argocd_app_of_apps.manifest.metadata.name
}

output "argocd_go_app_name" {
  description = "ArgoCD Go app application name"
  value       = kubernetes_manifest.argocd_go_app.manifest.metadata.name
}

output "ecr_secret_name" {
  description = "ECR secret name for image pull"
  value       = kubernetes_secret.ecr_secret.metadata[0].name
}

output "argocd_ui_url" {
  description = "ArgoCD UI URL (port-forward required)"
  value       = "https://localhost:8080"
}

output "argocd_ui_commands" {
  description = "Commands to access ArgoCD UI"
  value = {
    port_forward = "kubectl port-forward svc/argocd-server -n argocd 8080:443"
    get_password  = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
    login_url     = "https://localhost:8080"
  }
}