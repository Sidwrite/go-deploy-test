# Terraform Destroy Pipeline

## 🗑️ **Пайплайн для удаления инфраструктуры**

Создан специальный пайплайн для безопасного удаления всей инфраструктуры с дополнительными проверками и подтверждениями.

## ⚠️ **ВАЖНО: Осторожно с удалением!**

Этот пайплайн **УДАЛЯЕТ ВСЮ ИНФРАСТРУКТУРУ** безвозвратно. Используйте только когда уверены!

## 🔄 **Триггеры пайплайна:**

### **Только ручной запуск (workflow_dispatch):**
- **Environment:** dev, staging, prod
- **Confirm Destroy:** необходимо ввести "DESTROY"
- **Destroy EKS:** включить/выключить удаление EKS
- **Destroy Infra:** включить/выключить удаление Infra

## 📋 **Этапы пайплайна:**

### **1. Pre-destroy checks**
```yaml
- Checkout code
- Configure AWS credentials
- Setup Terraform 1.6.0
- Pre-destroy checks (вывод параметров)
- List AWS resources before destroy
```

### **2. Terraform Destroy**
```yaml
- Terraform Destroy - EKS (если включено)
- Terraform Destroy - Infra (если включено)
```

### **3. Post-destroy cleanup**
```yaml
- Post-destroy cleanup
- Verify S3 state buckets
- Destroy summary
- Create destroy report
- Upload destroy report
```

## 🚀 **Как использовать:**

### **1. Запуск через GitHub UI:**
1. Перейти в **Actions** → **Terraform Destroy Infrastructure**
2. Нажать **Run workflow**
3. Заполнить параметры:
   - **Environment:** dev/staging/prod
   - **Type "DESTROY" to confirm:** ввести `DESTROY`
   - **Destroy EKS infrastructure:** ✅/❌
   - **Destroy Infra infrastructure:** ✅/❌

### **2. Что удаляется:**

#### **EKS Project (если включено):**
- ✅ EKS кластер
- ✅ VPC и подсети
- ✅ Security Groups
- ✅ IAM роли
- ✅ LoadBalancer (если есть)

#### **Infra Project (если включено):**
- ✅ VPC и подсети
- ✅ K3s кластер
- ✅ Database
- ✅ Bastion Host
- ✅ App Server
- ✅ Security Groups

## 🔍 **Проверки безопасности:**

### **1. Подтверждение:**
- Необходимо ввести `DESTROY` для подтверждения
- Можно выбрать, что именно удалять

### **2. Pre-destroy checks:**
- Список всех AWS ресурсов перед удалением
- EKS кластеры
- EC2 инстансы
- S3 buckets

### **3. Post-destroy verification:**
- Проверка, что ресурсы действительно удалены
- Предупреждения о оставшихся ресурсах

## 📊 **Артефакты пайплайна:**

### **Destroy Report:**
- **Дата и время** удаления
- **Environment** и параметры
- **Список удаленных ресурсов**
- **Следующие шаги**

## 🛠️ **Требования:**

### **GitHub Secrets:**
```bash
AWS_ACCESS_KEY_ID      # AWS Access Key
AWS_SECRET_ACCESS_KEY  # AWS Secret Key
```

### **AWS Permissions:**
- S3 (чтение/запись state файлов)
- EKS (удаление кластеров)
- EC2 (удаление инстансов)
- VPC (удаление сетей)
- IAM (удаление ролей)

## 🔍 **Мониторинг:**

### **Проверка статуса:**
- **Actions** → **Terraform Destroy Infrastructure** → последний workflow
- **Logs** → детальные логи удаления

### **Проверка ресурсов после удаления:**
```bash
# EKS кластеры
aws eks list-clusters --region us-east-2

# EC2 инстансы
aws ec2 describe-instances --region us-east-2

# S3 buckets (остаются для state файлов)
aws s3 ls | grep terraform-state
```

## 🧹 **Очистка после удаления:**

### **1. S3 Buckets (остаются):**
```bash
# Удалить state файлы (осторожно!)
aws s3 rm s3://go-app-terraform-state-211125755493/ --recursive
aws s3 rm s3://new-project-terraform-state-211125755493/ --recursive

# Удалить buckets (осторожно!)
aws s3 rb s3://go-app-terraform-state-211125755493
aws s3 rb s3://new-project-terraform-state-211125755493
```

### **2. ECR Repository (остается):**
```bash
# Удалить ECR repository (осторожно!)
aws ecr delete-repository --repository-name go-app --region us-east-2 --force
```

## ⚠️ **Troubleshooting:**

### **Ошибка "Resources still exist":**
```bash
# Проверить, какие ресурсы остались
aws eks list-clusters --region us-east-2
aws ec2 describe-instances --region us-east-2

# Удалить вручную, если необходимо
```

### **Ошибка "State file locked":**
```bash
# Проверить DynamoDB locks (если используется)
aws dynamodb list-tables --region us-east-2
```

## 🎯 **Best Practices:**

### **1. Перед удалением:**
- ✅ Создать бэкап важных данных
- ✅ Убедиться, что все данные сохранены
- ✅ Уведомить команду о планах удаления

### **2. После удаления:**
- ✅ Проверить, что все ресурсы удалены
- ✅ Очистить S3 buckets (если нужно)
- ✅ Обновить документацию
- ✅ Уведомить команду о завершении

## 🎉 **Преимущества:**

1. **🔒 Безопасность** - множественные подтверждения
2. **📊 Контроль** - выбор, что именно удалять
3. **🔍 Проверки** - до и после удаления
4. **📋 Отчеты** - детальные отчеты об удалении
5. **🧹 Очистка** - автоматическая проверка результатов

## 🚀 **Готово!**

Теперь у вас есть безопасный способ удаления инфраструктуры:
- ✅ **Множественные подтверждения** для безопасности
- ✅ **Выборочное удаление** проектов
- ✅ **Детальные проверки** до и после
- ✅ **Полные отчеты** об удалении

**Помните: удаление необратимо!** 🗑️
