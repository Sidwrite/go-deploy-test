#!/bin/bash

# Go API Deployment Script
# Supports high availability, failover, and rolling updates

set -e

NAMESPACE=${1:-default}
RELEASE_NAME=${2:-go-api}
CHART_PATH="./helm-chart"

echo "🚀 Deploying Go API to Kubernetes..."
echo "Namespace: $NAMESPACE"
echo "Release: $RELEASE_NAME"

# Check if namespace exists, create if not
if ! kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo "📦 Creating namespace: $NAMESPACE"
    kubectl create namespace "$NAMESPACE"
fi

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "❌ Helm is not installed. Please install Helm first."
    exit 1
fi

# Build Docker image (if not exists)
echo "🐳 Building Docker image..."
cd app
docker build -t my-go-app:latest .
cd ..

# Install or upgrade the chart
if helm list -n "$NAMESPACE" | grep -q "$RELEASE_NAME"; then
    echo "🔄 Upgrading existing release..."
    helm upgrade "$RELEASE_NAME" "$CHART_PATH" \
        --namespace "$NAMESPACE" \
        --wait \
        --timeout=300s \
        --set image.tag=latest
else
    echo "🆕 Installing new release..."
    helm install "$RELEASE_NAME" "$CHART_PATH" \
        --namespace "$NAMESPACE" \
        --wait \
        --timeout=300s \
        --set image.tag=latest
fi

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/"$RELEASE_NAME" -n "$NAMESPACE"

# Get service info
echo "📋 Service Information:"
kubectl get svc "$RELEASE_NAME" -n "$NAMESPACE"

# Get pods info
echo "📋 Pods Information:"
kubectl get pods -l app.kubernetes.io/name=go-api -n "$NAMESPACE"

# Test the deployment
echo "🧪 Testing deployment..."
POD_NAME=$(kubectl get pods -l app.kubernetes.io/name=go-api -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}')
kubectl port-forward "pod/$POD_NAME" 8080:8080 -n "$NAMESPACE" &
PORT_FORWARD_PID=$!

sleep 5

# Test endpoints
echo "Testing /health endpoint..."
curl -f http://localhost:8080/health || echo "❌ Health check failed"

echo "Testing / endpoint..."
curl -f http://localhost:8080/ || echo "❌ Main endpoint failed"

# Cleanup port forward
kill $PORT_FORWARD_PID 2>/dev/null || true

echo "✅ Deployment completed successfully!"
echo "🔗 Access the application:"
echo "   kubectl port-forward svc/$RELEASE_NAME 8080:80 -n $NAMESPACE"
echo "   Then visit: http://localhost:8080"

