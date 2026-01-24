import mongoose from 'mongoose';
import { Logger } from '@ai-proto/shared';
import { config } from '../config';

export class MongoDBClient {
  private static instance: MongoDBClient;
  private logger: Logger;

  private constructor() {
    this.logger = new Logger('MongoDBClient');
  }

  static getInstance(): MongoDBClient {
    if (!MongoDBClient.instance) {
      MongoDBClient.instance = new MongoDBClient();
    }
    return MongoDBClient.instance;
  }

  async connect(): Promise<void> {
    try {
      await mongoose.connect(config.database.mongodb.uri);
      this.logger.info('Connected to MongoDB successfully');
    } catch (error) {
      this.logger.error('Failed to connect to MongoDB', error as Error);
      throw error;
    }
  }

  async disconnect(): Promise<void> {
    try {
      await mongoose.disconnect();
      this.logger.info('Disconnected from MongoDB');
    } catch (error) {
      this.logger.error('Failed to disconnect from MongoDB', error as Error);
      throw error;
    }
  }

  getConnection() {
    return mongoose.connection;
  }
}
