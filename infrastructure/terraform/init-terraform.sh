#!/bin/bash

# Initialize Terraform for ArgoCD configuration
# This script sets up Terraform with S3 backend and installs ArgoCD

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Initializing Terraform for ArgoCD configuration${NC}"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}❌ Terraform is not installed. Please install it first.${NC}"
    exit 1
fi

# Get AWS account ID
echo -e "${YELLOW}📋 Getting AWS account ID...${NC}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
if [ -z "$AWS_ACCOUNT_ID" ]; then
    echo -e "${RED}❌ Failed to get AWS account ID. Please check your AWS credentials.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ AWS Account ID: ${AWS_ACCOUNT_ID}${NC}"

# Create S3 bucket for Terraform state if it doesn't exist
BUCKET_NAME="my-go-app-terraform-state-${AWS_ACCOUNT_ID}"
echo -e "${YELLOW}📋 Checking S3 bucket: ${BUCKET_NAME}${NC}"

if ! aws s3 ls "s3://${BUCKET_NAME}" &> /dev/null; then
    echo -e "${YELLOW}📋 Creating S3 bucket for Terraform state...${NC}"
    aws s3 mb "s3://${BUCKET_NAME}" --region us-east-2
    
    # Enable versioning
    aws s3api put-bucket-versioning --bucket "${BUCKET_NAME}" --versioning-configuration Status=Enabled
    
    # Enable encryption
    aws s3api put-bucket-encryption --bucket "${BUCKET_NAME}" --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'
    
    echo -e "${GREEN}✅ S3 bucket created: ${BUCKET_NAME}${NC}"
else
    echo -e "${GREEN}✅ S3 bucket already exists: ${BUCKET_NAME}${NC}"
fi

# Create DynamoDB table for state locking if it doesn't exist
TABLE_NAME="my-go-app-terraform-state-lock"
echo -e "${YELLOW}📋 Checking DynamoDB table: ${TABLE_NAME}${NC}"

if ! aws dynamodb describe-table --table-name "${TABLE_NAME}" &> /dev/null; then
    echo -e "${YELLOW}📋 Creating DynamoDB table for state locking...${NC}"
    aws dynamodb create-table \
        --table-name "${TABLE_NAME}" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
        --region us-east-2
    
    echo -e "${GREEN}✅ DynamoDB table created: ${TABLE_NAME}${NC}"
else
    echo -e "${GREEN}✅ DynamoDB table already exists: ${TABLE_NAME}${NC}"
fi

# Initialize Terraform
echo -e "${YELLOW}📋 Initializing Terraform...${NC}"
terraform init

# Validate configuration
echo -e "${YELLOW}📋 Validating Terraform configuration...${NC}"
terraform validate

# Format configuration
echo -e "${YELLOW}📋 Formatting Terraform configuration...${NC}"
terraform fmt -recursive

echo -e "${GREEN}✅ Terraform initialized successfully!${NC}"
echo -e "${YELLOW}📋 Next steps:${NC}"
echo -e "  1. Run: terraform plan"
echo -e "  2. Run: terraform apply"
echo -e "  3. Check ArgoCD UI after deployment"
echo -e "  4. Run: kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo -e "  5. Get admin password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
