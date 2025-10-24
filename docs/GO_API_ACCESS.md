# Go API Access Guide

## Overview

This guide explains how to access the go-api application in your Kubernetes cluster.

## Current Configuration

Based on your Helm chart configuration:

### Service Configuration
- **Type**: ClusterIP (internal only)
- **Port**: 80 (external) → 8080 (internal)
- **Target Port**: 8080 (application port)

### Ingress Configuration
- **Enabled**: false (by default)
- **Host**: go-api.local (when enabled)
- **Path**: / (root path)

## Access Methods

### 1. Port Forward (Recommended for Testing)

```bash
# Port forward to service
kubectl port-forward svc/go-api 8080:80 -n go-app

# Access application
curl http://localhost:8080/
curl http://localhost:8080/health
```

### 2. Direct Pod Access

```bash
# Get pod name
kubectl get pods -n go-app -l app.kubernetes.io/name=go-api

# Port forward to pod
kubectl port-forward pod/go-api-xxx 8080:8080 -n go-app

# Access application
curl http://localhost:8080/
curl http://localhost:8080/health
```

### 3. Enable Ingress (For External Access)

To enable external access, update your values.yaml:

```yaml
ingress:
  enabled: true
  className: "nginx"  # or your ingress controller
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
  hosts:
    - host: go-api.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
```

Then upgrade your Helm release:

```bash
helm upgrade go-api ./helm-chart \
  --namespace go-app \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=go-api.yourdomain.com
```

### 4. Change Service Type to LoadBalancer

For direct external access:

```yaml
service:
  type: LoadBalancer
  port: 80
  targetPort: 8080
```

Update and apply:

```bash
helm upgrade go-api ./helm-chart \
  --namespace go-app \
  --set service.type=LoadBalancer
```

## Check Current Status

### 1. Check Service
```bash
kubectl get svc -n go-app
```

### 2. Check Pods
```bash
kubectl get pods -n go-app
```

### 3. Check Ingress
```bash
kubectl get ingress -n go-app
```

### 4. Check Application Logs
```bash
kubectl logs -l app.kubernetes.io/name=go-api -n go-app
```

## Troubleshooting

### Service Not Accessible
```bash
# Check service endpoints
kubectl get endpoints -n go-app

# Check pod status
kubectl describe pods -n go-app

# Check service details
kubectl describe svc go-api -n go-app
```

### Port Forward Issues
```bash
# Check if port is already in use
lsof -i :8080

# Try different port
kubectl port-forward svc/go-api 8081:80 -n go-app
```

### Ingress Issues
```bash
# Check ingress controller
kubectl get pods -n ingress-nginx

# Check ingress status
kubectl describe ingress go-api -n go-app
```

## Quick Access Commands

### Test Application
```bash
# Port forward and test
kubectl port-forward svc/go-api 8080:80 -n go-app &
curl http://localhost:8080/health
curl http://localhost:8080/
```

### Get External IP (if LoadBalancer)
```bash
kubectl get svc go-api -n go-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### Get Ingress URL (if enabled)
```bash
kubectl get ingress go-api -n go-app -o jsonpath='{.spec.rules[0].host}'
```

## Application Endpoints

- **Root**: `GET /` - Hello World with timestamp
- **Health**: `GET /health` - Health check endpoint

## Security Considerations

1. **ClusterIP Service**: Only accessible within cluster
2. **Port Forward**: Only accessible from local machine
3. **Ingress**: Requires ingress controller and proper DNS
4. **LoadBalancer**: Creates external AWS LoadBalancer (costs money)

## Cost Implications

- **ClusterIP**: No additional cost
- **Port Forward**: No additional cost
- **Ingress**: Depends on ingress controller
- **LoadBalancer**: ~$18/month for AWS LoadBalancer

## Recommended Setup

For development:
```bash
# Use port forward
kubectl port-forward svc/go-api 8080:80 -n go-app
```

For production:
```yaml
# Enable ingress with proper domain
ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: api.yourdomain.com
      paths:
        - path: /
          pathType: Prefix
```

## Next Steps

1. **Choose access method** based on your needs
2. **Configure ingress** for external access
3. **Set up monitoring** for application health
4. **Configure SSL/TLS** for production use
5. **Set up domain** and DNS records
