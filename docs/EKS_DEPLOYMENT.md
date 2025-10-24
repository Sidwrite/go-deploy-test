# Деплой в EKS кластер

## 🚀 **Способы деплоя Go App в EKS:**

### **1. Автоматический деплой (рекомендуется)**

```bash
# Деплой в production namespace
./scripts/deploy-to-eks.sh production go-api

# Деплой в default namespace
./scripts/deploy-to-eks.sh default go-api
```

### **2. Ручной деплой через Helm**

```bash
# 1. Настроить kubectl
aws eks update-kubeconfig --region us-east-2 --name go-app-cluster

# 2. Создать ECR secret
./scripts/create-ecr-secret.sh production

# 3. Деплой Helm chart
helm install go-api ./helm-chart \
  --namespace production \
  --create-namespace \
  --set image.tag=latest
```

### **3. Деплой через ArgoCD (GitOps)**

```bash
# 1. Установить ArgoCD (если не установлен)
./deploy-argocd.sh

# 2. Создать ECR secret в namespace go-app
./scripts/create-ecr-secret.sh go-app

# 3. Применить ArgoCD Application
kubectl apply -f argocd/go-app-application.yaml
```

## 📋 **Что делает скрипт deploy-to-eks.sh:**

1. ✅ **Проверка prerequisites** (AWS CLI, kubectl, Helm)
2. ✅ **Настройка kubectl** для EKS кластера
3. ✅ **Создание namespace** если не существует
4. ✅ **Создание ECR secret** для аутентификации
5. ✅ **Деплой Helm chart** с ECR образом
6. ✅ **Health checks** и тестирование
7. ✅ **Вывод информации** о деплое

## 🔧 **Требования:**

### **Prerequisites:**
- AWS CLI настроен с credentials
- kubectl установлен
- Helm установлен
- EKS кластер создан и доступен

### **Переменные окружения:**
```bash
export CLUSTER_NAME="go-app-cluster"  # Имя EKS кластера
export AWS_REGION="us-east-2"        # AWS регион
```

## 🎯 **Workflow деплоя:**

```
1. Скрипт проверяет prerequisites
2. Настраивает kubectl для EKS
3. Создает namespace
4. Создает ECR secret
5. Деплоит Helm chart
6. Проверяет health endpoints
7. Выводит информацию о доступе
```

## 📊 **Проверка деплоя:**

### **Проверить статус:**
```bash
# Статус pods
kubectl get pods -n production

# Статус сервисов
kubectl get svc -n production

# Логи приложения
kubectl logs -l app.kubernetes.io/name=go-api -n production
```

### **Доступ к приложению:**
```bash
# Port forward
kubectl port-forward svc/go-api 8080:80 -n production

# Тест endpoints
curl http://localhost:8080/health
curl http://localhost:8080/
```

## 🔍 **Troubleshooting:**

### **Ошибка "ImagePullBackOff":**
```bash
# Проверить ECR secret
kubectl get secret ecr-secret -n production

# Пересоздать ECR secret
./scripts/create-ecr-secret.sh production
```

### **Ошибка "ErrImagePull":**
```bash
# Проверить доступность образа в ECR
aws ecr list-images --repository-name go-app --region us-east-2

# Проверить права доступа
kubectl describe secret ecr-secret -n production
```

### **Ошибка подключения к кластеру:**
```bash
# Проверить AWS credentials
aws sts get-caller-identity

# Проверить доступ к кластеру
aws eks describe-cluster --name go-app-cluster --region us-east-2
```

## 🚀 **Обновление приложения:**

### **Обновление через Helm:**
```bash
helm upgrade go-api ./helm-chart \
  --namespace production \
  --set image.tag=latest
```

### **Обновление через ArgoCD:**
```bash
# ArgoCD автоматически синхронизирует изменения из Git
# Просто сделайте push в репозиторий
git add .
git commit -m "Update app"
git push origin main
```

## 📈 **Мониторинг:**

```bash
# Статус Helm релиза
helm status go-api -n production

# История релизов
helm history go-api -n production

# Логи в реальном времени
kubectl logs -f -l app.kubernetes.io/name=go-api -n production
```

## 🎉 **Готово!**

После успешного деплоя ваше приложение будет доступно:
- **Внутри кластера:** через Service
- **Снаружи:** через Ingress (если настроен)
- **Локально:** через port-forward

Приложение автоматически обновляется при каждом push в main ветку через CI/CD пайплайн! 🚀
