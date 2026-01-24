import { DatabaseType } from '@ai-proto/shared';
import { config } from '../config';
import { MongoDBClient } from './mongodb-client';
import { SupabaseClientWrapper } from './supabase-client';

export async function initializeDatabase() {
  if (config.database.type === DatabaseType.MONGODB) {
    const mongoClient = MongoDBClient.getInstance();
    await mongoClient.connect();
    return mongoClient;
  } else if (config.database.type === DatabaseType.SUPABASE) {
    return SupabaseClientWrapper.getInstance();
  } else {
    throw new Error(`Unsupported database type: ${config.database.type}`);
  }
}

export * from './mongodb-client';
export * from './supabase-client';
export * from './models';
