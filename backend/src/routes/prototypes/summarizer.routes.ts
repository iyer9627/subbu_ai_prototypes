import { Router, Request, Response } from 'express';
import { AIService } from '@ai-proto/ai-services';
import { AIProvider, AIModel } from '@ai-proto/shared';
import { Logger } from '@ai-proto/shared';

const router = Router();
const logger = new Logger('SummarizerRoutes');

const aiService = new AIService({
  defaultProvider: AIProvider.ANTHROPIC,
  apiKeys: {
    anthropic: process.env.ANTHROPIC_API_KEY!,
    openai: process.env.OPENAI_API_KEY
  }
});

/**
 * POST /api/prototypes/summarizer/summarize
 * Summarize text with specified length
 */
router.post('/summarize', async (req: Request, res: Response) => {
  try {
    const { text, length = 'medium', style = 'professional' } = req.body;

    if (!text) {
      return res.status(400).json({
        success: false,
        error: 'Text is required'
      });
    }

    logger.info('Summarizing text', {
      textLength: text.length,
      length,
      style
    });

    const lengthInstructions = {
      short: '2-3 concise sentences',
      medium: '1 paragraph (4-6 sentences)',
      long: '2-3 detailed paragraphs',
      bullet: '5-7 bullet points'
    };

    const styleInstructions = {
      professional: 'Use professional, formal language',
      casual: 'Use casual, conversational language',
      technical: 'Use precise technical language',
      simple: 'Use simple language suitable for general audiences'
    };

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `Summarize the following text in ${lengthInstructions[length as keyof typeof lengthInstructions] || lengthInstructions.medium}.

Style: ${styleInstructions[style as keyof typeof styleInstructions] || styleInstructions.professional}

Text to summarize:
${text}

Provide a clear, accurate summary that captures the main points and key information.`
      }],
      temperature: 0.5,
      maxTokens: 1000
    });

    logger.info('Text summarized successfully');

    res.json({
      success: true,
      summary: response.content,
      metadata: {
        originalLength: text.length,
        summaryLength: response.content.length,
        compressionRatio: (response.content.length / text.length * 100).toFixed(2) + '%',
        length,
        style,
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Failed to summarize text', error as Error);
    res.status(500).json({
      success: false,
      error: 'Failed to summarize text. Please try again.'
    });
  }
});

/**
 * POST /api/prototypes/summarizer/extract-key-points
 * Extract key points from text
 */
router.post('/extract-key-points', async (req: Request, res: Response) => {
  try {
    const { text, numberOfPoints = 5 } = req.body;

    if (!text) {
      return res.status(400).json({
        success: false,
        error: 'Text is required'
      });
    }

    logger.info('Extracting key points', { textLength: text.length, numberOfPoints });

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `Extract the ${numberOfPoints} most important key points from the following text.

Text:
${text}

Format your response as a numbered list of key points. Each point should be:
- Clear and concise
- Capture a distinct main idea
- Be actionable or informative

Focus on the most critical information.`
      }],
      temperature: 0.4,
      maxTokens: 800
    });

    res.json({
      success: true,
      keyPoints: response.content,
      metadata: {
        numberOfPoints,
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Failed to extract key points', error as Error);
    res.status(500).json({
      success: false,
      error: 'Failed to extract key points. Please try again.'
    });
  }
});

export default router;
