#!/bin/bash

# Deploy ArgoCD Application
# Usage: ./scripts/deploy-argocd-app.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying ArgoCD Application${NC}"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if ArgoCD is running
echo -e "${YELLOW}📋 Checking ArgoCD status...${NC}"
if ! kubectl get pods -n argocd | grep -q "argocd-server"; then
    echo -e "${RED}❌ ArgoCD is not running. Please deploy ArgoCD first.${NC}"
    echo -e "${YELLOW}💡 Use: kubectl apply -f argocd/application.yaml${NC}"
    exit 1
fi

echo -e "${GREEN}✅ ArgoCD is running${NC}"

# Create namespace if it doesn't exist
echo -e "${YELLOW}📦 Creating namespace...${NC}"
kubectl create namespace go-app --dry-run=client -o yaml | kubectl apply -f -

# Create ECR secret
echo -e "${YELLOW}🔐 Creating ECR secret...${NC}"
./scripts/create-ecr-secret.sh go-app

# Apply ArgoCD application
echo -e "${YELLOW}📦 Deploying ArgoCD application...${NC}"
kubectl apply -f argocd/application.yaml

# Wait for application to be synced
echo -e "${YELLOW}⏳ Waiting for application to sync...${NC}"
kubectl wait --for=condition=Synced application/go-app -n argocd --timeout=300s

# Get application status
echo -e "${GREEN}📋 Application Status:${NC}"
kubectl get application go-app -n argocd

# Get pods status
echo -e "${GREEN}📋 Pods Status:${NC}"
kubectl get pods -n go-app

# Get services
echo -e "${GREEN}📋 Services:${NC}"
kubectl get svc -n go-app

echo -e "${GREEN}🎉 ArgoCD application deployed successfully!${NC}"
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "  1. Check ArgoCD UI for application status"
echo -e "  2. Monitor pods: kubectl get pods -n go-app -w"
echo -e "  3. Check logs: kubectl logs -l app.kubernetes.io/name=go-api -n go-app"
