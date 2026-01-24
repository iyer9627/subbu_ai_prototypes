import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { Logger } from '@ai-proto/shared';
import { config } from './config';
import { initializeDatabase } from './database';
import { errorHandler, apiRateLimiter } from './middleware';
import routes from './routes';

const app = express();
const logger = new Logger('Server');

// Middleware
app.use(helmet());
app.use(cors({ origin: config.cors.origin }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(apiRateLimiter);

// Routes
app.use('/api', routes);

// Error handling
app.use(errorHandler);

// Start server
async function start() {
  try {
    // Initialize database
    await initializeDatabase();
    logger.info('Database initialized successfully');

    // Start Express server
    app.listen(config.port, () => {
      logger.info(`Server running on port ${config.port}`, {
        nodeEnv: config.nodeEnv,
        databaseType: config.database.type
      });
    });
  } catch (error) {
    logger.error('Failed to start server', error as Error);
    process.exit(1);
  }
}

start();
