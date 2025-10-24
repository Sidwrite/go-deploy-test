#!/bin/bash

# Build and Push Go App to ECR
# Usage: ./scripts/build-and-push.sh [tag]

set -e

# Configuration
AWS_REGION=${AWS_REGION:-"us-east-2"}
ECR_REPO_NAME="go-app"
APP_NAME="go-app"
DOCKERFILE_PATH="app/Dockerfile"
BUILD_CONTEXT="."

# Get tag from argument or use latest
TAG=${1:-"latest"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Building and pushing Go app to ECR${NC}"
echo "Repository: ${ECR_REPO_NAME}"
echo "Tag: ${TAG}"
echo "Region: ${AWS_REGION}"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install it first.${NC}"
    exit 1
fi

# Get AWS account ID
echo -e "${YELLOW}📋 Getting AWS account ID...${NC}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
if [ -z "$AWS_ACCOUNT_ID" ]; then
    echo -e "${RED}❌ Failed to get AWS account ID. Please check your AWS credentials.${NC}"
    exit 1
fi

# Construct ECR repository URL
ECR_REPOSITORY_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"

echo -e "${YELLOW}📋 ECR Repository URL: ${ECR_REPOSITORY_URL}${NC}"

# Login to ECR
echo -e "${YELLOW}🔐 Logging in to ECR...${NC}"
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY_URL}

# Check if repository exists, create if not
echo -e "${YELLOW}📋 Checking if ECR repository exists...${NC}"
if ! aws ecr describe-repositories --repository-names ${ECR_REPO_NAME} --region ${AWS_REGION} &> /dev/null; then
    echo -e "${YELLOW}📋 Creating ECR repository...${NC}"
    aws ecr create-repository --repository-name ${ECR_REPO_NAME} --region ${AWS_REGION}
else
    echo -e "${GREEN}✅ ECR repository already exists${NC}"
fi

# Build Docker image
echo -e "${YELLOW}🔨 Building Docker image...${NC}"
docker build -t ${APP_NAME}:${TAG} -f ${DOCKERFILE_PATH} ${BUILD_CONTEXT}

# Tag image for ECR
echo -e "${YELLOW}🏷️  Tagging image for ECR...${NC}"
docker tag ${APP_NAME}:${TAG} ${ECR_REPOSITORY_URL}:${TAG}

# Push image to ECR
echo -e "${YELLOW}📤 Pushing image to ECR...${NC}"
docker push ${ECR_REPOSITORY_URL}:${TAG}

echo -e "${GREEN}✅ Successfully built and pushed image to ECR!${NC}"
echo -e "${GREEN}📋 Image URL: ${ECR_REPOSITORY_URL}:${TAG}${NC}"

# Show image details
echo -e "${YELLOW}📋 Image details:${NC}"
aws ecr describe-images --repository-name ${ECR_REPO_NAME} --image-ids imageTag=${TAG} --region ${AWS_REGION} --query 'imageDetails[0].{Size:imageSizeInBytes,Pushed:imagePushedAt}' --output table

echo -e "${GREEN}🎉 Done! You can now use this image in your Kubernetes deployments.${NC}"
