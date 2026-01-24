import { Router, Request, Response } from 'express';
import { AIService } from '@ai-proto/ai-services';
import { AIProvider, AIModel } from '@ai-proto/shared';
import { Logger } from '@ai-proto/shared';

const router = Router();
const logger = new Logger('InterviewPracticeRoutes');

const aiService = new AIService({
  defaultProvider: AIProvider.ANTHROPIC,
  apiKeys: {
    anthropic: process.env.ANTHROPIC_API_KEY!,
    openai: process.env.OPENAI_API_KEY
  }
});

/**
 * POST /api/prototypes/interview-practice/generate-questions
 * Generate interview questions for a specific role
 */
router.post('/generate-questions', async (req: Request, res: Response) => {
  try {
    const {
      jobRole = 'Software Engineer',
      difficulty = 'medium',
      numberOfQuestions = 5,
      focusAreas = []
    } = req.body;

    logger.info('Generating interview questions', { jobRole, difficulty, numberOfQuestions });

    const difficultyDescriptions = {
      easy: 'entry-level questions suitable for junior candidates',
      medium: 'intermediate questions for mid-level professionals',
      hard: 'advanced questions for senior-level candidates',
      expert: 'expert-level questions for principal/staff engineers'
    };

    const focusAreasText = focusAreas.length > 0
      ? `Focus especially on: ${focusAreas.join(', ')}`
      : '';

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `You are an expert technical interviewer. Generate ${numberOfQuestions} ${difficultyDescriptions[difficulty as keyof typeof difficultyDescriptions] || difficultyDescriptions.medium} for a ${jobRole} position.

${focusAreasText}

For each question, provide:
1. The question itself
2. What you're evaluating (skills/knowledge being tested)
3. Key points a strong candidate should mention
4. Red flags or common mistakes to watch for

Format your response clearly with numbered questions and subsections.`
      }],
      temperature: 0.7,
      maxTokens: 2500
    });

    logger.info('Interview questions generated successfully');

    res.json({
      success: true,
      questions: response.content,
      metadata: {
        jobRole,
        difficulty,
        numberOfQuestions,
        focusAreas,
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Failed to generate interview questions', error as Error);
    res.status(500).json({
      success: false,
      error: 'Failed to generate interview questions. Please try again.'
    });
  }
});

/**
 * POST /api/prototypes/interview-practice/evaluate-answer
 * Evaluate a candidate's answer to an interview question
 */
router.post('/evaluate-answer', async (req: Request, res: Response) => {
  try {
    const { question, answer, jobRole = 'Software Engineer' } = req.body;

    if (!question || !answer) {
      return res.status(400).json({
        success: false,
        error: 'Both question and answer are required'
      });
    }

    logger.info('Evaluating interview answer', {
      jobRole,
      questionLength: question.length,
      answerLength: answer.length
    });

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages: [{
        role: 'user',
        content: `As an expert interviewer for a ${jobRole} position, evaluate this candidate's answer.

Interview Question:
${question}

Candidate's Answer:
${answer}

Provide a comprehensive evaluation including:
1. **Overall Score**: Rate from 1-10 with brief justification
2. **Strengths**: What the candidate did well
3. **Weaknesses**: What was missing or could be improved
4. **Technical Accuracy**: Are there any factual errors?
5. **Communication**: How well did they explain their thinking?
6. **Suggestions**: Specific ways to improve the answer
7. **Example Better Answer**: Show key points of an excellent response

Be constructive and specific in your feedback.`
      }],
      temperature: 0.5,
      maxTokens: 2000
    });

    logger.info('Answer evaluation completed');

    res.json({
      success: true,
      evaluation: response.content,
      metadata: {
        jobRole,
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Failed to evaluate answer', error as Error);
    res.status(500).json({
      success: false,
      error: 'Failed to evaluate answer. Please try again.'
    });
  }
});

/**
 * POST /api/prototypes/interview-practice/mock-interview
 * Start a mock interview conversation
 */
router.post('/mock-interview', async (req: Request, res: Response) => {
  try {
    const {
      jobRole = 'Software Engineer',
      interviewType = 'technical',
      conversationHistory = []
    } = req.body;

    logger.info('Starting mock interview', { jobRole, interviewType });

    const interviewTypeInstructions = {
      technical: 'a technical interview focusing on coding, algorithms, and system design',
      behavioral: 'a behavioral interview focusing on past experiences and soft skills',
      system_design: 'a system design interview for architecture and scalability',
      cultural: 'a cultural fit interview about values and working style'
    };

    // Build conversation context
    const messages = [
      {
        role: 'user' as const,
        content: `You are conducting ${interviewTypeInstructions[interviewType as keyof typeof interviewTypeInstructions] || interviewTypeInstructions.technical} for a ${jobRole} position.

${conversationHistory.length === 0 ? 'Start the interview with a warm greeting and your first question.' : 'Continue the interview naturally based on the conversation so far.'}

Keep your responses professional, encouraging, and focused. Ask follow-up questions when appropriate.`
      }
    ];

    // Add conversation history if exists
    if (conversationHistory.length > 0) {
      conversationHistory.forEach((msg: { role: string; content: string }) => {
        messages.push({
          role: msg.role as 'user' | 'assistant',
          content: msg.content
        });
      });
    }

    const response = await aiService.sendRequest({
      provider: AIProvider.ANTHROPIC,
      model: AIModel.CLAUDE_SONNET,
      messages,
      temperature: 0.7,
      maxTokens: 1000
    });

    res.json({
      success: true,
      interviewerMessage: response.content,
      metadata: {
        jobRole,
        interviewType,
        conversationLength: conversationHistory.length,
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    logger.error('Failed to conduct mock interview', error as Error);
    res.status(500).json({
      success: false,
      error: 'Failed to conduct mock interview. Please try again.'
    });
  }
});

export default router;
