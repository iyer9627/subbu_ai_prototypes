# Using Cursor IDE with AI Prototyping Framework

## Why Cursor is Perfect for This Framework

Cursor's AI features are excellent for rapid AI prototyping:
- AI-powered code completion
- Chat with AI about your code
- Quick refactoring and bug fixes
- Understanding complex code patterns

## Setup with Cursor

### 1. Open Project in Cursor

```bash
cd subbu_ai_prototypes
cursor .
```

### 2. Install Recommended Extensions

Open Command Palette (`Cmd+Shift+P` / `Ctrl+Shift+P`):
- ESLint
- Prettier
- Docker
- GitLens

### 3. Use Cursor's AI Features

#### Ask Cursor About the Codebase
Press `Cmd+L` (Mac) or `Ctrl+L` (Windows) to open chat:

**Example prompts:**
- "Explain how the AI service abstraction works"
- "How do I add a new prototype?"
- "What does the code reviewer route do?"
- "Help me understand the MongoDB integration"

#### Generate Code with AI
Select code → Right-click → "Edit with AI":
- "Add error handling to this function"
- "Convert this to TypeScript"
- "Add input validation"
- "Write unit tests for this"

### 4. Development Workflow

#### Terminal in Cursor (Cmd+` or Ctrl+`)

```bash
# Install dependencies
npm install

# Start development servers
docker-compose up

# In separate terminal tabs:
npm run dev:backend
npm run dev:frontend

# Test prototypes
./scripts/test-prototypes.sh
```

### 5. Using Cursor AI for Prototyping

#### Create a New Prototype with AI Help

1. Open Cursor Chat (`Cmd+L`)
2. Ask: "Create a new AI prototype for sentiment analysis using the existing code reviewer as a template"
3. Cursor will generate the code
4. Copy to `backend/src/routes/prototypes/sentiment-analysis.routes.ts`
5. Register in `backend/src/routes/index.ts`

#### Quick Debugging

Select error code → Ask Cursor:
- "Why is this failing?"
- "Fix this TypeScript error"
- "Add proper error handling"

### 6. AI-Powered Features to Use

#### Code Completion
Just start typing - Cursor suggests complete functions:
```typescript
// Type: "router.post('/analyze'"
// Cursor suggests the full route handler
```

#### Inline Chat
Press `Cmd+K` with code selected:
- "Make this more efficient"
- "Add JSDoc comments"
- "Extract this into a utility function"

#### Multi-file Editing
Cursor can edit multiple files at once:
- "Update all prototype routes to use the new error handler"
- "Add TypeScript types across the project"

## Cursor + Deployment Workflow

### Development (Use Cursor)
```bash
# 1. Write code in Cursor
# 2. Test locally
npm run dev

# 3. Commit changes
git add .
git commit -m "Add new prototype"
git push
```

### Deployment (Use Free Platforms)

#### Deploy Frontend to Vercel (Free)
```bash
# One-time setup
npm install -g vercel
vercel login

# Deploy
cd frontend
vercel --prod
```

#### Deploy Backend to Railway (Free)
1. Visit railway.app
2. "New Project" → "Deploy from GitHub"
3. Select your repo
4. Add environment variables
5. Deploy!

## Pro Tips for Cursor

### 1. Use Cursor Rules
Create `.cursorrules` file:
```
- Always use TypeScript strict mode
- Add error handling to all async functions
- Follow the existing code style
- Add JSDoc comments for exported functions
- Use the Logger utility for logging
```

### 2. Quick Commands
- `Cmd+Shift+P` → "Cursor: Chat"
- `Cmd+L` → Open AI chat
- `Cmd+K` → Inline AI edit
- `Cmd+I` → Ask about selection

### 3. Context Awareness
Cursor understands your whole codebase:
- "@workspace How do I add authentication?"
- "@file Explain this component"
- "@code What does this function do?"

### 4. Rapid Prototyping Workflow

```bash
# 1. Ask Cursor to generate prototype idea
"Create a prototype for email subject line optimization"

# 2. Review and refine the code
"Add rate limiting and caching to this"

# 3. Test with Cursor terminal
curl -X POST http://localhost:3001/api/prototypes/email-optimizer

# 4. Deploy when ready
git push && vercel --prod
```

## Common Cursor AI Prompts for This Framework

### Adding Features
- "Add streaming support to this AI route"
- "Create a frontend component for this API endpoint"
- "Add database persistence to this prototype"

### Debugging
- "Why isn't the MongoDB connection working?"
- "Fix this CORS error"
- "Debug this TypeScript type error"

### Optimization
- "Make this AI request faster"
- "Reduce the number of tokens used"
- "Cache these API responses"

### Testing
- "Write unit tests for this route"
- "Create integration tests"
- "Generate test data"

## Deployment from Cursor

### Option 1: Vercel (Frontend)
```bash
# In Cursor terminal
cd frontend
vercel
```

### Option 2: Railway (Backend)
```bash
# Connect Railway CLI
npm i -g @railway/cli
railway login
railway init
railway up
```

### Option 3: GitHub Actions (Auto-deploy)
Cursor can help you set up CI/CD:
- Ask: "Create a GitHub Action to deploy to Vercel on push"

## Keyboard Shortcuts

| Action | Mac | Windows |
|--------|-----|---------|
| AI Chat | `Cmd+L` | `Ctrl+L` |
| Inline Edit | `Cmd+K` | `Ctrl+K` |
| Terminal | `Cmd+`` | `Ctrl+`` |
| Command Palette | `Cmd+Shift+P` | `Ctrl+Shift+P` |
| File Search | `Cmd+P` | `Ctrl+P` |

## Example: Building a Prototype in Cursor

### Step-by-Step with AI

1. **Open Chat** (`Cmd+L`):
   ```
   Create a new prototype for recipe generation from ingredients.
   Use the existing prototypes as templates.
   ```

2. **Review Generated Code** in chat

3. **Create File** `backend/src/routes/prototypes/recipe-generator.routes.ts`

4. **Paste and Refine** with Cursor's suggestions

5. **Register Route** - Cursor will auto-suggest the import

6. **Test** in terminal:
   ```bash
   curl -X POST http://localhost:3001/api/prototypes/recipe-generator/generate \
     -H "Content-Type: application/json" \
     -d '{"ingredients": ["chicken", "rice", "tomatoes"]}'
   ```

7. **Deploy**:
   ```bash
   git add . && git commit -m "Add recipe generator"
   git push
   ```

---

Cursor makes rapid AI prototyping even faster with intelligent code suggestions and AI assistance!
