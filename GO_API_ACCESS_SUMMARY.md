# Go API Access Summary

## Quick Access Commands

### 1. Port Forward (Recommended)
```bash
# Port forward to service
kubectl port-forward svc/go-api 8080:80 -n go-app

# Test application
curl http://localhost:8080/health
curl http://localhost:8080/
```

### 2. Check Access Options
```bash
# Run the access checker script
chmod +x scripts/check-go-api-access.sh
./scripts/check-go-api-access.sh
```

## Current Configuration

### Service Configuration
- **Name**: go-api
- **Type**: ClusterIP (internal only)
- **Port**: 80 (external) → 8080 (internal)
- **Namespace**: go-app

### Ingress Configuration
- **Enabled**: false (by default)
- **Host**: go-api.local (when enabled)
- **Path**: / (root path)

## Access Methods

### 1. Port Forward (Testing)
```bash
kubectl port-forward svc/go-api 8080:80 -n go-app
# Access: http://localhost:8080
```

### 2. Direct Pod Access
```bash
kubectl port-forward pod/go-api-xxx 8080:8080 -n go-app
# Access: http://localhost:8080
```

### 3. Enable Ingress (External Access)
```bash
# Update values.yaml
ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: go-api.yourdomain.com
      paths:
        - path: /
          pathType: Prefix

# Upgrade Helm release
helm upgrade go-api ./helm-chart \
  --namespace go-app \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=go-api.yourdomain.com
```

### 4. LoadBalancer (Direct External Access)
```bash
# Update service type
helm upgrade go-api ./helm-chart \
  --namespace go-app \
  --set service.type=LoadBalancer

# Get external IP
kubectl get svc go-api -n go-app -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

## Application Endpoints

- **Root**: `GET /` - Hello World with timestamp
- **Health**: `GET /health` - Health check endpoint

## Troubleshooting

### Check Status
```bash
# Check pods
kubectl get pods -n go-app

# Check service
kubectl get svc -n go-app

# Check ingress
kubectl get ingress -n go-app

# Check logs
kubectl logs -l app.kubernetes.io/name=go-api -n go-app
```

### Common Issues
1. **Service not accessible**: Check if pods are running
2. **Port forward fails**: Check if port is already in use
3. **Ingress not working**: Check ingress controller
4. **LoadBalancer pending**: Wait for AWS to assign IP

## Cost Implications

- **ClusterIP**: No additional cost
- **Port Forward**: No additional cost
- **Ingress**: Depends on ingress controller
- **LoadBalancer**: ~$18/month for AWS LoadBalancer

## Recommended Setup

### Development
```bash
# Use port forward
kubectl port-forward svc/go-api 8080:80 -n go-app
```

### Production
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

## Quick Test

```bash
# One-liner test
kubectl port-forward svc/go-api 8080:80 -n go-app & sleep 5 && curl http://localhost:8080/health && kill %1
```

Ready to access your Go API! 🚀
