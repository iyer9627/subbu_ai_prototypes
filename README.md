# AI Prototyping Framework

A comprehensive, production-ready framework for rapidly prototyping and building AI-powered products. This framework provides a complete ecosystem with frontend, backend, AI services integration, and deployment configurations.

## 🚀 Quick Start

**New to the framework?** Check out the [QUICKSTART.md](./QUICKSTART.md) guide to:
- Set up your environment in 5 minutes
- Build your first AI prototype in under 15 minutes
- Test 3 ready-to-use AI prototypes (Code Reviewer, Summarizer, Interview Practice)

**Or jump right in:**
```bash
# 1. Setup
./scripts/setup.sh

# 2. Configure your .env file with API keys

# 3. Start everything
docker-compose up

# 4. Test prototypes
chmod +x scripts/test-prototypes.sh
./scripts/test-prototypes.sh
```

## Architecture

This framework follows a modular architecture based on best practices for AI product development:

```
┌─────────────────────────────────────────────────────────────────┐
│                    AI Prototyping Ecosystem                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Frontend (Next.js + TypeScript)                                │
│  ├─ React Components                                            │
│  ├─ State Management (Zustand)                                  │
│  └─ Deployment: Vercel/Heroku                                   │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Backend (Node.js + Express + TypeScript)                       │
│  ├─ REST API Endpoints                                          │
│  ├─ Authentication & Authorization                              │
│  ├─ Database: MongoDB or Supabase                               │
│  └─ Deployment: Heroku/AWS                                      │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  AI Services Layer                                              │
│  ├─ Provider Abstraction (Anthropic, OpenAI)                    │
│  ├─ Context Engineering & Prompt Templates                      │
│  └─ Compute: AWS Lambda/EC2                                     │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Shared Types & Utilities                                       │
│  ├─ TypeScript Types                                            │
│  ├─ Validation Schemas (Zod)                                    │
│  └─ Common Utilities                                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Features

### Core Features
- ✅ **Multiple AI Providers**: Support for Anthropic (Claude) and OpenAI (GPT)
- ✅ **Dual Database Support**: MongoDB and Supabase
- ✅ **Type Safety**: Full TypeScript support across the stack
- ✅ **Modern Frontend**: Next.js 14 with React 18 and Tailwind CSS
- ✅ **RESTful API**: Express-based backend with authentication
- ✅ **Real-time Streaming**: Support for streaming AI responses
- ✅ **Context Engineering**: Built-in prompt template system

### Developer Experience
- 🔧 **Monorepo Structure**: Organized workspace with npm workspaces
- 🐳 **Docker Support**: Complete Docker and Docker Compose setup
- 🚀 **One-Command Setup**: Automated setup script
- 📝 **Comprehensive Types**: Shared types across frontend and backend
- 🔒 **Security**: JWT authentication, rate limiting, CORS, Helmet
- 📊 **Observability**: AWS CloudWatch integration ready

### Deployment Options
- ☁️ **Vercel**: Frontend deployment
- 🌐 **Heroku**: Backend deployment
- ⚡ **AWS Lambda**: Serverless compute option
- 🐳 **Docker**: Containerized deployment

## Quick Start

### Prerequisites

- Node.js 18 or higher
- npm 9 or higher
- Docker (optional, for local database)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd subbu_ai_prototypes
```

2. **Run the setup script**
```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

3. **Configure environment variables**
```bash
# Edit .env file with your API keys and configuration
nano .env
```

Required environment variables:
- `ANTHROPIC_API_KEY`: Your Anthropic API key
- `OPENAI_API_KEY`: Your OpenAI API key (optional)
- `MONGODB_URI`: MongoDB connection string
- `JWT_SECRET`: Secret for JWT authentication

4. **Start the development environment**

Option A - Using Docker:
```bash
docker-compose up
```

Option B - Manual start:
```bash
# Terminal 1 - Start MongoDB
docker-compose up mongodb

# Terminal 2 - Start backend
npm run dev:backend

# Terminal 3 - Start frontend
npm run dev:frontend
```

5. **Access the application**
- Frontend: http://localhost:3000
- Backend API: http://localhost:3001
- API Health: http://localhost:3001/api/health

## Project Structure

```
.
├── frontend/                 # Next.js frontend application
│   ├── src/
│   │   ├── app/             # Next.js app directory
│   │   ├── components/      # React components
│   │   ├── store/           # State management (Zustand)
│   │   └── lib/             # Utilities and API client
│   └── package.json
│
├── backend/                  # Express backend service
│   ├── src/
│   │   ├── config/          # Configuration
│   │   ├── database/        # Database clients and models
│   │   ├── middleware/      # Express middleware
│   │   ├── routes/          # API routes
│   │   └── index.ts         # Entry point
│   └── package.json
│
├── ai-services/              # AI integration layer
│   ├── src/
│   │   ├── providers/       # AI provider implementations
│   │   ├── context-engineering/  # Prompt templates
│   │   └── ai-service.ts    # Main AI service
│   └── package.json
│
├── shared/                   # Shared types and utilities
│   ├── src/
│   │   ├── types/           # TypeScript types
│   │   └── utils/           # Common utilities
│   └── package.json
│
├── infra/                    # Infrastructure configurations
│   ├── aws/                 # AWS Lambda & SAM templates
│   ├── vercel/              # Vercel deployment config
│   ├── heroku/              # Heroku deployment config
│   └── cloudwatch/          # CloudWatch configuration
│
└── scripts/                  # Utility scripts
    ├── setup.sh             # Initial setup
    ├── deploy-vercel.sh     # Deploy to Vercel
    └── deploy-aws.sh        # Deploy to AWS
