# Quick Start Guide - Your First AI Prototype

This guide will walk you through setting up the framework and building your first AI prototype in under 15 minutes.

## Step 1: Initial Setup (5 minutes)

### 1.1 Install Dependencies

First, ensure you have the prerequisites:
- Node.js 18+ installed
- npm 9+ installed
- Docker installed (optional but recommended)

Check your versions:
```bash
node --version  # Should be 18.x or higher
npm --version   # Should be 9.x or higher
docker --version # Optional
```

### 1.2 Run Automated Setup

```bash
# Make setup script executable
chmod +x scripts/setup.sh

# Run the setup script (installs all dependencies)
./scripts/setup.sh
```

This will:
- Install all npm dependencies across all workspaces
- Create a `.env` file from `.env.example`
- Set up TypeScript configurations

### 1.3 Configure Environment Variables

Open the `.env` file and add your API keys:

```bash
nano .env
```

**Minimum required configuration:**
```env
# AI Services - Add at least one
ANTHROPIC_API_KEY=sk-ant-xxxxx    # Get from: https://console.anthropic.com
# OR
OPENAI_API_KEY=sk-xxxxx           # Get from: https://platform.openai.com

# Database (MongoDB via Docker - these defaults work)
DATABASE_TYPE=mongodb
MONGODB_URI=mongodb://admin:password@localhost:27017/ai_prototypes?authSource=admin

# Backend
BACKEND_PORT=3001
NODE_ENV=development
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:3001
CORS_ORIGIN=http://localhost:3000
```

**Don't have API keys yet?**
- **Anthropic Claude**: Sign up at https://console.anthropic.com
- **OpenAI GPT**: Sign up at https://platform.openai.com

## Step 2: Start Development Environment (2 minutes)

### Option A: Using Docker (Recommended)

Start everything with one command:
```bash
docker-compose up
```

This starts:
- MongoDB database on port 27017
- Backend API on port 3001
- Frontend app on port 3000

### Option B: Manual Start

If you prefer not to use Docker:

**Terminal 1 - Start MongoDB:**
```bash
docker-compose up mongodb -d
```

**Terminal 2 - Start Backend:**
```bash
npm run dev:backend
```

**Terminal 3 - Start Frontend:**
```bash
npm run dev:frontend
```

### Verify Everything Works

Open your browser and check:
- **Frontend**: http://localhost:3000 (should see the AI chat interface)
- **Backend Health**: http://localhost:3001/api/health (should return `{"status":"ok"}`)

## Step 3: Create Your First Prototype (8 minutes)

Now let's build something! Here are 3 starter prototype ideas:

### Prototype Idea #1: AI Code Reviewer

Create a simple AI-powered code review tool.

**Backend Route** (`backend/src/routes/prototypes/code-reviewer.routes.ts`):
```typescript
import { Router } from 'express';
import { AIService } from '@ai-proto/ai-services';
import { AIProvider, AIModel } from '@ai-proto/shared';

const router = Router();
const aiService = new AIService({
  defaultProvider: AIProvider.ANTHROPIC,
  apiKeys: {
    anthropic: process.env.ANTHROPIC_API_KEY!,
  }
});

router.post('/review', async (req, res) => {
  try {
    const { code, language } = req.body;

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `Review this ${language} code and provide feedback on:
1. Code quality and best practices
2. Potential bugs or issues
3. Performance improvements
4. Security concerns

Code:
\`\`\`${language}
${code}
\`\`\`

Provide your review in a structured format.`
      }],
      temperature: 0.3,
      maxTokens: 2000
    });

    res.json({
      success: true,
      review: response.content
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to review code'
    });
  }
});

export default router;
```

### Prototype Idea #2: AI Document Summarizer

**Backend Route** (`backend/src/routes/prototypes/summarizer.routes.ts`):
```typescript
import { Router } from 'express';
import { AIService } from '@ai-proto/ai-services';
import { AIProvider, AIModel } from '@ai-proto/shared';

const router = Router();
const aiService = new AIService({
  defaultProvider: AIProvider.ANTHROPIC,
  apiKeys: {
    anthropic: process.env.ANTHROPIC_API_KEY!,
  }
});

