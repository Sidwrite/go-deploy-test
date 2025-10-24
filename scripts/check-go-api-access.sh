#!/bin/bash

# Check Go API Access
# This script helps you find the best way to access your go-api application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔍 Checking Go API Access Options${NC}"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}❌ kubectl is not installed or not in PATH${NC}"
    exit 1
fi

# Check if we can connect to cluster
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}❌ Cannot connect to Kubernetes cluster${NC}"
    echo -e "${YELLOW}📋 Please check your kubeconfig and cluster connection${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Connected to Kubernetes cluster${NC}"

# Check namespace
NAMESPACE="go-app"
echo -e "${YELLOW}📋 Checking namespace: ${NAMESPACE}${NC}"

if ! kubectl get namespace "$NAMESPACE" &> /dev/null; then
    echo -e "${RED}❌ Namespace ${NAMESPACE} not found${NC}"
    echo -e "${YELLOW}📋 Available namespaces:${NC}"
    kubectl get namespaces
    exit 1
fi

echo -e "${GREEN}✅ Namespace ${NAMESPACE} exists${NC}"

# Check pods
echo -e "${YELLOW}📋 Checking pods in ${NAMESPACE}...${NC}"
PODS=$(kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=go-api --no-headers 2>/dev/null | wc -l)

if [ "$PODS" -eq 0 ]; then
    echo -e "${RED}❌ No go-api pods found in ${NAMESPACE}${NC}"
    echo -e "${YELLOW}📋 Available pods:${NC}"
    kubectl get pods -n "$NAMESPACE"
    exit 1
fi

echo -e "${GREEN}✅ Found ${PODS} go-api pod(s)${NC}"

# Check service
echo -e "${YELLOW}📋 Checking service...${NC}"
SERVICE=$(kubectl get svc -n "$NAMESPACE" -l app.kubernetes.io/name=go-api --no-headers 2>/dev/null | head -1 | awk '{print $1}')

if [ -z "$SERVICE" ]; then
    echo -e "${RED}❌ No go-api service found${NC}"
    echo -e "${YELLOW}📋 Available services:${NC}"
    kubectl get svc -n "$NAMESPACE"
    exit 1
fi

echo -e "${GREEN}✅ Found service: ${SERVICE}${NC}"

# Check service type
SERVICE_TYPE=$(kubectl get svc "$SERVICE" -n "$NAMESPACE" -o jsonpath='{.spec.type}')
echo -e "${YELLOW}📋 Service type: ${SERVICE_TYPE}${NC}"

# Check ingress
echo -e "${YELLOW}📋 Checking ingress...${NC}"
INGRESS=$(kubectl get ingress -n "$NAMESPACE" -l app.kubernetes.io/name=go-api --no-headers 2>/dev/null | head -1 | awk '{print $1}')

if [ -n "$INGRESS" ]; then
    echo -e "${GREEN}✅ Found ingress: ${INGRESS}${NC}"
    INGRESS_HOST=$(kubectl get ingress "$INGRESS" -n "$NAMESPACE" -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
    if [ -n "$INGRESS_HOST" ]; then
        echo -e "${YELLOW}📋 Ingress host: ${INGRESS_HOST}${NC}"
    fi
else
    echo -e "${YELLOW}📋 No ingress found${NC}"
fi

# Check LoadBalancer
if [ "$SERVICE_TYPE" = "LoadBalancer" ]; then
    EXTERNAL_IP=$(kubectl get svc "$SERVICE" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
    if [ -n "$EXTERNAL_IP" ]; then
        echo -e "${GREEN}✅ LoadBalancer external IP: ${EXTERNAL_IP}${NC}"
    else
        echo -e "${YELLOW}📋 LoadBalancer external IP not ready yet${NC}"
    fi
fi

echo -e "${BLUE}📋 Access Options:${NC}"

# Option 1: Port Forward
echo -e "${YELLOW}1. Port Forward (Recommended for testing):${NC}"
echo -e "   kubectl port-forward svc/${SERVICE} 8080:80 -n ${NAMESPACE}"
echo -e "   Then access: http://localhost:8080"
echo ""

# Option 2: Direct Pod Access
echo -e "${YELLOW}2. Direct Pod Access:${NC}"
POD_NAME=$(kubectl get pods -n "$NAMESPACE" -l app.kubernetes.io/name=go-api --no-headers | head -1 | awk '{print $1}')
if [ -n "$POD_NAME" ]; then
    echo -e "   kubectl port-forward pod/${POD_NAME} 8080:8080 -n ${NAMESPACE}"
    echo -e "   Then access: http://localhost:8080"
fi
echo ""

# Option 3: LoadBalancer
if [ "$SERVICE_TYPE" = "LoadBalancer" ] && [ -n "$EXTERNAL_IP" ]; then
    echo -e "${YELLOW}3. LoadBalancer (External access):${NC}"
    echo -e "   Access: http://${EXTERNAL_IP}"
    echo ""
fi

# Option 4: Ingress
if [ -n "$INGRESS_HOST" ]; then
    echo -e "${YELLOW}4. Ingress (External access):${NC}"
    echo -e "   Access: http://${INGRESS_HOST}"
    echo ""
fi

# Test application
echo -e "${YELLOW}📋 Testing application...${NC}"
echo -e "${YELLOW}Setting up port forward for testing...${NC}"

# Start port forward in background
kubectl port-forward svc/"$SERVICE" 8080:80 -n "$NAMESPACE" &
PORT_FORWARD_PID=$!

# Wait for port forward to be ready
sleep 5

# Test endpoints
echo -e "${YELLOW}Testing /health endpoint...${NC}"
if curl -f http://localhost:8080/health &> /dev/null; then
    echo -e "${GREEN}✅ Health check passed${NC}"
    curl http://localhost:8080/health
else
    echo -e "${RED}❌ Health check failed${NC}"
fi

echo -e "${YELLOW}Testing / endpoint...${NC}"
if curl -f http://localhost:8080/ &> /dev/null; then
    echo -e "${GREEN}✅ Main endpoint works${NC}"
    curl http://localhost:8080/
else
    echo -e "${RED}❌ Main endpoint failed${NC}"
fi

# Cleanup port forward
kill $PORT_FORWARD_PID 2>/dev/null || true

echo -e "${GREEN}🎉 Go API access check completed!${NC}"
echo -e "${BLUE}📋 Summary:${NC}"
echo -e "  Service: ${SERVICE}"
echo -e "  Type: ${SERVICE_TYPE}"
echo -e "  Namespace: ${NAMESPACE}"
echo -e "  Pods: ${PODS}"
if [ -n "$INGRESS_HOST" ]; then
    echo -e "  Ingress: ${INGRESS_HOST}"
fi
if [ -n "$EXTERNAL_IP" ]; then
    echo -e "  External IP: ${EXTERNAL_IP}"
fi

echo -e "${YELLOW}📋 Next steps:${NC}"
echo -e "  1. Use port forward for testing"
echo -e "  2. Configure ingress for external access"
echo -e "  3. Set up monitoring and logging"
echo -e "  4. Configure SSL/TLS for production"
