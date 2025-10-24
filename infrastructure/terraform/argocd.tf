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

# Create ArgoCD Application for App of Apps
resource "kubernetes_manifest" "argocd_app_of_apps" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "app-of-apps"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.argocd_repo_url
        targetRevision = "HEAD"
        path           = "argocd/applications"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "argocd"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }

  depends_on = [kubernetes_namespace.argocd]
}

# Create ArgoCD Application for Go App
resource "kubernetes_manifest" "argocd_go_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "go-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.argocd_repo_url
        targetRevision = "HEAD"
        path           = "helm-chart"
        helm = {
          valueFiles = ["values.yaml"]
          values = yamlencode({
            image = {
              repository = var.ecr_repository_url
              tag        = "latest"
            }
            imagePullSecrets = [
              {
                name = "ecr-secret"
              }
            ]
          })
        }
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "go-app"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }

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
