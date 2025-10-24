# Infrastructure Projects

## 🏗️ **Инфраструктурные проекты**

В этой папке находятся Terraform конфигурации для различных проектов.

## 📁 **Структура:**

```
infrastructure/
├── EKS/                    # Go App + EKS инфраструктура
│   ├── backend.tf         # S3 backend: go-app-terraform-state-211125755493
│   ├── main.tf            # EKS кластер + ArgoCD
│   └── modules/eks/       # EKS модуль
└── new-project/           # New Project инфраструктура
    ├── backend.tf         # S3 backend: new-project-terraform-state-211125755493
    ├── main.tf            # VPC + K3s + Database + Bastion
    └── modules/           # Terraform модули
        ├── vpc/
        ├── security_groups/
        ├── database/
        ├── k3s/
        ├── bastion/
        └── app_server/
```

## 🎯 **Проекты:**

### **1. EKS Project (Go App)**
- **S3 Bucket:** `go-app-terraform-state-211125755493`
- **Назначение:** Go приложение + EKS кластер + ArgoCD
- **Модули:** EKS, VPC, ArgoCD
- **Путь:** `infrastructure/EKS/`

### **2. New Project**
- **S3 Bucket:** `new-project-terraform-state-211125755493`
- **Назначение:** VPC + K3s + Database + Bastion + App Server
- **Модули:** VPC, Security Groups, Database, K3s, Bastion, App Server
- **Путь:** `infrastructure/new-project/`

## 🚀 **Быстрый старт:**

### **EKS Project:**
```bash
cd infrastructure/EKS
terraform init
terraform plan
terraform apply
```

### **New Project:**
```bash
cd infrastructure/new-project
./init-terraform.sh
terraform plan
terraform apply
```

## 📊 **Сравнение проектов:**

| Параметр | EKS Project | New Project |
|----------|-------------|-------------|
| **S3 Bucket** | go-app-terraform-state-211125755493 | new-project-terraform-state-211125755493 |
| **Основная цель** | Go App + EKS + ArgoCD | VPC + K3s + Database |
| **Модули** | EKS, VPC | VPC, Security Groups, Database, K3s, Bastion, App Server |
| **Kubernetes** | EKS (управляемый) | K3s (самоуправляемый) |
| **CI/CD** | GitHub Actions + ECR | Локальная разработка |

## 🔧 **Требования:**

- **Terraform** >= 1.0
- **AWS CLI** настроен с credentials
- **AWS Account** с правами на создание ресурсов

## 📋 **Workflow:**

```
1. Выбрать проект (EKS или new-project)
2. Перейти в папку проекта
3. Инициализировать Terraform
4. Планировать изменения
5. Применить изменения
```

## 🎉 **Готово!**

Теперь у вас есть:
- ✅ **Два независимых проекта** с отдельными S3 buckets
- ✅ **EKS проект** для Go App
- ✅ **New Project** для другой инфраструктуры
- ✅ **Полная документация** по каждому проекту

Можете работать с любым проектом независимо! 🚀
