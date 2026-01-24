import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { Logger } from '@ai-proto/shared';
import { config } from '../config';

export class SupabaseClientWrapper {
  private static instance: SupabaseClientWrapper;
  private client: SupabaseClient;
  private logger: Logger;

  private constructor() {
    this.logger = new Logger('SupabaseClient');

    if (!config.database.supabase.url || !config.database.supabase.serviceKey) {
      throw new Error('Supabase URL and service key are required');
    }

    this.client = createClient(
      config.database.supabase.url,
      config.database.supabase.serviceKey
    );

    this.logger.info('Supabase client initialized');
  }

  static getInstance(): SupabaseClientWrapper {
    if (!SupabaseClientWrapper.instance) {
      SupabaseClientWrapper.instance = new SupabaseClientWrapper();
    }
    return SupabaseClientWrapper.instance;
  }

  getClient(): SupabaseClient {
    return this.client;
  }
}
