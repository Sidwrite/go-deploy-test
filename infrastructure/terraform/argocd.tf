# ArgoCD Terraform Configuration
# This file manages ArgoCD installation and configuration

# Create namespace for ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      name = "argocd"
    }
  }
}

# Create ArgoCD Application for App of Apps using local file
resource "kubernetes_manifest" "argocd_app_of_apps" {
  manifest = yamldecode(file("${path.module}/../../argocd/app-of-apps.yaml"))

  depends_on = [kubernetes_namespace.argocd]
}

# Create ArgoCD Application for Go App using local file
resource "kubernetes_manifest" "argocd_go_app" {
  manifest = yamldecode(file("${path.module}/../../argocd/applications/go-app.yaml"))

  depends_on = [kubernetes_namespace.argocd]
}

# Create ECR secret for ArgoCD
resource "kubernetes_secret" "ecr_secret" {
  metadata {
    name      = "ecr-secret"
    namespace = "go-app"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.ecr_repository_url}" = {
          auth = base64encode("AWS:${var.ecr_token}")
        }
      }
    })
  }

  depends_on = [kubernetes_namespace.argocd]
}

# Create namespace for Go app
resource "kubernetes_namespace" "go_app" {
  metadata {
    name = "go-app"
    labels = {
      name = "go-app"
    }
  }
}
