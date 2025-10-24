# ECR Setup для Go App

## Создание ECR репозитория

ECR (Elastic Container Registry) репозиторий уже создан для хранения Docker образов Go приложения.

### Информация о репозитории

- **Название:** go-app
- **URI:** `211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app`
- **Регион:** us-east-2
- **Статус:** ✅ Создан и готов к использованию

## Что нужно сделать перед использованием

### 1. Настройка AWS CLI

Убедитесь, что AWS CLI настроен с правильными credentials:

```bash
aws configure list
```

Если не настроен, выполните:
```bash
aws configure
```

### 2. Логин в ECR

Перед push/pull образов необходимо авторизоваться в ECR:

```bash
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 211125755493.dkr.ecr.us-east-2.amazonaws.com
```

### 3. Сборка и пуш образа

```bash
# Перейти в директорию с приложением
cd my-go-app

# Собрать Docker образ
docker build -t go-app:latest -f app/Dockerfile .

# Тегировать образ для ECR
docker tag go-app:latest 211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app:latest

# Запушить в ECR
docker push 211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app:latest
```

### 4. Проверка образа в ECR

```bash
# Список образов в репозитории
aws ecr list-images --repository-name go-app --region us-east-2

# Детали конкретного образа
aws ecr describe-images --repository-name go-app --image-ids imageTag=latest --region us-east-2
```

## Использование в Kubernetes

После создания образа, обновите `values.yaml` в Helm chart:

```yaml
image:
  repository: 211125755493.dkr.ecr.us-east-2.amazonaws.com/go-app
  tag: latest
  pullPolicy: IfNotPresent
```

## Lifecycle Policy (опционально)

Для автоматической очистки старых образов можно настроить lifecycle policy:

```bash
aws ecr put-lifecycle-policy --repository-name go-app --lifecycle-policy-text '{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}' --region us-east-2
```

## Troubleshooting

### Ошибка авторизации
```bash
# Проверить AWS credentials
aws sts get-caller-identity

# Перелогиниться в ECR
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 211125755493.dkr.ecr.us-east-2.amazonaws.com
```

### Ошибка доступа к репозиторию
```bash
# Проверить права доступа
aws ecr describe-repositories --repository-names go-app --region us-east-2
```

## Полезные команды

```bash
# Удалить образ
aws ecr batch-delete-image --repository-name go-app --image-ids imageTag=old-tag --region us-east-2

# Получить URL репозитория
aws ecr describe-repositories --repository-names go-app --query 'repositories[0].repositoryUri' --output text --region us-east-2
```
