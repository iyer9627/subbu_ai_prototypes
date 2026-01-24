#!/bin/bash

echo "🚀 Setting up AI Prototyping Framework..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18 or higher."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version must be 18 or higher. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js version: $(node -v)"

# Install root dependencies
echo "📦 Installing root dependencies..."
npm install

# Install workspace dependencies
echo "📦 Installing workspace dependencies..."
npm install --workspaces

# Copy environment file
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "⚠️  Please update .env with your API keys and configuration"
else
    echo "✅ .env file already exists"
fi

# Build shared packages
echo "🔨 Building shared packages..."
npm run build --workspace=shared
npm run build --workspace=ai-services

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Update .env file with your API keys"
echo "2. Start MongoDB (if using): docker-compose up mongodb -d"
echo "3. Start development servers: npm run dev"
echo ""
