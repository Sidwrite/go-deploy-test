#!/bin/bash

# Create ECR secret for Kubernetes
# Usage: ./scripts/create-ecr-secret.sh [namespace]

set -e

NAMESPACE=${1:-default}
AWS_REGION=${AWS_REGION:-"us-east-2"}
ECR_REGISTRY="211125755493.dkr.ecr.us-east-2.amazonaws.com"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔐 Creating ECR secret for Kubernetes${NC}"
echo "Namespace: ${NAMESPACE}"
echo "ECR Registry: ${ECR_REGISTRY}"
echo ""

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if namespace exists, create if not
echo -e "${YELLOW}📋 Checking namespace...${NC}"
if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo -e "${YELLOW}📦 Creating namespace: $NAMESPACE${NC}"
    kubectl create namespace "$NAMESPACE"
else
    echo -e "${GREEN}✅ Namespace $NAMESPACE already exists${NC}"
fi

# Get ECR login token
echo -e "${YELLOW}🔐 Getting ECR login token...${NC}"
ECR_TOKEN=$(aws ecr get-login-password --region ${AWS_REGION})

# Create Docker config JSON
echo -e "${YELLOW}📋 Creating Docker config...${NC}"
DOCKER_CONFIG_JSON=$(echo -n "{\"auths\":{\"${ECR_REGISTRY}\":{\"username\":\"AWS\",\"password\":\"${ECR_TOKEN}\",\"auth\":\"$(echo -n "AWS:${ECR_TOKEN}" | base64)\"}}}")

# Create or update the secret
echo -e "${YELLOW}🔐 Creating ECR secret...${NC}"
kubectl create secret generic ecr-secret \
    --from-literal=.dockerconfigjson="${DOCKER_CONFIG_JSON}" \
    --type=kubernetes.io/dockerconfigjson \
    --namespace="${NAMESPACE}" \
    --dry-run=client -o yaml | kubectl apply -f -

echo -e "${GREEN}✅ ECR secret created successfully!${NC}"
echo -e "${GREEN}📋 Secret name: ecr-secret${NC}"
echo -e "${GREEN}📋 Namespace: ${NAMESPACE}${NC}"

# Verify the secret
echo -e "${YELLOW}📋 Verifying secret...${NC}"
kubectl get secret ecr-secret -n "${NAMESPACE}" -o yaml | grep -A 5 "data:"

echo -e "${GREEN}🎉 ECR secret is ready for use!${NC}"
echo -e "${YELLOW}💡 You can now deploy your Helm chart with ECR images.${NC}"