router.post('/summarize', async (req, res) => {
  try {
    const { text, length = 'medium' } = req.body;

    const lengthInstructions = {
      short: '2-3 sentences',
      medium: '1 paragraph (4-6 sentences)',
      long: '2-3 paragraphs'
    };

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `Summarize the following text in ${lengthInstructions[length]}:

${text}

Provide a clear, concise summary that captures the main points.`
      }],
      temperature: 0.5,
      maxTokens: 1000
    });

    res.json({
      success: true,
      summary: response.content,
      originalLength: text.length,
      summaryLength: response.content.length
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to summarize text'
    });
  }
});

export default router;
```

### Prototype Idea #3: AI Interview Practice Bot

**Backend Route** (`backend/src/routes/prototypes/interview-practice.routes.ts`):
```typescript
import { Router } from 'express';
import { AIService } from '@ai-proto/ai-services';
import { AIProvider, AIModel } from '@ai-proto/shared';

const router = Router();
const aiService = new AIService({
  defaultProvider: AIProvider.ANTHROPIC,
  apiKeys: {
    anthropic: process.env.ANTHROPIC_API_KEY!,
  }
});

router.post('/start', async (req, res) => {
  try {
    const { jobRole, difficulty = 'medium' } = req.body;

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `You are an expert interviewer conducting a ${difficulty} difficulty interview for a ${jobRole} position.

Generate 5 relevant interview questions that would be appropriate for this role. For each question, also provide:
1. What you're looking for in the answer
2. Key points a good candidate should mention

Format your response clearly with numbered questions.`
      }],
      temperature: 0.7,
      maxTokens: 2000
    });

    res.json({
      success: true,
      questions: response.content,
      jobRole,
      difficulty
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to generate interview questions'
    });
  }
});

router.post('/evaluate', async (req, res) => {
  try {
    const { question, answer } = req.body;

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `As an expert interviewer, evaluate this candidate's answer:

Question: ${question}

Candidate's Answer: ${answer}

Provide:
1. Score (1-10)
2. Strengths in the answer
3. Areas for improvement
4. Suggestions for a better response`
      }],
      temperature: 0.5,
      maxTokens: 1500
    });

    res.json({
      success: true,
      evaluation: response.content
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to evaluate answer'
    });
  }
});

export default router;
```

## Step 4: Add Your Prototype Route

### 4.1 Create Your Route File

Choose one of the prototypes above (or create your own) and create the file:

```bash
# Create the prototypes directory
mkdir -p backend/src/routes/prototypes

# Create your prototype file (example: code reviewer)
touch backend/src/routes/prototypes/code-reviewer.routes.ts
```

### 4.2 Register Your Route

Edit `backend/src/routes/index.ts` and add your prototype route:

```typescript
import { Router } from 'express';
import authRoutes from './auth.routes';
import aiRoutes from './ai.routes';
import codeReviewerRoutes from './prototypes/code-reviewer.routes'; // Add this

const router = Router();

// Health check
router.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Existing routes
router.use('/auth', authRoutes);
router.use('/ai', aiRoutes);

// Your prototype routes
router.use('/prototypes/code-reviewer', codeReviewerRoutes); // Add this

export default router;
```

### 4.3 Test Your Prototype

Restart the backend (if not using hot reload), then test with curl or Postman:

**Code Reviewer Example:**
```bash
curl -X POST http://localhost:3001/api/prototypes/code-reviewer/review \
  -H "Content-Type: application/json" \
  -d '{
    "code": "function add(a, b) { return a + b; }",
    "language": "javascript"
  }'
```

**Summarizer Example:**
```bash
curl -X POST http://localhost:3001/api/prototypes/summarizer/summarize \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Your long text here...",
    "length": "medium"
  }'
```

**Interview Practice Example:**
```bash
curl -X POST http://localhost:3001/api/prototypes/interview-practice/start \
  -H "Content-Type: application/json" \
  -d '{
    "jobRole": "Senior Software Engineer",
    "difficulty": "hard"
  }'
```

## Step 5: Create a Frontend Component (Optional)

### 5.1 Create a Prototype Page

Create `frontend/src/app/prototype/page.tsx`:

```typescript
'use client';

import { useState } from 'react';
import axios from 'axios';

