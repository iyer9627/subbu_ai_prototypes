#!/bin/bash

echo "🚀 Deploying frontend to Vercel..."

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "❌ Vercel CLI is not installed. Installing..."
    npm install -g vercel
fi

# Navigate to frontend directory
cd frontend || exit

# Deploy to Vercel
echo "📦 Building and deploying..."
vercel --prod

echo "✅ Deployment complete!"
