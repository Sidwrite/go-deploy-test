# Helm Chart с ECR Integration

## Обновленный Helm Chart для Go App

Helm chart был обновлен для использования образов из Amazon ECR вместо локальной сборки.

## 🔄 **Что изменилось:**

### **1. Образ приложения**
```yaml
# Было:
image:
  repository: my-go-app
  tag: "latest"

# Стало:
image:
  repository: 211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app
  tag: "latest"
```

### **2. ECR Authentication**
```yaml
imagePullSecrets:
  - name: ecr-secret
```

### **3. Автоматическое создание ECR Secret**
- Скрипт `scripts/create-ecr-secret.sh` создает Kubernetes secret для ECR
- Secret обновляется автоматически при каждом деплое

## 🚀 **Как использовать:**

### **1. Создание ECR Secret**
```bash
# Создать secret в default namespace
./scripts/create-ecr-secret.sh

# Создать secret в конкретном namespace
./scripts/create-ecr-secret.sh production
```

### **2. Деплой приложения**
```bash
# Деплой в default namespace
./deploy.sh

# Деплой в конкретный namespace
./deploy.sh production go-api
```

### **3. Ручной деплой через Helm**
```bash
# Создать ECR secret
./scripts/create-ecr-secret.sh production

# Установить Helm chart
helm install go-api ./helm-chart \
  --namespace production \
  --create-namespace \
  --set image.tag=latest
```

## 📋 **Конфигурация:**

### **Основные параметры в values.yaml:**
```yaml
# Образ из ECR
image:
  repository: 211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app
  tag: "latest"
  pullPolicy: IfNotPresent

# ECR Authentication
imagePullSecrets:
  - name: ecr-secret

# Реплики
replicaCount: 3

# Автоскейлинг
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
```

### **Health Checks:**
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

## 🔧 **Преимущества нового подхода:**

1. **🔄 Автоматические обновления** - образы обновляются через CI/CD
2. **🔐 Безопасность** - ECR authentication через Kubernetes secrets
3. **📦 Централизованное хранение** - все образы в ECR
4. **🚀 Быстрый деплой** - не нужно собирать образы локально
5. **🏷️ Версионирование** - поддержка разных тегов образов

## 🎯 **Workflow:**

```
1. Push в main → CI/CD → ECR (автоматически)
2. Деплой → ECR Secret → Helm Install → ✅
```

## 🔍 **Проверка деплоя:**

```bash
# Проверить pods
kubectl get pods -l app.kubernetes.io/name=go-api

# Проверить образы
kubectl describe pod <pod-name> | grep Image

# Проверить ECR secret
kubectl get secret ecr-secret -o yaml

# Проверить логи
kubectl logs -l app.kubernetes.io/name=go-api
```

## 🛠️ **Troubleshooting:**

### **Ошибка "ImagePullBackOff"**
```bash
# Проверить ECR secret
kubectl get secret ecr-secret

# Пересоздать ECR secret
./scripts/create-ecr-secret.sh <namespace>
```

### **Ошибка "ErrImagePull"**
```bash
# Проверить доступность образа в ECR
aws ecr list-images --repository-name go-app --region us-east-2

# Проверить права доступа
kubectl describe secret ecr-secret
```

## 📊 **Мониторинг:**

```bash
# Статус деплоя
helm status go-api

# История релизов
helm history go-api

# Обновление до новой версии
helm upgrade go-api ./helm-chart --set image.tag=<new-tag>
```