```

## Usage Examples

### Using the AI Service

```typescript
import { AIService } from '@ai-proto/ai-services';
import { AIProvider, AIModel } from '@ai-proto/shared';

const aiService = new AIService({
  defaultProvider: AIProvider.ANTHROPIC,
  apiKeys: {
    anthropic: process.env.ANTHROPIC_API_KEY,
    openai: process.env.OPENAI_API_KEY
  }
});

// Send a chat request
const response = await aiService.sendRequest({
  provider: AIProvider.ANTHROPIC,
  model: AIModel.CLAUDE_SONNET,
  messages: [
    { role: 'user', content: 'Hello, how are you?' }
  ],
  temperature: 0.7,
  maxTokens: 1000
});

console.log(response.content);
```

### Using Prompt Templates

```typescript
import { PromptTemplateEngine, defaultTemplates } from '@ai-proto/ai-services';

const engine = new PromptTemplateEngine();

// Register default templates
defaultTemplates.forEach(template => engine.registerTemplate(template));

// Use a template
const prompt = engine.render('code-review', {
  code: 'function add(a, b) { return a + b; }',
  language: 'javascript'
});
```

### Making API Calls from Frontend

```typescript
import { apiClient } from '@/lib/api-client';
import { AIProvider, AIModel } from '@ai-proto/shared';

// Send a chat request
const response = await apiClient.sendChatRequest({
  provider: AIProvider.ANTHROPIC,
  model: AIModel.CLAUDE_SONNET,
  messages: [
    { role: 'user', content: 'Explain quantum computing' }
  ]
});

if (response.success) {
  console.log(response.data.content);
}
```

## Database Options

### MongoDB

Using MongoDB with Mongoose:

```typescript
// Configured in backend/src/database/mongodb-client.ts
// Connection is automatic based on DATABASE_TYPE=mongodb
```

MongoDB models are defined in `backend/src/database/models/`:
- `user.model.ts`: User authentication and profiles
- `conversation.model.ts`: Chat conversations and messages

### Supabase

Using Supabase:

```typescript
// Set DATABASE_TYPE=supabase in .env
// Configure SUPABASE_URL and SUPABASE_SERVICE_KEY
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user

### AI Operations
- `POST /api/ai/chat` - Send a chat message (returns complete response)
- `POST /api/ai/chat/stream` - Send a chat message (returns streaming response)

### Health Check
- `GET /api/health` - Check API health status

## Deployment

### Deploy Frontend to Vercel

```bash
chmod +x scripts/deploy-vercel.sh
./scripts/deploy-vercel.sh
```

Or manually:
```bash
cd frontend
vercel --prod
```

### Deploy Backend to Heroku

```bash
# Install Heroku CLI first
heroku login
heroku create your-app-name
git push heroku main
```

### Deploy to AWS Lambda

```bash
chmod +x scripts/deploy-aws.sh
./scripts/deploy-aws.sh
```

Or manually:
```bash
cd infra/aws
sam build
sam deploy --guided
```

## Environment Variables

Create a `.env` file in the root directory:

```env
# AI Services
ANTHROPIC_API_KEY=your_anthropic_key
OPENAI_API_KEY=your_openai_key
AI_PROVIDER=anthropic

# Database
DATABASE_TYPE=mongodb
MONGODB_URI=mongodb://localhost:27017/ai_prototypes
# OR for Supabase:
# SUPABASE_URL=your_supabase_url
# SUPABASE_ANON_KEY=your_anon_key
# SUPABASE_SERVICE_KEY=your_service_key

# Backend
BACKEND_PORT=3001
NODE_ENV=development
JWT_SECRET=your_jwt_secret
CORS_ORIGIN=http://localhost:3000

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:3001
NEXT_PUBLIC_APP_NAME=AI Prototyping Platform
```

## Development Scripts

```bash
# Install all dependencies
npm install

# Start all services in development mode
npm run dev

# Start individual services
npm run dev:frontend
npm run dev:backend
npm run dev:ai

# Build all packages
npm run build

# Build individual packages
npm run build:frontend
npm run build:backend

# Run tests
npm run test

# Clean build artifacts
npm run clean
```

## Docker Commands

```bash
# Start all services
docker-compose up

# Start in detached mode
docker-compose up -d

# Start only MongoDB
docker-compose up mongodb -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild containers
docker-compose up --build
```

## Security Features

- **JWT Authentication**: Secure token-based authentication
- **Rate Limiting**: Configurable rate limits on API endpoints
- **CORS**: Cross-Origin Resource Sharing configuration
- **Helmet**: Security headers middleware
- **Password Hashing**: bcrypt for password security
- **Input Validation**: Zod schemas for request validation

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

## Tech Stack

### Frontend
- **Framework**: Next.js 14
- **UI Library**: React 18
- **Styling**: Tailwind CSS
- **State Management**: Zustand
- **HTTP Client**: Axios
- **Markdown**: react-markdown
- **Code Highlighting**: react-syntax-highlighter

### Backend
- **Runtime**: Node.js 18+
- **Framework**: Express
- **Language**: TypeScript
- **Database**: MongoDB (Mongoose) or Supabase
- **Authentication**: JWT, bcrypt
- **Validation**: Zod

### AI Services
- **Anthropic**: Claude models (Opus, Sonnet, Haiku)
- **OpenAI**: GPT models (GPT-4, GPT-3.5)
- **SDKs**: @anthropic-ai/sdk, openai

### DevOps
- **Containerization**: Docker, Docker Compose
- **Frontend Hosting**: Vercel
- **Backend Hosting**: Heroku, AWS
- **Serverless**: AWS Lambda
- **Observability**: AWS CloudWatch

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Support

For issues, questions, or contributions, please open an issue on GitHub.

---

Built with ❤️ for rapid AI prototyping