import { Router } from 'express';
import aiRoutes from './ai.routes';
import authRoutes from './auth.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/ai', aiRoutes);

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
