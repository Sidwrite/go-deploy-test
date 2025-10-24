# Terraform CI/CD Pipeline

## 🚀 **Автоматизация инфраструктуры через GitHub Actions**

Создан пайплайн для автоматического управления инфраструктурой через Terraform.

## 🔄 **Триггеры пайплайна:**

### **1. Автоматические триггеры:**
- **Push в main** → `terraform plan` + `terraform apply`
- **Pull Request** → `terraform plan` (только планирование)
- **Изменения в infrastructure/** → запуск пайплайна

### **2. Ручной запуск (workflow_dispatch):**
- **Environment:** dev, staging, prod
- **Action:** plan, apply, destroy

## 📋 **Этапы пайплайна:**

### **1. Terraform Plan (для PR и планирования)**
```yaml
- Checkout code
- Configure AWS credentials
- Setup Terraform 1.6.0
- Terraform Format Check
- Terraform Init (EKS + Infra)
- Terraform Plan (EKS + Infra)
- Upload Terraform Plans
```

### **2. Terraform Apply (для main ветки)**
```yaml
- Checkout code
- Configure AWS credentials
- Setup Terraform 1.6.0
- Download Terraform Plans
- Terraform Init (EKS + Infra)
- Terraform Apply (EKS + Infra)
- Terraform Output (EKS + Infra)
- Upload Terraform Outputs
```

### **3. Terraform Destroy (ручной запуск)**
```yaml
- Checkout code
- Configure AWS credentials
- Setup Terraform 1.6.0
- Terraform Init (EKS + Infra)
- Terraform Destroy (EKS + Infra)
```

## 🎯 **Что управляется:**

### **EKS Project:**
- **S3 Bucket:** `go-app-terraform-state-211125755493`
- **Ресурсы:** EKS кластер, VPC, ArgoCD
- **Путь:** `infrastructure/EKS/`

### **Infra Project:**
- **S3 Bucket:** `new-project-terraform-state-211125755493`
- **Ресурсы:** VPC, K3s, Database, Bastion, App Server
- **Путь:** `infrastructure/infra/`

## 🚀 **Как использовать:**

### **1. Автоматический деплой:**
```bash
# Сделать изменения в infrastructure/
git add infrastructure/
git commit -m "Update infrastructure"
git push origin main
# Пайплайн автоматически запустится
```

### **2. Ручной запуск:**
1. Перейти в **Actions** → **Terraform Infrastructure**
2. Нажать **Run workflow**
3. Выбрать:
   - **Environment:** dev/staging/prod
   - **Action:** plan/apply/destroy

### **3. Pull Request:**
```bash
# Создать PR с изменениями в infrastructure/
# Пайплайн автоматически выполнит terraform plan
```

## 📊 **Артефакты пайплайна:**

### **Terraform Plans:**
- `tfplan-eks` - план для EKS проекта
- `tfplan-infra` - план для Infra проекта

### **Terraform Outputs:**
- `eks-outputs.json` - outputs EKS проекта
- `infra-outputs.json` - outputs Infra проекта

## 🔧 **Требования:**

### **GitHub Secrets:**
```bash
AWS_ACCESS_KEY_ID      # AWS Access Key
AWS_SECRET_ACCESS_KEY  # AWS Secret Key
```

### **AWS Permissions:**
- S3 (чтение/запись state файлов)
- EKS (создание/управление кластерами)
- EC2 (создание/управление инстансами)
- VPC (создание/управление сетями)
- IAM (создание/управление ролями)

## 🎯 **Workflow:**

```
1. Изменения в infrastructure/ → GitHub Actions
2. Terraform Plan → Проверка изменений
3. Terraform Apply → Создание/обновление ресурсов
4. Terraform Output → Сохранение outputs
```

## 🔍 **Мониторинг:**

### **Проверка статуса:**
- **Actions** → **Terraform Infrastructure** → последний workflow
- **Logs** → детальные логи выполнения

### **Проверка ресурсов:**
```bash
# EKS кластер
aws eks list-clusters --region us-east-2

# S3 buckets
aws s3 ls | grep terraform-state

# EC2 инстансы
aws ec2 describe-instances --region us-east-2
```

## 🛠️ **Troubleshooting:**

### **Ошибка AWS credentials:**
```bash
# Проверить secrets в GitHub
# Settings → Secrets and variables → Actions
```

### **Ошибка Terraform:**
```bash
# Проверить логи в GitHub Actions
# Проверить state файлы в S3
```

### **Ошибка ресурсов:**
```bash
# Проверить AWS quotas
# Проверить права доступа
```

## 🎉 **Преимущества:**

1. **🔄 Автоматизация** - инфраструктура обновляется автоматически
2. **🔒 Безопасность** - state файлы в S3, credentials в secrets
3. **📊 Планирование** - terraform plan перед apply
4. **🎯 Контроль** - ручной запуск для критических операций
5. **📋 Отслеживание** - полные логи и артефакты

## 🚀 **Готово!**

Теперь ваша инфраструктура полностью автоматизирована:
- ✅ **Автоматический деплой** при изменениях
- ✅ **Безопасное хранение** state в S3
- ✅ **Планирование изменений** через PR
- ✅ **Ручное управление** через workflow_dispatch

Инфраструктура как код! 🎯
