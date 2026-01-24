import { Router } from 'express';
import aiRoutes from './ai.routes';
import authRoutes from './auth.routes';
import codeReviewerRoutes from './prototypes/code-reviewer.routes';
import summarizerRoutes from './prototypes/summarizer.routes';
import interviewPracticeRoutes from './prototypes/interview-practice.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/ai', aiRoutes);

// Prototype routes - ready-to-use AI prototypes
router.use('/prototypes/code-reviewer', codeReviewerRoutes);
router.use('/prototypes/summarizer', summarizerRoutes);
router.use('/prototypes/interview-practice', interviewPracticeRoutes);

router.get('/health', (_req, res) => {
  res.json({
    success: true,
    data: {
      status: 'healthy',
      timestamp: new Date().toISOString()
    }
  });
});

export default router;
