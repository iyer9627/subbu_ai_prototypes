import { Router } from 'express';
import { AIService } from '@ai-proto/ai-services';
import { AIRequestSchema, Logger, BadRequestError } from '@ai-proto/shared';
import { authenticate } from '../middleware';
import { config } from '../config';

const router = Router();
const logger = new Logger('AIRoutes');

const aiService = new AIService({
  defaultProvider: config.ai.defaultProvider,
  apiKeys: config.ai.apiKeys
});

router.post('/chat', authenticate, async (req, res, next) => {
  try {
    const validatedRequest = AIRequestSchema.parse(req.body);

    logger.info('Processing chat request', {
      provider: validatedRequest.provider,
      model: validatedRequest.model
    });

    const response = await aiService.sendRequest(validatedRequest);

    res.json({
      success: true,
      data: response
    });
  } catch (error) {
    next(error instanceof Error ? error : new BadRequestError('Invalid request'));
  }
});

router.post('/chat/stream', authenticate, async (req, res, next) => {
  try {
    const validatedRequest = AIRequestSchema.parse(req.body);

    logger.info('Processing stream chat request', {
      provider: validatedRequest.provider,
      model: validatedRequest.model
    });

    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    for await (const chunk of aiService.streamRequest(validatedRequest)) {
      res.write(`data: ${JSON.stringify(chunk)}\n\n`);
    }

    res.end();
  } catch (error) {
    next(error instanceof Error ? error : new BadRequestError('Invalid request'));
  }
});

export default router;
