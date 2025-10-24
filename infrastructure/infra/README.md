# New Project Infrastructure

## 🚀 **Terraform Infrastructure для New Project**

Этот проект содержит Terraform конфигурацию для создания инфраструктуры New Project с использованием отдельного S3 bucket для state.

## 📋 **Что включено:**

### **1. S3 Bucket для State**
- **Название:** `new-project-terraform-state-211125755493`
- **Регион:** us-east-2
- **Версионирование:** ✅ Включено
- **Шифрование:** ✅ AES256
- **Публичный доступ:** ❌ Заблокирован

### **2. Terraform Модули**
- **VPC** - виртуальная частная сеть
- **Security Groups** - группы безопасности
- **Database** - база данных
- **K3s** - Kubernetes кластер
- **Bastion** - bastion host
- **App Server** - сервер приложения

### **3. Автоматизация**
- **`init-terraform.sh`** - инициализация Terraform с S3 backend
- **`TERRAFORM_STATE_BUCKET.md`** - документация по S3 bucket

## 🚀 **Быстрый старт:**

### **1. Инициализация Terraform**
```bash
cd /Users/sidwrite/project/my-go-app/infrastructure/new-project
./init-terraform.sh
```

### **2. Планирование инфраструктуры**
```bash
terraform plan
```

### **3. Создание инфраструктуры**
```bash
terraform apply
```

### **4. Удаление инфраструктуры**
```bash
terraform destroy
```

## 📊 **Сравнение с Go App проектом:**

| Параметр | Go App | New Project |
|----------|---------|------------|
| **S3 Bucket** | go-app-terraform-state-211125755493 | new-project-terraform-state-211125755493 |
| **Назначение** | Go приложение + EKS | New Project инфраструктура |
| **Модули** | EKS, VPC, ArgoCD | VPC, K3s, Database, Bastion, App Server |
| **Backend** | S3 | S3 |
| **Регион** | us-east-2 | us-east-2 |

## 🔧 **Требования:**

- **Terraform** >= 1.0
- **AWS CLI** настроен с credentials
- **AWS Account** с правами на создание ресурсов

## 📋 **Структура проекта:**

```
infra/
├── backend.tf                    # S3 backend конфигурация
├── main.tf                      # Основная конфигурация
├── variables.tf                 # Переменные
├── outputs.tf                   # Outputs
├── versions.tf                  # Версии провайдеров
├── terraform.tfvars.example     # Пример переменных
├── init-terraform.sh            # Скрипт инициализации
├── TERRAFORM_STATE_BUCKET.md    # Документация по S3
└── modules/                     # Terraform модули
    ├── vpc/
    ├── security_groups/
    ├── database/
    ├── k3s/
    ├── bastion/
    └── app_server/
```

## 🎯 **Workflow:**

```
1. ./init-terraform.sh          # Инициализация
2. terraform plan              # Планирование
3. terraform apply             # Создание
4. terraform destroy           # Удаление
```

## 🔍 **Проверка состояния:**

```bash
# Проверить state в S3
aws s3 ls s3://new-project-terraform-state-211125755493/

# Проверить Terraform state
terraform state list

# Проверить outputs
terraform output
```

## 🛠️ **Troubleshooting:**

### **Ошибка инициализации:**
```bash
# Переинициализация
terraform init -reconfigure

# Принудительная инициализация
terraform init -force-copy
```

### **Ошибка доступа к S3:**
```bash
# Проверить bucket
aws s3api head-bucket --bucket new-project-terraform-state-211125755493

# Проверить права
aws s3api list-objects-v2 --bucket new-project-terraform-state-211125755493
```

## 🎉 **Готово!**

Теперь у вас есть:
- ✅ **Отдельный S3 bucket** для New Project
- ✅ **Terraform конфигурация** с модулями
- ✅ **Автоматизация** инициализации
- ✅ **Документация** по использованию

Можете создавать инфраструктуру для New Project независимо от Go App! 🚀
