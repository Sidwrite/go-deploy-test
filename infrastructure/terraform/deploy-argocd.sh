#!/bin/bash

# Deploy ArgoCD using Terraform
# This script deploys the complete infrastructure with ArgoCD

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Deploying ArgoCD with Terraform${NC}"

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo -e "${RED}❌ Not in the right directory. Please run from infrastructure/terraform${NC}"
    exit 1
fi

# Check if Terraform is initialized
if [ ! -d ".terraform" ]; then
    echo -e "${YELLOW}📋 Terraform not initialized. Running init...${NC}"
    ./init-terraform.sh
fi

# Plan the deployment
echo -e "${YELLOW}📋 Planning Terraform deployment...${NC}"
terraform plan -out=tfplan

# Ask for confirmation
echo -e "${YELLOW}📋 Do you want to apply the changes? (y/N)${NC}"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}📋 Applying Terraform configuration...${NC}"
    terraform apply tfplan
    
    echo -e "${GREEN}✅ ArgoCD deployed successfully!${NC}"
    
    # Get outputs
    echo -e "${YELLOW}📋 Getting deployment information...${NC}"
    terraform output
    
    # Wait for ArgoCD to be ready
    echo -e "${YELLOW}📋 Waiting for ArgoCD to be ready...${NC}"
    kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd
    
    # Get ArgoCD admin password
    echo -e "${YELLOW}📋 Getting ArgoCD admin password...${NC}"
    ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
    
    echo -e "${GREEN}🎉 ArgoCD deployment completed!${NC}"
    echo -e "${YELLOW}📋 Access Information:${NC}"
    echo -e "  ArgoCD UI: https://localhost:8080"
    echo -e "  Username: admin"
    echo -e "  Password: ${ARGOCD_PASSWORD}"
    echo -e ""
    echo -e "${YELLOW}📋 To access ArgoCD UI:${NC}"
    echo -e "  1. Run: kubectl port-forward svc/argocd-server -n argocd 8080:443"
    echo -e "  2. Open: https://localhost:8080"
    echo -e "  3. Login with admin / ${ARGOCD_PASSWORD}"
    echo -e ""
    echo -e "${YELLOW}📋 ArgoCD Applications:${NC}"
    echo -e "  - App of Apps: app-of-apps"
    echo -e "  - Go App: go-app"
    echo -e ""
    echo -e "${GREEN}✅ All applications will be automatically deployed by ArgoCD!${NC}"
    
else
    echo -e "${YELLOW}📋 Deployment cancelled.${NC}"
fi
