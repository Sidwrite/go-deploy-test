# Go Application with EKS Deployment

Простой Go API с автоматическим деплоем в AWS EKS кластер через ArgoCD.

## 🚀 Особенности

- **Go API** с двумя эндпоинтами: `/` и `/health`
- **Docker контейнеризация** с multi-stage build
- **Kubernetes деплой** через Helm charts
- **AWS EKS кластер** с автоматической настройкой
- **ArgoCD GitOps** для автоматического деплоя
- **CI/CD pipeline** через GitHub Actions
- **Мониторинг** готов к настройке (Prometheus/Grafana)

## 📁 Структура проекта

```
my-go-app/
├── app/                          # Go приложение
│   ├── src/
│   │   ├── main.go              # Основной код
│   │   ├── main_test.go         # Тесты
│   │   └── go.mod               # Go модули
│   ├── Dockerfile               # Docker образ
│   └── README.md                # Документация приложения
├── helm-chart/                  # Helm chart для Kubernetes
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
├── infrastructure/               # Terraform инфраструктура
│   └── terraform/
│       ├── main.tf              # Основная конфигурация
│       ├── variables.tf         # Переменные
│       ├── outputs.tf           # Выводы
│       └── modules/eks/          # EKS модуль
├── scripts/                     # Скрипты для деплоя
├── docs/                        # Документация
├── .github/workflows/           # GitHub Actions CI/CD
└── README.md                     # Этот файл
```

## 🛠 Быстрый старт

### 1. Развертывание инфраструктуры

```bash
cd infrastructure/terraform
terraform init
terraform plan
terraform apply
```

### 2. Доступ к ArgoCD

После развертывания получите доступ к ArgoCD:

```bash
# Получить URL LoadBalancer
kubectl get svc -n argocd argocd-server

# Получить пароль администратора
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**ArgoCD UI:** https://[LOAD_BALANCER_URL]  
**Логин:** `admin`  
**Пароль:** [полученный выше]

### 3. Деплой приложения

1. **Добавьте Git репозиторий** в ArgoCD
2. **Создайте Application** для автоматического деплоя
3. **Настройте мониторинг** (опционально)

## 🔧 Разработка

### Локальная разработка

```bash
cd app/src
go run main.go
```

### Тестирование

```bash
cd app/src
go test -v
```

### Docker

```bash
cd app
docker build -t my-go-app .
docker run -p 8080:8080 my-go-app
```

## 📊 API Endpoints

- `GET /` - Hello World с текущим временем
- `GET /health` - Health check

### Примеры запросов

```bash
# Hello World
curl http://localhost:8080/

# Health check
curl http://localhost:8080/health
```

## 🏗 Инфраструктура

### AWS Ресурсы

- **EKS Cluster** - Kubernetes кластер
- **VPC** - Виртуальная сеть
- **Subnets** - Публичные и приватные подсети
- **Security Groups** - Правила безопасности
- **IAM Roles** - Роли для EKS и нод
- **ECR Repository** - Docker registry
- **LoadBalancer** - Внешний доступ к ArgoCD

### Стоимость (октябрь 2025)

- **EKS Cluster:** ~$72/месяц (фиксированно)
- **t3.medium Node:** ~$3/месяц (spot instances)
- **EBS Storage:** ~$2/месяц
- **LoadBalancer:** ~$18/месяц
- **Total:** ~$95/месяц

⚠️ **Внимание:** EKS дорогой для тестирования! Рекомендуется использовать локальные кластеры (k3s, kind, minikube) для разработки.

## 🔄 CI/CD

GitHub Actions автоматически:
1. **Тестирует** код при пуше в main
2. **Собирает** Docker образ
3. **Проверяет** работоспособность

## 📚 Документация

- [EKS Deployment Guide](docs/EKS_DEPLOYMENT.md)
- [ECR Setup](docs/ECR_SETUP.md)
- [Terraform State Bucket](docs/TERRAFORM_STATE_BUCKET.md)

## 🧹 Очистка

Для удаления всех ресурсов:

```bash
cd infrastructure/terraform
terraform destroy
```

## 📝 Лицензия

MIT License
