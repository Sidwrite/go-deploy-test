#!/bin/bash

# Setup ArgoCD App of Apps
# Usage: ./scripts/setup-argocd-app-of-apps.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Setting up ArgoCD App of Apps${NC}"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if ArgoCD is running
echo -e "${YELLOW}📋 Checking ArgoCD status...${NC}"
if ! kubectl get pods -n argocd | grep -q "argocd-server"; then
    echo -e "${RED}❌ ArgoCD is not running. Please deploy ArgoCD first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ ArgoCD is running${NC}"

# Wait for ArgoCD to be ready
echo -e "${YELLOW}⏳ Waiting for ArgoCD to be ready...${NC}"
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s

# Create namespace for applications
echo -e "${YELLOW}📦 Creating namespace for applications...${NC}"
kubectl create namespace go-app --dry-run=client -o yaml | kubectl apply -f -

# Create ECR secret
echo -e "${YELLOW}🔐 Creating ECR secret...${NC}"
./scripts/create-ecr-secret.sh go-app

# Apply App of Apps
echo -e "${YELLOW}📦 Deploying App of Apps...${NC}"
kubectl apply -f argocd/app-of-apps.yaml

# Wait for App of Apps to be synced
echo -e "${YELLOW}⏳ Waiting for App of Apps to sync...${NC}"
kubectl wait --for=condition=Synced application/app-of-apps -n argocd --timeout=300s

# Wait for go-app to be synced
echo -e "${YELLOW}⏳ Waiting for go-app to sync...${NC}"
kubectl wait --for=condition=Synced application/go-app -n argocd --timeout=300s

# Get application status
echo -e "${GREEN}📋 Application Status:${NC}"
kubectl get application -n argocd

# Get pods status
echo -e "${GREEN}📋 Pods Status:${NC}"
kubectl get pods -n go-app

# Get services
echo -e "${GREEN}📋 Services:${NC}"
kubectl get svc -n go-app

echo -e "${GREEN}🎉 ArgoCD App of Apps setup completed successfully!${NC}"
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "  1. Check ArgoCD UI for application status"
echo -e "  2. Monitor pods: kubectl get pods -n go-app -w"
echo -e "  3. Check logs: kubectl logs -l app.kubernetes.io/name=go-api -n go-app"
echo -e "  4. Add more applications to argocd/applications/ directory"
