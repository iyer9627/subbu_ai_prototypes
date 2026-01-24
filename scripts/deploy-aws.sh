#!/bin/bash

echo "🚀 Deploying to AWS Lambda..."

# Check if AWS SAM CLI is installed
if ! command -v sam &> /dev/null; then
    echo "❌ AWS SAM CLI is not installed. Please install it first."
    echo "Visit: https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html"
    exit 1
fi

# Navigate to infra directory
cd infra/aws || exit

# Build and package
echo "📦 Building Lambda function..."
sam build

# Deploy
echo "🚢 Deploying to AWS..."
sam deploy --guided

echo "✅ Deployment complete!"
