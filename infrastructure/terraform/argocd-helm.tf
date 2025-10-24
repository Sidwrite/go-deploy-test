# ArgoCD Helm Installation
# This file installs ArgoCD using Helm and configures it

# Install ArgoCD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    yamlencode({
      global = {
        domain = "argocd.local"
      }
      server = {
        service = {
          type = "LoadBalancer"
        }
        ingress = {
          enabled = true
          ingressClassName = "nginx"
          annotations = {
            "kubernetes.io/ingress.class" = "nginx"
            "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
          }
          hosts = ["argocd.local"]
          tls = [
            {
              secretName = "argocd-server-tls"
              hosts      = ["argocd.local"]
            }
          ]
        }
        config = {
          "application.instanceLabelKey" = "argocd.argoproj.io/instance"
          "application.instanceLabelValue" = "argocd"
        }
      }
      controller = {
        metrics = {
          enabled = true
        }
      }
      dex = {
        enabled = false
      }
      notifications = {
        enabled = true
      }
      applicationSet = {
        enabled = true
      }
    })
  ]

  depends_on = [kubernetes_namespace.argocd]
}

# Create ArgoCD Project for applications
resource "kubernetes_manifest" "argocd_project" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AppProject"
    metadata = {
      name      = "default"
      namespace = "argocd"
    }
    spec = {
      description = "Default project for applications"
      sourceRepos = ["*"]
      destinations = [
        {
          namespace = "*"
          server    = "https://kubernetes.default.svc"
        }
      ]
      clusterResourceWhitelist = [
        {
          group = ""
          kind  = "Namespace"
        }
      ]
      namespaceResourceWhitelist = [
        {
          group = ""
          kind  = "Pod"
        }
      ]
    }
  }

  depends_on = [helm_release.argocd]
}
