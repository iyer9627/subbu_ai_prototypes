import { Router, Request, Response } from 'express';
import { AIService } from '@ai-proto/ai-services';
import { AIProvider, AIModel } from '@ai-proto/shared';
import { Logger } from '@ai-proto/shared';

const router = Router();
const logger = new Logger('CodeReviewerRoutes');

const aiService = new AIService({
  defaultProvider: AIProvider.ANTHROPIC,
  apiKeys: {
    anthropic: process.env.ANTHROPIC_API_KEY!,
    openai: process.env.OPENAI_API_KEY
  }
});

/**
 * POST /api/prototypes/code-reviewer/review
 * Review code and provide feedback
 */
router.post('/review', async (req: Request, res: Response) => {
  try {
    const { code, language = 'javascript' } = req.body;

    if (!code) {
      return res.status(400).json({
        success: false,
        error: 'Code is required'
      });
    }

    logger.info('Reviewing code', { language, codeLength: code.length });

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `Review this ${language} code and provide comprehensive feedback on:
1. Code quality and adherence to best practices
2. Potential bugs or logical errors
3. Performance improvements and optimizations
4. Security concerns and vulnerabilities
5. Readability and maintainability

Code to review:
\`\`\`${language}
${code}
\`\`\`

Please provide your review in a clear, structured format with specific examples and suggestions.`
      }],
      temperature: 0.3,
      maxTokens: 2000
    });

    logger.info('Code review completed successfully');

    res.json({
      success: true,
      review: response.content,
      metadata: {
        language,
        codeLength: code.length,
        reviewLength: response.content.length,
        model: AIModel.CLAUDE_SONNET,
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Failed to review code', error as Error);
    res.status(500).json({
      success: false,
      error: 'Failed to review code. Please try again.'
    });
  }
});

/**
 * POST /api/prototypes/code-reviewer/explain
 * Explain what the code does in plain English
 */
router.post('/explain', async (req: Request, res: Response) => {
  try {
    const { code, language = 'javascript', audience = 'beginner' } = req.body;

    if (!code) {
      return res.status(400).json({
        success: false,
        error: 'Code is required'
      });
    }

    logger.info('Explaining code', { language, audience });

    const audienceInstructions = {
      beginner: 'Explain in simple terms that a beginner programmer would understand',
      intermediate: 'Explain with moderate technical detail for someone with programming experience',
      expert: 'Provide a technical explanation with implementation details'
    };

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `${audienceInstructions[audience as keyof typeof audienceInstructions] || audienceInstructions.beginner}.

Code:
\`\`\`${language}
${code}
\`\`\`

Explain:
- What this code does
- How it works (step by step)
- Any important concepts or patterns used
- When you might use code like this`
      }],
      temperature: 0.5,
      maxTokens: 1500
    });

    res.json({
      success: true,
      explanation: response.content,
      metadata: {
        language,
        audience,
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Failed to explain code', error as Error);
    res.status(500).json({
      success: false,
      error: 'Failed to explain code. Please try again.'
    });
  }
});

export default router;
