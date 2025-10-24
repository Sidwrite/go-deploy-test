# S3 Bucket для New Project Terraform State

## Создание S3 Bucket для хранения Terraform State

Для безопасного хранения Terraform state файлов был создан S3 bucket с версионированием и шифрованием.

### Информация о Bucket

- **Название:** `new-project-terraform-state-211125755493`
- **Регион:** us-east-2
- **Версионирование:** ✅ Включено
- **Шифрование:** ✅ AES256
- **Статус:** ✅ Создан и готов к использованию

## Что было сделано

### 1. Создание S3 Bucket

```bash
# Создание bucket с уникальным именем
aws s3 mb s3://new-project-terraform-state-211125755493 --region us-east-2
```

### 2. Настройка версионирования

```bash
# Включение версионирования для отслеживания изменений state
aws s3api put-bucket-versioning --bucket new-project-terraform-state-211125755493 --versioning-configuration Status=Enabled
```

### 3. Настройка шифрования

```bash
# Включение шифрования по умолчанию
aws s3api put-bucket-encryption --bucket new-project-terraform-state-211125755493 --server-side-encryption-configuration '{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'
```

### 4. Настройка блокировки публичного доступа

```bash
# Блокировка публичного доступа для безопасности
aws s3api put-public-access-block --bucket new-project-terraform-state-211125755493 --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
```

## Конфигурация Terraform Backend

В файле `backend.tf` настроен remote backend:

```hcl
terraform {
  backend "s3" {
    bucket = "new-project-terraform-state-211125755493"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
```

## Что нужно сделать перед использованием Terraform

### 1. Инициализация Terraform Backend

```bash
cd /Users/sidwrite/project/new-project/infra
terraform init
```

### 2. Проверка состояния

```bash
# Проверить, что state файл создан в S3
aws s3 ls s3://new-project-terraform-state-211125755493/

# Проверить версии state файла
aws s3api list-object-versions --bucket new-project-terraform-state-211125755493 --prefix terraform.tfstate
```

### 3. Безопасность

- ✅ State файлы зашифрованы
- ✅ Версионирование включено
- ✅ Публичный доступ заблокирован
- ✅ Доступ только через AWS IAM

## Полезные команды

### Просмотр содержимого bucket

```bash
# Список файлов в bucket
aws s3 ls s3://new-project-terraform-state-211125755493/

# Детальная информация о файлах
aws s3api list-objects-v2 --bucket new-project-terraform-state-211125755493
```

### Управление версиями

```bash
# Список всех версий state файла
aws s3api list-object-versions --bucket new-project-terraform-state-211125755493 --prefix terraform.tfstate

# Восстановление предыдущей версии
aws s3api copy-object --copy-source new-project-terraform-state-211125755493/terraform.tfstate --bucket new-project-terraform-state-211125755493 --key terraform.tfstate
```

### Очистка старых версий

```bash
# Удаление старых версий (осторожно!)
aws s3api delete-object --bucket new-project-terraform-state-211125755493 --key terraform.tfstate --version-id VERSION_ID
```

## Troubleshooting

### Ошибка доступа к bucket

```bash
# Проверить права доступа
aws s3api head-bucket --bucket new-project-terraform-state-211125755493

# Проверить настройки bucket
aws s3api get-bucket-versioning --bucket new-project-terraform-state-211125755493
aws s3api get-bucket-encryption --bucket new-project-terraform-state-211125755493
```

### Проблемы с инициализацией Terraform

```bash
# Переинициализация backend
terraform init -reconfigure

# Принудительная инициализация
terraform init -force-copy
```

## Безопасность и лучшие практики

1. **Никогда не коммитьте state файлы в Git**
2. **Используйте IAM роли для доступа к bucket**
3. **Регулярно создавайте бэкапы state файлов**
4. **Используйте DynamoDB для state locking (опционально)**

### Настройка DynamoDB для state locking (рекомендуется)

```bash
# Создание DynamoDB таблицы для блокировки state
aws dynamodb create-table \
  --table-name new-project-terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --region us-east-2
```

Затем обновить `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "new-project-terraform-state-211125755493"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "new-project-terraform-state-lock"
  }
}
```

## Сравнение с предыдущим bucket

| Параметр | Go App Bucket | New Project Bucket |
|----------|---------------|-------------------|
| Название | go-app-terraform-state-211125755493 | new-project-terraform-state-211125755493 |
| Назначение | Go App инфраструктура | New Project инфраструктура |
| Регион | us-east-2 | us-east-2 |
| Версионирование | ✅ | ✅ |
| Шифрование | ✅ | ✅ |
| Публичный доступ | Заблокирован | Заблокирован |

## Готово к использованию! 🚀

Теперь можете использовать Terraform для управления инфраструктурой New Project с безопасным хранением state в S3.
