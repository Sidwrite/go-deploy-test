#!/bin/bash

# Initialize Terraform with new S3 backend
# Usage: ./init-terraform.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Initializing Terraform with S3 backend${NC}"
echo "Bucket: new-project-terraform-state-211125755493"
echo "Region: us-east-2"
echo ""

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}❌ Terraform is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check AWS credentials
echo -e "${YELLOW}📋 Checking AWS credentials...${NC}"
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ AWS credentials not configured. Please run 'aws configure' first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ AWS credentials are configured${NC}"

# Check if bucket exists
echo -e "${YELLOW}📋 Checking S3 bucket...${NC}"
if ! aws s3api head-bucket --bucket new-project-terraform-state-211125755493 &> /dev/null; then
    echo -e "${RED}❌ S3 bucket 'new-project-terraform-state-211125755493' does not exist.${NC}"
    echo -e "${YELLOW}💡 Please create the bucket first:${NC}"
    echo "   aws s3 mb s3://new-project-terraform-state-211125755493 --region us-east-2"
    exit 1
fi

echo -e "${GREEN}✅ S3 bucket exists${NC}"

# Initialize Terraform
echo -e "${YELLOW}🔧 Initializing Terraform...${NC}"
terraform init

# Verify initialization
echo -e "${YELLOW}📋 Verifying Terraform initialization...${NC}"
if [ -f ".terraform/terraform.tfstate" ]; then
    echo -e "${GREEN}✅ Terraform initialized successfully${NC}"
else
    echo -e "${RED}❌ Terraform initialization failed${NC}"
    exit 1
fi

# Show current state
echo -e "${YELLOW}📋 Current Terraform state:${NC}"
terraform show

echo -e "${GREEN}🎉 Terraform is ready to use!${NC}"
echo -e "${BLUE}📋 Next steps:${NC}"
echo -e "  1. Plan: terraform plan"
echo -e "  2. Apply: terraform apply"
echo -e "  3. Destroy: terraform destroy"
echo -e "  4. State: terraform state list"
