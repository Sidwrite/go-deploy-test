#!/bin/bash

# Deploy Go App to EKS Cluster
# Usage: ./scripts/deploy-to-eks.sh [namespace] [release-name]

set -e

NAMESPACE=${1:-production}
RELEASE_NAME=${2:-go-api}
CLUSTER_NAME=${CLUSTER_NAME:-"go-app-cluster"}
AWS_REGION=${AWS_REGION:-"us-east-2"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Deploying Go App to EKS Cluster${NC}"
echo "Cluster: ${CLUSTER_NAME}"
echo "Namespace: ${NAMESPACE}"
echo "Release: ${RELEASE_NAME}"
echo "Region: ${AWS_REGION}"
echo ""

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo -e "${RED}❌ Helm is not installed. Please install it first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ All prerequisites are installed${NC}"

# Configure kubectl for EKS
echo -e "${YELLOW}🔧 Configuring kubectl for EKS...${NC}"
aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}

# Verify cluster connection
echo -e "${YELLOW}📋 Verifying cluster connection...${NC}"
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}❌ Cannot connect to EKS cluster. Please check your AWS credentials and cluster name.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Successfully connected to EKS cluster${NC}"

# Create namespace if it doesn't exist
echo -e "${YELLOW}📦 Creating namespace...${NC}"
if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    kubectl create namespace "$NAMESPACE"
    echo -e "${GREEN}✅ Created namespace: $NAMESPACE${NC}"
else
    echo -e "${GREEN}✅ Namespace $NAMESPACE already exists${NC}"
fi

# Create ECR secret
echo -e "${YELLOW}🔐 Creating ECR secret...${NC}"
./scripts/create-ecr-secret.sh $NAMESPACE

# Deploy Helm chart
echo -e "${YELLOW}📦 Deploying Helm chart...${NC}"
if helm list -n "$NAMESPACE" | grep -q "$RELEASE_NAME"; then
    echo -e "${YELLOW}🔄 Upgrading existing release...${NC}"
    helm upgrade "$RELEASE_NAME" ./helm-chart \
        --namespace "$NAMESPACE" \
        --wait \
        --timeout=300s \
        --set image.tag=latest
else
    echo -e "${YELLOW}🆕 Installing new release...${NC}"
    helm install "$RELEASE_NAME" ./helm-chart \
        --namespace "$NAMESPACE" \
        --wait \
        --timeout=300s \
        --set image.tag=latest
fi

# Wait for deployment to be ready
echo -e "${YELLOW}⏳ Waiting for deployment to be ready...${NC}"
kubectl wait --for=condition=available --timeout=300s deployment/"$RELEASE_NAME" -n "$NAMESPACE"

# Get deployment info
echo -e "${GREEN}📋 Deployment Information:${NC}"
echo -e "${BLUE}Service:${NC}"
kubectl get svc "$RELEASE_NAME" -n "$NAMESPACE"

echo -e "${BLUE}Pods:${NC}"
kubectl get pods -l app.kubernetes.io/name=go-api -n "$NAMESPACE"

echo -e "${BLUE}Ingress:${NC}"
kubectl get ingress -n "$NAMESPACE" 2>/dev/null || echo "No ingress found"

# Test the deployment
echo -e "${YELLOW}🧪 Testing deployment...${NC}"
POD_NAME=$(kubectl get pods -l app.kubernetes.io/name=go-api -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}')
if [ -n "$POD_NAME" ]; then
    echo -e "${YELLOW}📋 Pod logs (last 10 lines):${NC}"
    kubectl logs "$POD_NAME" -n "$NAMESPACE" --tail=10
    
    # Port forward for testing
    echo -e "${YELLOW}🔗 Setting up port forward for testing...${NC}"
    kubectl port-forward "pod/$POD_NAME" 8080:8080 -n "$NAMESPACE" &
    PORT_FORWARD_PID=$!
    
    sleep 5
    
    # Test endpoints
    echo -e "${YELLOW}Testing /health endpoint...${NC}"
    curl -f http://localhost:8080/health && echo -e "${GREEN}✅ Health check passed${NC}" || echo -e "${RED}❌ Health check failed${NC}"
    
    echo -e "${YELLOW}Testing / endpoint...${NC}"
    curl -f http://localhost:8080/ && echo -e "${GREEN}✅ Main endpoint works${NC}" || echo -e "${RED}❌ Main endpoint failed${NC}"
    
    # Cleanup port forward
    kill $PORT_FORWARD_PID 2>/dev/null || true
else
    echo -e "${RED}❌ No pods found for testing${NC}"
fi

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "  1. Check logs: kubectl logs -l app.kubernetes.io/name=go-api -n $NAMESPACE"
echo -e "  2. Port forward: kubectl port-forward svc/$RELEASE_NAME 8080:80 -n $NAMESPACE"
echo -e "  3. Access app: http://localhost:8080"
echo -e "  4. Monitor: kubectl get pods -n $NAMESPACE -w"
