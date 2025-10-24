# Go API Helm Chart

A production-ready Helm chart for deploying the Go API application with high availability, failover, and zero-downtime rolling updates.

## Features

- **High Availability**: 3+ replicas with pod anti-affinity
- **Auto-scaling**: HPA with CPU and memory metrics
- **Rolling Updates**: Zero-downtime deployments
- **Health Checks**: Liveness and readiness probes
- **Security**: Non-root user, read-only filesystem
- **Resource Management**: CPU and memory limits/requests

## Installation

### Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

### Install Chart

```bash
# Add repository (if needed)
helm repo add my-repo https://charts.example.com

# Install the chart
helm install go-api ./helm-chart

# Or with custom values
helm install go-api ./helm-chart -f custom-values.yaml
```

### Upgrade

```bash
# Upgrade with zero downtime
helm upgrade go-api ./helm-chart

# Or with custom values
helm upgrade go-api ./helm-chart -f custom-values.yaml
```

## Configuration

### Key Values

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `3` |
| `image.repository` | Container image | `my-go-app` |
| `image.tag` | Image tag | `latest` |
| `autoscaling.enabled` | Enable HPA | `true` |
| `autoscaling.minReplicas` | Min replicas | `3` |
| `autoscaling.maxReplicas` | Max replicas | `10` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |

### High Availability

The chart includes:
- **Pod Anti-Affinity**: Pods spread across different nodes
- **Multiple Replicas**: Minimum 3 replicas for HA
- **Health Checks**: Automatic pod replacement on failure
- **Rolling Updates**: Zero-downtime deployments

### Auto-scaling

HPA is configured with:
- **CPU Target**: 50% utilization
- **Memory Target**: 80% utilization
- **Min Replicas**: 3
- **Max Replicas**: 10

## Examples

### Development

```yaml
replicaCount: 1
autoscaling:
  enabled: false
resources:
  limits:
    cpu: 100m
    memory: 128Mi
```

### Production

```yaml
replicaCount: 5
autoscaling:
  enabled: true
  minReplicas: 5
  maxReplicas: 20
resources:
  limits:
    cpu: 1000m
    memory: 1Gi
```

## Monitoring

The application exposes:
- **Health Endpoint**: `/health`
- **Main Endpoint**: `/`

Use these for monitoring and load balancing.

## Security

- Non-root user (UID 1000)
- Read-only root filesystem
- Dropped capabilities
- Security contexts applied
