import dotenv from 'dotenv';
import { AIProvider, DatabaseType } from '@ai-proto/shared';

dotenv.config();

export const config = {
  port: parseInt(process.env.BACKEND_PORT || '3001', 10),
  nodeEnv: process.env.NODE_ENV || 'development',

  database: {
    type: (process.env.DATABASE_TYPE as DatabaseType) || DatabaseType.MONGODB,
    mongodb: {
      uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/ai_prototypes'
    },
    supabase: {
      url: process.env.SUPABASE_URL || '',
      anonKey: process.env.SUPABASE_ANON_KEY || '',
      serviceKey: process.env.SUPABASE_SERVICE_KEY || ''
    }
  },

  ai: {
    defaultProvider: (process.env.AI_PROVIDER as AIProvider) || AIProvider.ANTHROPIC,
    apiKeys: {
      anthropic: process.env.ANTHROPIC_API_KEY,
      openai: process.env.OPENAI_API_KEY
    }
  },

  auth: {
    jwtSecret: process.env.JWT_SECRET || 'your-secret-key-change-in-production',
    jwtExpiresIn: '7d'
  },

  cors: {
    origin: process.env.CORS_ORIGIN || 'http://localhost:3000'
  },

  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000', 10),
    max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100', 10)
  },

  aws: {
    region: process.env.AWS_REGION || 'us-east-1',
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
  },

  cloudwatch: {
    enabled: process.env.CLOUDWATCH_ENABLED === 'true',
    logGroup: process.env.CLOUDWATCH_LOG_GROUP || '/ai-prototypes/app'
  }
};