export default function PrototypePage() {
  const [code, setCode] = useState('');
  const [language, setLanguage] = useState('javascript');
  const [review, setReview] = useState('');
  const [loading, setLoading] = useState(false);

  const handleReview = async () => {
    setLoading(true);
    try {
      const response = await axios.post(
        'http://localhost:3001/api/prototypes/code-reviewer/review',
        { code, language }
      );
      setReview(response.data.review);
    } catch (error) {
      console.error('Error:', error);
      alert('Failed to review code');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 p-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-8">
          AI Code Reviewer
        </h1>

        <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6 space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Language
            </label>
            <select
              value={language}
              onChange={(e) => setLanguage(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            >
              <option value="javascript">JavaScript</option>
              <option value="python">Python</option>
              <option value="typescript">TypeScript</option>
              <option value="java">Java</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Code to Review
            </label>
            <textarea
              value={code}
              onChange={(e) => setCode(e.target.value)}
              rows={10}
              className="w-full px-3 py-2 border border-gray-300 rounded-md font-mono dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              placeholder="Paste your code here..."
            />
          </div>

          <button
            onClick={handleReview}
            disabled={loading || !code}
            className="w-full px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed"
          >
            {loading ? 'Reviewing...' : 'Review Code'}
          </button>

          {review && (
            <div className="mt-6">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-4">
                Review Results
              </h2>
              <div className="bg-gray-50 dark:bg-gray-900 p-4 rounded-md">
                <pre className="whitespace-pre-wrap text-sm text-gray-800 dark:text-gray-200">
                  {review}
                </pre>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
```

### 5.2 Access Your Prototype

Visit http://localhost:3000/prototype to see your UI!

## Common Issues & Solutions

### Issue: "Module not found" errors

**Solution:**
```bash
# Reinstall dependencies
npm run clean
npm install
```

### Issue: Backend won't start - "Cannot connect to MongoDB"

**Solution:**
```bash
# Check if MongoDB container is running
docker ps

# If not, start it
docker-compose up mongodb -d

# Check the logs
docker-compose logs mongodb
```

### Issue: API returns "Invalid API key"

**Solution:**
- Double-check your `.env` file has the correct API key
- Ensure there are no extra spaces around the key
- Restart the backend after updating `.env`

### Issue: CORS errors in frontend

**Solution:**
Make sure `CORS_ORIGIN=http://localhost:3000` is set in `.env`

## Next Steps

Now that you have your first prototype running, here are some ideas:

### 1. Enhance Your Prototype
- Add error handling
- Implement rate limiting for specific prototypes
- Add input validation
- Store results in the database

### 2. Try Advanced Features
- Implement streaming responses for better UX
- Add conversation history
- Create custom prompt templates
- Try different AI models (Claude Opus vs Sonnet vs Haiku)

### 3. Deploy Your Prototype
```bash
# Deploy frontend to Vercel
./scripts/deploy-vercel.sh

# Deploy backend to Heroku
heroku create my-ai-prototype
git push heroku main
```

### 4. Build More Prototypes

Some ideas to inspire you:
- **Content Generator**: Blog posts, marketing copy, social media
- **Language Tutor**: Practice conversations, grammar checking
- **Data Analyzer**: Upload CSV, get insights and visualizations
- **Creative Writing Assistant**: Story ideas, character development
- **Meeting Summarizer**: Upload transcripts, get action items
- **SQL Query Generator**: Natural language to SQL
- **Regex Helper**: Generate and explain regex patterns
- **API Documentation Generator**: From code to docs

## Helpful Commands

```bash
# View all logs
docker-compose logs -f

# Restart just the backend
docker-compose restart backend

# Stop everything
docker-compose down

# Rebuild after changes
docker-compose up --build

# Check what's running
docker-compose ps

# Access MongoDB shell
docker exec -it ai-proto-mongodb mongosh -u admin -p password

# Run tests (when you add them)
npm run test

# Build for production
npm run build
```

## Getting Help

- Check the main [README.md](./README.md) for detailed documentation
- Look at [CONTRIBUTING.md](./CONTRIBUTING.md) for development guidelines
- Review example code in `backend/src/routes/ai.routes.ts`
- Check the AI service implementation in `ai-services/src/ai-service.ts`

## Pro Tips

1. **Start Simple**: Get one endpoint working before adding complexity
2. **Use Prompt Engineering**: The quality of your AI responses depends heavily on your prompts
3. **Test with Different Models**: Claude Sonnet is fast and cheap, Opus is powerful but pricier
4. **Log Everything**: Add console.log statements to debug issues
5. **Version Control**: Commit often with descriptive messages
6. **API Keys**: Never commit API keys - keep them in `.env` only

---

Happy prototyping! 🚀
