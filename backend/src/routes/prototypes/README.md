# AI Prototypes

This directory contains ready-to-use AI prototypes that you can test immediately or use as templates for your own prototypes.

## Available Prototypes

### 1. Code Reviewer (`code-reviewer.routes.ts`)

AI-powered code review and explanation tool.

**Endpoints:**

#### POST `/api/prototypes/code-reviewer/review`
Reviews code and provides comprehensive feedback.

**Request:**
```json
{
  "code": "function add(a, b) { return a + b; }",
  "language": "javascript"
}
```

**Response:**
```json
{
  "success": true,
  "review": "Review feedback here...",
  "metadata": {
    "language": "javascript",
    "codeLength": 35,
    "reviewLength": 500,
    "model": "claude-sonnet-4",
    "timestamp": "2024-01-24T12:00:00.000Z"
  }
}
```

#### POST `/api/prototypes/code-reviewer/explain`
Explains what code does in plain English.

**Request:**
```json
{
  "code": "const result = arr.map(x => x * 2).filter(x => x > 10);",
  "language": "javascript",
  "audience": "beginner"
}
```

**audience options:** `beginner`, `intermediate`, `expert`

---

### 2. Text Summarizer (`summarizer.routes.ts`)

Summarizes documents and extracts key points.

**Endpoints:**

#### POST `/api/prototypes/summarizer/summarize`
Summarizes text to specified length.

**Request:**
```json
{
  "text": "Your long text here...",
  "length": "medium",
  "style": "professional"
}
```

**length options:** `short` (2-3 sentences), `medium` (1 paragraph), `long` (2-3 paragraphs), `bullet` (bullet points)

**style options:** `professional`, `casual`, `technical`, `simple`

**Response:**
```json
{
  "success": true,
  "summary": "Summary text here...",
  "metadata": {
    "originalLength": 1500,
    "summaryLength": 250,
    "compressionRatio": "16.67%",
    "length": "medium",
    "style": "professional",
    "timestamp": "2024-01-24T12:00:00.000Z"
  }
}
```

#### POST `/api/prototypes/summarizer/extract-key-points`
Extracts key points from text.

**Request:**
```json
{
  "text": "Your text here...",
  "numberOfPoints": 5
}
```

---

### 3. Interview Practice (`interview-practice.routes.ts`)

AI-powered interview preparation tool.

**Endpoints:**

#### POST `/api/prototypes/interview-practice/generate-questions`
Generates interview questions for a role.

**Request:**
```json
{
  "jobRole": "Senior Software Engineer",
  "difficulty": "hard",
  "numberOfQuestions": 5,
  "focusAreas": ["system design", "algorithms"]
}
```

**difficulty options:** `easy`, `medium`, `hard`, `expert`

**Response:**
```json
{
  "success": true,
  "questions": "Generated questions with evaluation criteria...",
  "metadata": {
    "jobRole": "Senior Software Engineer",
    "difficulty": "hard",
    "numberOfQuestions": 5,
    "focusAreas": ["system design", "algorithms"],
    "timestamp": "2024-01-24T12:00:00.000Z"
  }
}
```

#### POST `/api/prototypes/interview-practice/evaluate-answer`
Evaluates a candidate's answer.

**Request:**
```json
{
  "question": "Explain the difference between SQL and NoSQL databases",
  "answer": "SQL databases are relational...",
  "jobRole": "Backend Engineer"
}
```

**Response:**
```json
{
  "success": true,
  "evaluation": "Detailed evaluation with score, strengths, weaknesses...",
  "metadata": {
    "jobRole": "Backend Engineer",
    "timestamp": "2024-01-24T12:00:00.000Z"
  }
}
```

#### POST `/api/prototypes/interview-practice/mock-interview`
Conducts a conversational mock interview.

**Request:**
```json
{
  "jobRole": "Software Engineer",
  "interviewType": "technical",
  "conversationHistory": [
    {
      "role": "assistant",
      "content": "Hello! Let's start with a question about algorithms..."
    },
    {
      "role": "user",
      "content": "I would use a binary search approach..."
    }
  ]
}
```

**interviewType options:** `technical`, `behavioral`, `system_design`, `cultural`

---

## Testing the Prototypes

### Using cURL

**Code Review Example:**
```bash
curl -X POST http://localhost:3001/api/prototypes/code-reviewer/review \
  -H "Content-Type: application/json" \
  -d '{
    "code": "function fibonacci(n) { if (n <= 1) return n; return fibonacci(n-1) + fibonacci(n-2); }",
    "language": "javascript"
  }'
```

**Summarizer Example:**
```bash
curl -X POST http://localhost:3001/api/prototypes/summarizer/summarize \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Artificial intelligence is transforming industries...",
    "length": "short",
    "style": "simple"
  }'
```

**Interview Practice Example:**
```bash
curl -X POST http://localhost:3001/api/prototypes/interview-practice/generate-questions \
  -H "Content-Type: application/json" \
  -d '{
    "jobRole": "Frontend Developer",
    "difficulty": "medium",
    "numberOfQuestions": 3
  }'
```

### Using Postman

1. Import the collection (if available) or create new requests
2. Set the base URL to `http://localhost:3001`
3. Use the endpoints above with JSON body

### Using Frontend

Create a simple React component to call these endpoints (see QUICKSTART.md for examples).

---

## Creating Your Own Prototype

Use these prototypes as templates. Here's the basic structure:

```typescript
import { Router, Request, Response } from 'express';
import { AIService } from '@ai-proto/ai-services';
import { AIProvider, AIModel } from '@ai-proto/shared';
import { Logger } from '@ai-proto/shared';

const router = Router();
const logger = new Logger('YourPrototypeName');

const aiService = new AIService({
  defaultProvider: AIProvider.ANTHROPIC,
  apiKeys: {
    anthropic: process.env.ANTHROPIC_API_KEY!,
    openai: process.env.OPENAI_API_KEY
  }
});

router.post('/your-endpoint', async (req: Request, res: Response) => {
  try {
    const { inputData } = req.body;

    // Input validation
    if (!inputData) {
      return res.status(400).json({
        success: false,
        error: 'Input data is required'
      });
    }

    logger.info('Processing request', { inputData });

    // Call AI service
    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `Your prompt here: ${inputData}`
      }],
      temperature: 0.7,
      maxTokens: 1000
    });

    logger.info('Request processed successfully');

    res.json({
      success: true,
      result: response.content,
      metadata: {
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Failed to process request', error as Error);
    res.status(500).json({
      success: false,
      error: 'Failed to process request'
    });
  }
});

export default router;
```

Then register your route in `backend/src/routes/index.ts`:

```typescript
import yourPrototypeRoutes from './prototypes/your-prototype.routes';
router.use('/prototypes/your-prototype', yourPrototypeRoutes);
```

---

## Best Practices

1. **Validation**: Always validate input data
2. **Logging**: Use the Logger utility for debugging
3. **Error Handling**: Always wrap in try-catch
4. **Metadata**: Return useful metadata with responses
5. **Temperature**:
   - Use 0.1-0.3 for factual/deterministic tasks
   - Use 0.5-0.7 for balanced creativity
   - Use 0.8-1.0 for creative writing
6. **Max Tokens**: Set appropriately based on expected response length
7. **Models**:
   - Claude Haiku: Fast and cheap for simple tasks
   - Claude Sonnet: Balanced performance and cost
   - Claude Opus: Most capable for complex tasks

---

## Next Steps

1. Test the existing prototypes
2. Modify them to fit your needs
3. Create new prototypes based on these templates
4. Add frontend components to interact with your prototypes
5. Deploy your favorites to production

Happy prototyping! 🚀
